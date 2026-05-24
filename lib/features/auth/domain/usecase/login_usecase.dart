import 'package:dartz/dartz.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/data/dto/login_dto.dart';
import 'package:use_me/features/auth/domain/domain.dart';

class LoginUsecase {
  const LoginUsecase({required this.repository});

  final AuthRepository repository;

  Future<Either<Failure, LoginEntity>> call(LoginRequest req) async =>
      await repository.login(req);
}
