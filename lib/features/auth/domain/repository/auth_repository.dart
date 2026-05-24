import 'package:dartz/dartz.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/data/dto/login_dto.dart';
import 'package:use_me/features/auth/domain/domain.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> login(LoginRequest req);
  Future<Either<Failure, Unit>> logout();
}
