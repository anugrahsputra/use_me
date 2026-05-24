import 'package:dartz/dartz.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/data/dto/login_dto.dart';

abstract class AuthDatasource {
  Future<Either<Failure, LoginResponse>> login(LoginRequest req);
  Future<Either<Failure, Unit>> logout();
}

class AuthDatasourceImpl implements AuthDatasource {
  AuthDatasourceImpl({required this.client});

  final Client client;

  final String baseUrl = 'https://reqres.in/api';

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest req) async =>
      await client.postParsedSafe<LoginResponse>(
        '$baseUrl/login',
        data: req.toJson(),
        converter: LoginResponse.fromJson,
      );

  @override
  Future<Either<Failure, Unit>> logout() async =>
      await client.postParsedSafe('$baseUrl/logout', converter: (data) => unit);
}
