import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:use_me/core/utils/app_logging.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';


class ClientInterceptor extends Interceptor with InterceptorMixin {
  ClientInterceptor({
    required this.dio,
    ClientRequestRetrier? requestRetrier,
    required this.localStoreManager,
  }) : requestRetrier =
           requestRetrier ??
           ClientRequestRetrier(
             dio: dio,
             internetConnectionChecker:
                 InternetConnectionChecker.createInstance(),
           );

  final Dio dio;
  final LocalStorageManager localStoreManager;
  final ClientRequestRetrier requestRetrier;
  bool _isRefreshing = false;
  final List<Function> _retryQueue = [];

  String _formatRequestBody(dynamic data) {
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      } else if (data is FormData) {
        final fields = data.fields
            .map((e) => '${e.key}: ${e.value}')
            .join(', ');
        final files = data.files
            .map((e) => '${e.key}: ${e.value.filename}')
            .join(', ');
        return 'FormData: { fields: {$fields}, files: {$files} }';
      } else {
        return data.toString();
      }
    } catch (e) {
      return 'Could not format request body: $e';
    }
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await localStoreManager.readFromStorage(
      'refresh_token',
    );
    if (refreshToken == null) return null;

    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await localStoreManager.writeToStorage(
        'access_token',
        newAccessToken.toString(),
      );
      await localStoreManager.writeToStorage(
        'refresh_token',
        newRefreshToken.toString(),
      );
      return newAccessToken.toString();
    } catch (e) {
      talker.error('Token refresh failed: $e');
      return null;
    }
  }

  Future<Response<T>> _retryRequest<T>(
    RequestOptions requestOptions, {
    String? newToken,
  }) async {
    final headers = Map<String, dynamic>.from(requestOptions.headers);

    if (newToken != null) {
      headers['Authorization'] = 'Bearer $newToken';
    }

    final options = Options(method: requestOptions.method, headers: headers);
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    talker
      ..debug('➡️ Request [${options.method}] => URL: ${options.uri}')
      ..debug('➡️ Headers: ${options.headers}')
      ..info('➡️ On Send Progress: ${options.onSendProgress}');

    if (options.data != null) {
      talker.debug('➡️ Body: ${_formatRequestBody(options.data)}');
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['x-api-key'] = F.apiKey;

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    talker.debug('Response: ${response.requestOptions.uri}');
    if (response.data is String) {
      jsonDecode(response.data as String);
    }
    if (response.statusCode == 304) {
      talker.warning('cache hit: ${response.requestOptions.uri}');
    }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    talker
      ..error('Error: ${err.requestOptions.uri}')
      ..error('Error: ${err.response!.data}')
      ..error('Error: ${err.response!.statusCode}');

    switch (err.response?.statusCode) {
      case 400:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: BadRequestException(
              message: err.response!.data['error'] as String,
            ),
          ),
        );

      case 401:
        if (_isRefreshing) {
          _retryQueue.add(() async {
            final newToken = await localStoreManager.readFromStorage(
              'access_token',
            );
            final retryResponse = await _retryRequest(
              err.requestOptions,
              newToken: newToken,
            );
            handler.resolve(retryResponse);
          });
          return;
        }

        _isRefreshing = true;

        try {
          final newToken = await _refreshToken();

          if (newToken != null) {
            final queueResults = <Future<void>>[];
            for (final retry in _retryQueue) {
              queueResults.add(retry() as Future<void>);
            }

            await Future.wait(queueResults);
            _retryQueue.clear();

            final cloneReq = await _retryRequest(
              err.requestOptions,
              newToken: newToken,
            );
            _isRefreshing = false;
            return handler.resolve(cloneReq);
          } else {
            await localStoreManager.deleteFromStorage('access_token');
            await localStoreManager.deleteFromStorage('refresh_token');
            _isRefreshing = false;

            return handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: UnauthorizedException(message: 'Session expired'),
              ),
            );
          }
        } catch (e) {
          _isRefreshing = false;
          await localStoreManager.deleteFromStorage('access_token');
          await localStoreManager.deleteFromStorage('refresh_token');

          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: UnauthorizedException(
                message: 'Authentication failed: ${e.toString()}',
              ),
            ),
          );
        }

      case 403:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ForbiddenException(),
          ),
        );

      case 404:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: NotFoundException(),
          ),
        );

      default:
        // Connection errors have no status code — handle separately
        if (isConnectionError(err)) {
          try {
            talker.warning('Connection Error: ${err.requestOptions.uri}');
            final response = await requestRetrier.retryRequest(
              err.requestOptions,
            );
            return handler.resolve(response);
          } on NetworkException {
            talker.error('Connection Error: ${err.requestOptions.uri}');
            return handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: NetworkException(),
              ),
            );
          }
        }

        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnknownException(),
          ),
        );
    }
  }
}
