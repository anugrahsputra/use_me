import 'package:dartz/dartz.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/data/data.dart';
import 'package:use_me/features/auth/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.datasource,
    required this.localStorageManager,
  });

  final AuthDatasource datasource;
  final LocalStorageManager localStorageManager;

  @override
  Future<Either<Failure, LoginEntity>> login(LoginRequest req) async {
    final result = await datasource.login(req);
    return result.fold(Left.new, (data) {
      localStorageManager.writeToStorage('token', data.token);
      return Right(data.toEntity());
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    final result = await datasource.logout();
    return result.fold(Left.new, (data) {
      localStorageManager.deleteFromStorage('token');
      return Right(unit);
    });
  }
}
