import 'package:dartz/dartz.dart';
import 'package:use_me/core/core.dart';

abstract class Usecase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

abstract class UsecaseNoParams<T> {
  Future<Either<Failure, T>> call();
}
