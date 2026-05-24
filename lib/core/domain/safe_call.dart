import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:use_me/core/core.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e) {
    final error = e.error;

    if (error is UnauthorizedException) {
      return Left(UnauthorizedFailure(message: error.message));
    } else if (error is BadRequestException) {
      return Left(RequestFailure(message: error.message));
    } else if (error is ServerException) {
      return Left(ServerFailure(message: error.message));
    } else if (error is NetworkException) {
      return Left(NetworkFailure(message: error.message));
    } else if (error is ForbiddenException) {
      return Left(ForbiddenFailure(message: error.message));
    } else if (error is NotFoundException) {
      return Left(RequestFailure(message: error.message));
    } else if (error is AuthFailure) {
      return Left(AuthFailure(message: error.message));
    } else if (error is CertificateException) {
      return Left(CertificateFailure(message: error.message));
    } else {
      return const Left(Failure.failure(message: 'Unknown Dio error'));
    }
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } on DatabaseException catch (e) {
    return Left(DatabaseFailure(message: e.message));
  } on UnknownException catch (e) {
    return Left(Failure.failure(message: e.message));
  }
}
