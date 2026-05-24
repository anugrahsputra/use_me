import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

class _TestInterceptor extends Interceptor with InterceptorMixin {}

void main() {
  late _TestInterceptor interceptor;

  setUp(() {
    interceptor = _TestInterceptor();
  });

  group('isConnectionError', () {
    test('returns true for unknown type with SocketException', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.unknown,
        error: const SocketException('no route to host'),
      );
      expect(interceptor.isConnectionError(err), isTrue);
    });

    test('returns false for unknown type without SocketException', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.unknown,
        error: 'some string error',
      );
      expect(interceptor.isConnectionError(err), isFalse);
    });

    test('returns true for connectionError', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );
      expect(interceptor.isConnectionError(err), isTrue);
    });

    test('returns true for connectionTimeout', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );
      expect(interceptor.isConnectionError(err), isTrue);
    });

    test('returns false for badResponse', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: '/test')),
      );
      expect(interceptor.isConnectionError(err), isFalse);
    });
  });
}
