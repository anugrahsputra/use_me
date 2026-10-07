import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';

class ClientInterceptor extends Interceptor {
  final Dio dio;

  final LocalStorageManager localStoreManager;
  final ClientRequestRetrier requestRetrier;
  bool _isRefreshing = false;
  final List<Function> _retryQueue = [];
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

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    switch (err.response?.statusCode) {
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

        final String? newToken;
        try {
          newToken = await _refreshToken();
        } catch (e) {
          _isRefreshing = false;
          await _clearTokens();
          return handler.reject(err.unauthorized('Authentication failed: $e'));
        }

        if (newToken == null) {
          _isRefreshing = false;
          await _clearTokens();
          return handler.reject(err.unauthorized());
        }

        try {
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
        } catch (e) {
          _isRefreshing = false;
          _retryQueue.clear();

          // The retry runs on the bare Dio, which carries no ClientInterceptor,
          // so its failures arrive untyped. The refresh above already
          // succeeded, so a status here belongs to the request itself, a 409
          // for instance. It must not be reported as a dead session, and must
          // not wipe the tokens we just rotated.
          if (e is DioException && e.response?.statusCode != 401) {
            final typed = e.toTyped();
            if (typed != null) return handler.reject(typed);
          }

          await _clearTokens();
          return handler.reject(err.unauthorized('Authentication failed: $e'));
        }

      default:
        // Connection errors have no status code — handle separately
        if (err.isConnectionError) {
          try {
            talker.warning('Connection Error: ${err.requestOptions.uri}');
            final response = await requestRetrier.retryRequest(
              err.requestOptions,
            );
            return handler.resolve(response);
          } on NetworkException {
            talker.error('Connection Error: ${err.requestOptions.uri}');
            return handler.reject(err.withError(NetworkException()));
          }
        }

        return handler.reject(
          err.toTyped() ?? err.withError(UnknownException()),
        );
    }
  }

  Future<void> _clearTokens() async {
    await localStoreManager.deleteFromStorage('access_token');
    await localStoreManager.deleteFromStorage('refresh_token');
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';
    if (F.apiKey.isNotEmpty) options.headers['x-api-key'] = F.apiKey;
    final authtoken = await localStoreManager.readFromStorage('access_token');
    if (authtoken != null) {
      options.headers['Authorization'] = 'Bearer $authtoken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    await _persistRefreshCookie(response.headers);
    if (response.data is String) {
      jsonDecode(response.data as String);
    }
    if (response.statusCode == 304) {
      talker.warning('cache hit: ${response.requestOptions.uri}');
    }
    super.onResponse(response, handler);
  }

  Future<void> _persistRefreshCookie(Headers headers) async {
    final token = _readRefreshCookie(headers);
    if (token == null) return;
    await localStoreManager.writeToStorage('refresh_token', token);
  }

  String? _readRefreshCookie(Headers headers) {
    final cookies = headers.map[HttpHeaders.setCookieHeader];
    if (cookies == null) return null;

    const name = 'refresh_token=';
    for (final cookie in cookies) {
      if (!cookie.startsWith(name)) continue;
      final value = cookie.substring(name.length);
      final end = value.indexOf(';');
      return end == -1 ? value : value.substring(0, end);
    }
    return null;
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await localStoreManager.readFromStorage(
      'refresh_token',
    );
    if (refreshToken == null) return null;

    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        options: Options(
          headers: {HttpHeaders.cookieHeader: 'refresh_token=$refreshToken'},
        ),
      );

      // Every endpoint answers with {status, message, data: {...}}.
      final body = response.data?['data'] as Map<String, dynamic>?;
      final newAccessToken = body?['access_token'] as String?;
      if (newAccessToken == null) {
        talker.error('Token refresh returned no access_token');
        return null;
      }

      await localStoreManager.writeToStorage('access_token', newAccessToken);
      await _persistRefreshCookie(response.headers);
      return newAccessToken;
    } catch (e) {
      talker.handle(e, null, 'Token refresh failed');
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
}
