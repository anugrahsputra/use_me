import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  group('safeCall', () {
    test('returns Right on success', () async {
      final result = await safeCall(() async => 'success');
      expect(result, isA<Right<Failure, String>>());
      expect(result.getOrElse(() => ''), 'success');
    });

    test(
      'returns Left UnauthorizedFailure for UnauthorizedException',
      () async {
        final result = await safeCall<String>(() async {
          throw DioException(
            requestOptions: RequestOptions(path: '/test'),
            error: UnauthorizedException(message: 'unauthorized'),
          );
        });

        expect(result, isA<Left<Failure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'unauthorized'),
          (_) => fail('expected Left'),
        );
      },
    );

    test('returns Left RequestFailure for BadRequestException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: BadRequestException(message: 'bad request'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'bad request'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left ServerFailure for ServerException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: ServerException(message: 'server error'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'server error'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left NetworkFailure for NetworkException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: NetworkException(message: 'network error'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'network error'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left ForbiddenFailure for ForbiddenException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: ForbiddenException(message: 'forbidden'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'forbidden'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left RequestFailure for NotFoundException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: NotFoundException(message: 'not found'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'not found'),
        (_) => fail('expected Left'),
      );
    });

    test('maps ConflictException to ConflictFailure', () async {
      final result = await safeCall<int>(
        () async => throw DioException(
          requestOptions: RequestOptions(path: '/items/active'),
          error: ConflictException(message: 'resource conflict'),
        ),
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ConflictFailure>());
        expect(failure.message, 'resource conflict');
      }, (_) => fail('expected a Left'));
    });

    test('returns Left AuthFailure for AuthFailure', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: Failure.authFailure(message: 'auth failed'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'auth failed'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left CertificateFailure for CertificateException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: const CertificateException('cert error'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'cert error'),
        (_) => fail('expected Left'),
      );
    });

    test('keeps the underlying error for an unknown DioException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'some unknown error',
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'some unknown error'),
        (_) => fail('expected Left'),
      );
    });

    test('unwraps an UnknownException carried by a DioException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: UnknownException(message: 'no response from server'),
        );
      });

      result.fold(
        (failure) => expect(failure.message, 'no response from server'),
        (_) => fail('expected Left'),
      );
    });

    test('falls back to the constant when Dio knows nothing', () async {
      final result = await safeCall<String>(() async {
        throw DioException(requestOptions: RequestOptions(path: '/test'));
      });

      result.fold(
        (failure) => expect(failure.message, 'Unknown Dio error'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left CacheFailure for CacheException', () async {
      final result = await safeCall<String>(() async {
        throw CacheException(message: 'cache miss');
      });

      result.fold(
        (failure) => expect(failure.message, 'cache miss'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left DatabaseFailure for DatabaseException', () async {
      final result = await safeCall<String>(() async {
        throw DatabaseException(message: 'db error');
      });

      result.fold(
        (failure) => expect(failure.message, 'db error'),
        (_) => fail('expected Left'),
      );
    });

    test('returns Left Failure for UnknownException', () async {
      final result = await safeCall<String>(() async {
        throw UnknownException(message: 'weird');
      });

      result.fold(
        (failure) => expect(failure.message, 'weird'),
        (_) => fail('expected Left'),
      );
    });
  });

  group('safeCall logging', () {
    setUp(talker.cleanHistory);

    test('stays quiet on success', () async {
      await safeCall(() async => 'ok');
      expect(talker.history, isEmpty);
    });

    test('logs one FailureLog carrying the original exception', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        error: ServerException(message: 'boom'),
      );

      await safeCall<String>(() async => throw exception);

      expect(talker.history, hasLength(1));
      final entry = talker.history.single;
      expect(entry.key, FailureLog.logKey);
      expect(entry.logLevel, LogLevel.error);
      expect(entry.message, contains('ServerFailure'));
      expect(entry.message, contains('boom'));
      expect(entry.exception, same(exception));
      expect(entry.stackTrace, isNotNull);
    });

    test('names the failure the caller sees, not the exception thrown', () async {
      await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: NotFoundException(message: 'missing'),
        );
      });

      // NotFoundException collapses into RequestFailure. The log has to say
      // what the UI branches on, otherwise it cannot be traced back.
      expect(talker.history.single.message, contains('RequestFailure'));
    });

    test('logs the non-dio branches too', () async {
      await safeCall<String>(() async {
        throw CacheException(message: 'cold');
      });

      expect(talker.history.single.key, FailureLog.logKey);
      expect(talker.history.single.message, contains('CacheFailure'));
    });
  });
}
