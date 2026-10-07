import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';

import '../../helper/mocks.dart';

const _noBody = Object();

String _setCookie(String value) =>
    'refresh_token=$value; Path=/auth; Domain=localhost; '
    'Max-Age=2592000; HttpOnly; SameSite=Lax';

Response<Map<String, dynamic>> _refreshResponse({
  String accessToken = 'new_access',
  String refreshToken = 'new_refresh',
}) => Response<Map<String, dynamic>>(
  requestOptions: RequestOptions(path: '/auth/refresh'),
  data: {
    'status': 200,
    'message': 'token refreshed',
    'data': {'access_token': accessToken, 'expires_in': 900},
  },
  headers: Headers.fromMap({
    'set-cookie': [_setCookie(refreshToken)],
  }),
);

class _TestErrorHandler extends ErrorInterceptorHandler {
  DioException? lastError;

  @override
  void reject(
    DioException exception, [
    bool callFollowingErrorInterceptor = false,
  ]) {
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
    Environment.apiKey = 'test_key';
  });

  setUp(() {
    mockDio = MockDio();
    mockLocalStore = MockLocalStorageManager();
    mockRetrier = MockClientRequestRetrier();

    interceptor = ClientInterceptor(
      dio: mockDio,
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

    test('adds x-api-key when an API key is configured', () {
      interceptor.onRequest(requestOptions, RequestInterceptorHandler());

      expect(requestOptions.headers['x-api-key'], 'test_key');
    });

    test('sets the header whatever shape the body has', () {
      for (final body in <Object>[
        {'key': 'value'},
        FormData.fromMap({'file': 'data'}),
        'raw string',
      ]) {
        final options = RequestOptions(path: '/test')..data = body;
        interceptor.onRequest(options, RequestInterceptorHandler());
        expect(options.headers['Content-Type'], 'application/json');
      }
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
      final defaultInterceptor = ClientInterceptor(
        dio: mockDio,
        localStoreManager: mockLocalStore,
      );
      expect(defaultInterceptor, isA<ClientInterceptor>());
    });
  });

  group('onResponse', () {
    test('calls handler.next for normal response', () async {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'ok': true},
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      await Future<void>.delayed(Duration.zero);
      expect(handler.isCompleted, isTrue);
    });

    test('handles string response data', () async {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: '{"key": "value"}',
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      await Future<void>.delayed(Duration.zero);
      expect(handler.isCompleted, isTrue);
    });

    test('persists the refresh_token cookie from a login response', () async {
      when(mockLocalStore.writeToStorage(any, any)).thenAnswer((_) async {});
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 200,
        data: {'access_token': 'access'},
        headers: Headers.fromMap({
          'set-cookie': [_setCookie('cookie_refresh')],
        }),
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      await Future<void>.delayed(Duration.zero);

      verify(mockLocalStore.writeToStorage('refresh_token', 'cookie_refresh'))
          .called(1);
    });

    test('ignores cookies other than refresh_token', () async {
      when(mockLocalStore.writeToStorage(any, any)).thenAnswer((_) async {});
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 200,
        headers: Headers.fromMap({
          'set-cookie': ['session=abc; Path=/', 'old_refresh_token=nope'],
        }),
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      await Future<void>.delayed(Duration.zero);

      verifyNever(mockLocalStore.writeToStorage('refresh_token', any));
    });

    test('logs cache hit on 304', () async {
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 304,
      );
      final handler = ResponseInterceptorHandler();

      interceptor.onResponse(response, handler);
      await Future<void>.delayed(Duration.zero);
      expect(handler.isCompleted, isTrue);
    });
  });

  group('onError', () {
    // The API answers every failure with {status, message}.
    DioException error(
      int statusCode, {
      DioExceptionType type = DioExceptionType.badResponse,
      Object? data = _noBody,
    }) {
      return DioException(
        requestOptions: requestOptions,
        type: type,
        response: Response(
          requestOptions: requestOptions,
          statusCode: statusCode,
          data: identical(data, _noBody)
              ? {'status': statusCode, 'message': 'server said no'}
              : data,
        ),
      );
    }

    test('400 returns BadRequestException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(error(400), handler);
      expect(handler.lastError?.error, isA<BadRequestException>());
      expect(
        (handler.lastError?.error as BadRequestException).message,
        'server said no',
      );
    });

    test('401 with successful refresh retries request', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(
        mockDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => _refreshResponse());

      when(
        mockDio.request(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          statusCode: 200,
          data: 'retried',
        ),
      );

      when(mockLocalStore.writeToStorage(any, any)).thenAnswer((_) async {});

      final handler = _TestErrorHandler();
      await interceptor.onError(error(401), handler);
      expect(handler.isCompleted, isTrue);

      // The stored refresh token goes back as a Cookie header, and the
      // rotated one from Set-Cookie replaces it.
      final options =
          verify(
                mockDio.post<Map<String, dynamic>>(
                  '/auth/refresh',
                  options: captureAnyNamed('options'),
                ),
              ).captured.single
              as Options;
      expect(options.headers?['cookie'], 'refresh_token=old_refresh');
      verify(mockLocalStore.writeToStorage('access_token', 'new_access'))
          .called(1);
      verify(mockLocalStore.writeToStorage('refresh_token', 'new_refresh'))
          .called(1);
    });

    test('401 without refresh token clears storage and rejects', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => null);

      final handler = _TestErrorHandler();
      await interceptor.onError(error(401), handler);
      expect(handler.lastError?.error, isA<UnauthorizedException>());
      verify(mockLocalStore.deleteFromStorage('access_token')).called(1);
      verify(mockLocalStore.deleteFromStorage('refresh_token')).called(1);
    });

    test('401 with successful refresh but retry fails', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(
        mockDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => _refreshResponse());
      when(
        mockDio.request(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenThrow(Exception('retry failed'));

      when(mockLocalStore.writeToStorage(any, any)).thenAnswer((_) async {});
      when(mockLocalStore.deleteFromStorage(any)).thenAnswer((_) async {});

      final handler = _TestErrorHandler();
      await interceptor.onError(error(401), handler);
      expect(handler.lastError?.error, isA<UnauthorizedException>());
      verify(mockLocalStore.deleteFromStorage('access_token')).called(1);
      verify(mockLocalStore.deleteFromStorage('refresh_token')).called(1);
    });

    test('401 refresh succeeds but the retry 409s keeps the session', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(
        mockDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => _refreshResponse());

      // The retry runs on the bare Dio, which has no ClientInterceptor, so a
      // non-2xx comes back as an untyped DioException.
      when(
        mockDio.request(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 409,
            data: {'status': 409, 'message': 'resource conflict'},
          ),
        ),
      );

      when(mockLocalStore.writeToStorage(any, any)).thenAnswer((_) async {});
      when(mockLocalStore.deleteFromStorage(any)).thenAnswer((_) async {});

      final handler = _TestErrorHandler();
      await interceptor.onError(error(401), handler);

      expect(handler.lastError?.error, isA<ConflictException>());
      expect(
        (handler.lastError?.error as ConflictException).message,
        'resource conflict',
      );
      verifyNever(mockLocalStore.deleteFromStorage('access_token'));
      verifyNever(mockLocalStore.deleteFromStorage('refresh_token'));
    });

    test('second 401 while refreshing queues and retries', () async {
      final refreshCompleter = Completer<Response<Map<String, dynamic>>>();

      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(mockLocalStore.readFromStorage('access_token'))
          .thenAnswer((_) async => 'new_access');
      when(
        mockDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) => refreshCompleter.future);

      when(
        mockDio.request(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          statusCode: 200,
          data: 'retried',
        ),
      );

      when(mockLocalStore.writeToStorage(any, any)).thenAnswer((_) async {});
      when(mockLocalStore.deleteFromStorage(any)).thenAnswer((_) async {});

      final handler1 = _TestErrorHandler();
      final handler2 = _TestErrorHandler();

      unawaited(interceptor.onError(error(401), handler1));
      await Future.delayed(Duration.zero);

      await interceptor.onError(error(401), handler2);

      refreshCompleter.complete(_refreshResponse());

      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);

      expect(handler1.isCompleted, isTrue);
      expect(handler2.isCompleted, isTrue);
    });

    test('401 with failed refresh clears storage and rejects', () async {
      when(mockLocalStore.readFromStorage('refresh_token'))
          .thenAnswer((_) async => 'old_refresh');
      when(
        mockDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          options: anyNamed('options'),
        ),
      ).thenThrow(Exception('refresh failed'));

      final handler = _TestErrorHandler();
      await interceptor.onError(error(401), handler);
      expect(handler.lastError?.error, isA<UnauthorizedException>());
      verify(mockLocalStore.deleteFromStorage('access_token')).called(1);
      verify(mockLocalStore.deleteFromStorage('refresh_token')).called(1);
    });

    test('403 returns ForbiddenException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(error(403), handler);
      expect(handler.lastError?.error, isA<ForbiddenException>());
      expect(
        (handler.lastError?.error as ForbiddenException).message,
        'server said no',
      );
    });

    test('404 returns NotFoundException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(error(404), handler);
      expect(handler.lastError?.error, isA<NotFoundException>());
      expect(
        (handler.lastError?.error as NotFoundException).message,
        'server said no',
      );
    });

    test(
      'rejects 409 with ConflictException carrying the server message',
      () async {
        final handler = _TestErrorHandler();
        await interceptor.onError(error(409), handler);
        expect(handler.lastError?.error, isA<ConflictException>());
        expect(
          (handler.lastError?.error as ConflictException).message,
          'server said no',
        );
      },
    );

    test('connection error triggers retrier', () async {
      when(mockRetrier.retryRequest(any)).thenAnswer(
        (_) async => Response(requestOptions: requestOptions, statusCode: 200),
      );

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

    test(
      'connection error with retrier failure returns NetworkException',
      () async {
        when(mockRetrier.retryRequest(any)).thenThrow(NetworkException());

        final err = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionError,
          response: Response(requestOptions: RequestOptions(path: '/test')),
        );
        final handler = _TestErrorHandler();
        await interceptor.onError(err, handler);
        expect(handler.lastError?.error, isA<NetworkException>());
      },
    );

    test('500 surfaces the server message as ServerException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(error(500), handler);
      expect(handler.lastError?.error, isA<ServerException>());
      expect(
        (handler.lastError?.error as ServerException).message,
        'server said no',
      );
    });

    test('error without a response returns UnknownException', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
        ),
        handler,
      );
      expect(handler.lastError?.error, isA<UnknownException>());
    });

    test('json body arriving as a raw string is still parsed', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(
        error(400, data: '{"status":400,"message":"email already taken"}'),
        handler,
      );
      expect(
        (handler.lastError?.error as BadRequestException).message,
        'email already taken',
      );
    });

    test('non-json body falls back to the default message', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(
        error(400, data: '<html>502 Bad Gateway</html>'),
        handler,
      );
      expect(
        (handler.lastError?.error as BadRequestException).message,
        'BadRequestException',
      );
    });

    test('body without a message falls back to the default', () async {
      final handler = _TestErrorHandler();
      await interceptor.onError(error(400, data: {'status': 400}), handler);
      expect(
        (handler.lastError?.error as BadRequestException).message,
        'BadRequestException',
      );
    });
  });

  group('wire logging is left to TalkerDioLogger', () {
    setUp(talker.cleanHistory);

    test('onRequest writes nothing to the log', () {
      requestOptions.data = {'key': 'value'};

      interceptor.onRequest(requestOptions, RequestInterceptorHandler());

      expect(talker.history, isEmpty);
    });

    // onResponse is `void ... async`, so its logging lands after an await
    // and cannot be awaited from here. Flush the microtask queue instead.
    Future<void> respond(int statusCode) async {
      interceptor.onResponse(
        Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: statusCode,
        ),
        ResponseInterceptorHandler(),
      );
      await Future<void>.delayed(Duration.zero);
    }

    test('onResponse writes nothing to the log on a plain 200', () async {
      await respond(200);

      expect(talker.history, isEmpty);
    });

    test(
      'a 304 still gets its own line, the dio logger cannot see it',
      () async {
        await respond(304);

        expect(talker.history, hasLength(1));
        expect(talker.history.single.generateTextMessage(), contains('cache'));
      },
    );

    test(
      'onError does not re-log the raw error the dio logger printed',
      () async {
        final handler = _TestErrorHandler();

        await interceptor.onError(
          DioException(
            requestOptions: requestOptions,
            response: Response<dynamic>(
              requestOptions: requestOptions,
              statusCode: 500,
              data: {'status': 500, 'message': 'kaboom'},
            ),
          ),
          handler,
        );

        expect(handler.lastError?.error, isA<ServerException>());
        expect(talker.history, isEmpty);
      },
    );
  });
}
