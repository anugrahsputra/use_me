import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';

import '../../helper/mocks.dart';

class _TestErrorHandler extends ErrorInterceptorHandler {
  DioException? lastError;

  @override
  void reject(DioException exception) {
    lastError = exception;
  }
}

void main() {
  late MockDio mockDio;
  late MockLocalStorageManager mockLocalStore;
  late MockClientRequestRetrier mockRetrier;
  late ClientInterceptor interceptor;
  late RequestOptions requestOptions;

  setUpAll(() {
    F.appFlavor = Flavor.latte;
    dotenv.loadFromString(envString: 'API_KEY=test_key');
  });

  setUp(() {
    Logger.root.level = Level.OFF;

    mockDio = MockDio();
    mockLocalStore = MockLocalStorageManager();
    mockRetrier = MockClientRequestRetrier();

    final sl = GetIt.instance;
    sl.reset();
    sl.registerFactory<Dio>(() => mockDio, instanceName: 'interceptor');

    interceptor = ClientInterceptor(
      localStoreManager: mockLocalStore,
      requestRetrier: mockRetrier,
    );

    requestOptions = RequestOptions(path: '/test');
  });

  group('onRequest', () {
    test('adds default headers and calls super', () {
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(requestOptions, handler);

      expect(requestOptions.headers['Content-Type'], 'application/json');
      verifyNever(mockDio.get(any));
    });

    test('formats request body when data present', () {
      requestOptions.data = {'key': 'value'};
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(requestOptions, handler);

      expect(requestOptions.headers['Content-Type'], 'application/json');
    });

    test('formats FormData request body', () {
      requestOptions.data = FormData.fromMap({'file': 'data'});
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(requestOptions, handler);

      expect(requestOptions.headers['Content-Type'], 'application/json');
    });

    test('formats string request body with toString', () {
      requestOptions.data = 'raw string';
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(requestOptions, handler);

      expect(requestOptions.headers['Content-Type'], 'application/json');
    });

    test('handles non-serializable request body gracefully', () {
      requestOptions.data = <String, dynamic>{'key': Object()};
      final handler = RequestInterceptorHandler();

      interceptor.onRequest(requestOptions, handler);

      expect(requestOptions.headers['Content-Type'], 'application/json');
    });
  });

  group('constructor', () {
    test('uses default requestRetrier when not provided', () {
      final sl = GetIt.instance;
      sl.registerFactory<Dio>(() => mockDio, instanceName: 'interceptor');

      final defaultInterceptor = ClientInterceptor(
        localStoreManager: mockLocalStore,
      );
      expect(defaultInterceptor, isA<ClientInterceptor>());
    });
  });

  group('onResponse', () {
    test('calls handler.next for normal response', () {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'ok': true},
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      expect(handler.isCompleted, isTrue);
    });

    test('handles string response data', () {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: '{"key": "value"}',
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      expect(handler.isCompleted, isTrue);
    });

    test('logs cache hit on 304', () {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 304,
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      expect(handler.isCompleted, isTrue);
    });
  });

  group('onError', () {
    DioException _error(int statusCode, {DioExceptionType type = DioExceptionType.badResponse}) {
      return DioException(
        requestOptions: requestOptions,
        type: type,
        response: Response(
          requestOptions: requestOptions,
          statusCode: statusCode,
          data: statusCode == 400 ? {'error': 'invalid input'} : {},
        ),
      );
    }

    test('400 returns BadRequestException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(_error(400), handler);
      expect(handler.lastError?.error, isA<BadRequestException>());
      expect((handler.lastError?.error as BadRequestException).message, 'invalid input');
    });

    test('401 with successful refresh retries request', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(mockDio.post(
        '/auth/refresh',
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        data: {'access_token': 'new_access', 'refresh_token': 'new_refresh'},
      ));

      when(mockDio.request(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: 'retried',
      ));

      final handler = _TestErrorHandler();
      await interceptor.onError(_error(401), handler);
      expect(handler.isCompleted, isTrue);
    });

    test('401 without refresh token clears storage and rejects', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => null);

      final handler = _TestErrorHandler();
      await interceptor.onError(_error(401), handler);
      expect(handler.lastError?.error, isA<UnauthorizedException>());
      verify(mockLocalStore.deleteFromStorage('access_token')).called(1);
      verify(mockLocalStore.deleteFromStorage('refresh_token')).called(1);
    });

    test('401 with successful refresh but retry fails', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(mockDio.post(
        '/auth/refresh',
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        data: {'access_token': 'new_access', 'refresh_token': 'new_refresh'},
      ));
      when(mockDio.request(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(Exception('retry failed'));

      when(mockLocalStore.writeToStorage(any, any))
          .thenAnswer((_) async {});
      when(mockLocalStore.deleteFromStorage(any))
          .thenAnswer((_) async {});

      final handler = _TestErrorHandler();
      await interceptor.onError(_error(401), handler);
      expect(handler.lastError?.error, isA<UnauthorizedException>());
      verify(mockLocalStore.deleteFromStorage('access_token')).called(1);
      verify(mockLocalStore.deleteFromStorage('refresh_token')).called(1);
    });

    test('second 401 while refreshing queues and retries', () async {
      final refreshCompleter = Completer<Response>();

      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(mockLocalStore.readFromStorage('access_token'))
          .thenAnswer((_) async => 'new_access');
      when(mockDio.post(
        '/auth/refresh',
        data: anyNamed('data'),
      )).thenAnswer((_) => refreshCompleter.future);

      when(mockDio.request(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: 'retried',
      ));

      when(mockLocalStore.writeToStorage(any, any))
          .thenAnswer((_) async {});
      when(mockLocalStore.deleteFromStorage(any))
          .thenAnswer((_) async {});

      final handler1 = _TestErrorHandler();
      final handler2 = _TestErrorHandler();

      unawaited(interceptor.onError(_error(401), handler1));
      await Future.delayed(Duration.zero);

      await interceptor.onError(_error(401), handler2);

      refreshCompleter.complete(Response(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        data: {'access_token': 'new_access', 'refresh_token': 'new_refresh'},
      ));

      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);

      expect(handler1.isCompleted, isTrue);
      expect(handler2.isCompleted, isTrue);
    });

    test('401 with failed refresh clears storage and rejects', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(mockDio.post(
        '/auth/refresh',
        data: anyNamed('data'),
      )).thenThrow(Exception('refresh failed'));

      final handler = _TestErrorHandler();
      await interceptor.onError(_error(401), handler);
      expect(handler.lastError?.error, isA<UnauthorizedException>());
      verify(mockLocalStore.deleteFromStorage('access_token')).called(1);
      verify(mockLocalStore.deleteFromStorage('refresh_token')).called(1);
    });

    test('403 returns ForbiddenException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(_error(403), handler);
      expect(handler.lastError?.error, isA<ForbiddenException>());
    });

    test('404 returns NotFoundException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(_error(404), handler);
      expect(handler.lastError?.error, isA<NotFoundException>());
    });

    test('connection error triggers retrier', () async {
      when(mockRetrier.retryRequest(any)).thenAnswer((_) async => Response(
        requestOptions: requestOptions,
        statusCode: 200,
      ));

      final err = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        response: Response(requestOptions: RequestOptions(path: '/test')),
      );
      final handler = _TestErrorHandler();
      await interceptor.onError(err, handler);

      expect(handler.isCompleted, isTrue);
      verify(mockRetrier.retryRequest(requestOptions)).called(1);
    });

    test('connection error with retrier failure returns NetworkException', () async {
      when(mockRetrier.retryRequest(any)).thenThrow(NetworkException());

      final err = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        response: Response(requestOptions: RequestOptions(path: '/test')),
      );
      final handler = _TestErrorHandler();
      await interceptor.onError(err, handler);
      expect(handler.lastError?.error, isA<NetworkException>());
    });

    test('non-connection error returns UnknownException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(_error(500), handler);
      expect(handler.lastError?.error, isA<UnknownException>());
    });
  });
}
