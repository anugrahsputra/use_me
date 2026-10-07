import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:use_me/core/core.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e, stackTrace) {
    return Left(_logged(_dioFailure(e), e, stackTrace));
  } on CacheException catch (e, stackTrace) {
    return Left(_logged(CacheFailure(message: e.message), e, stackTrace));
  } on DatabaseException catch (e, stackTrace) {
    return Left(_logged(DatabaseFailure(message: e.message), e, stackTrace));
  } on UnknownException catch (e, stackTrace) {
    return Left(
      _logged(Failure.failure(message: e.message), e, stackTrace),
    );
  }
}

Failure _dioFailure(DioException e) {
  final error = e.error;

  if (error is UnauthorizedException) {
    return UnauthorizedFailure(message: error.message);
  } else if (error is BadRequestException) {
    return RequestFailure(message: error.message);
  } else if (error is ServerException) {
    return ServerFailure(message: error.message);
  } else if (error is NetworkException) {
    return NetworkFailure(message: error.message);
  } else if (error is ForbiddenException) {
    return ForbiddenFailure(message: error.message);
  } else if (error is NotFoundException) {
    return RequestFailure(message: error.message);
  } else if (error is ConflictException) {
    return ConflictFailure(message: error.message);
  } else if (error is AuthFailure) {
    return AuthFailure(message: error.message);
  } else if (error is CertificateException) {
    return CertificateFailure(message: error.message);
  } else if (error is UnknownException) {
    // ClientInterceptor rejects with this whenever the request failed
    // before any response arrived.
    return Failure.failure(message: error.message);
  } else {
    // Keep whatever Dio knows rather than replacing it with a constant.
    return Failure.failure(
      message: e.message ?? error?.toString() ?? 'Unknown Dio error',
    );
  }
}

Failure _logged(Failure failure, Object exception, StackTrace stackTrace) {
  talker.logCustom(
    FailureLog(
      '${failure.runtimeType}: ${failure.message}',
      exception: exception,
      stackTrace: stackTrace,
    ),
  );
  return failure;
}
