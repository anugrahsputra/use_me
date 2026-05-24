import 'package:dartz/dartz.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

class LogoutUsecase {
  const LogoutUsecase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, Unit>> call() async => await repository.logout();
}
