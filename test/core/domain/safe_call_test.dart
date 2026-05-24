import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('safeCall', () {
    test('returns Right on success', () async {
      final result = await safeCall(() async => 'success');
      expect(result, isA<Right<Failure, String>>());
      expect(result.getOrElse(() => ''), 'success');
    });

    test('returns Left UnauthorizedFailure for UnauthorizedException', () async {
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
    });

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

    test('returns Left Unknown for unknown DioException', () async {
      final result = await safeCall<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'some unknown error',
        );
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
}
