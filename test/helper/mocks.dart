import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

export 'mocks.mocks.dart';

@GenerateNiceMocks([
  /* core/data */
  // MockSpec<ApiEndpoints>(),
  MockSpec<Client>(),
  MockSpec<ClientInterceptor>(),
  MockSpec<ClientRequestRetrier>(),
  MockSpec<IsolateParser>(),
  MockSpec<Dio>(),
  MockSpec<InternetConnectionChecker>(),
  MockSpec<RequestInterceptorHandler>(),
  MockSpec<ResponseInterceptorHandler>(),
  MockSpec<ErrorInterceptorHandler>(),
  MockSpec<LocalStorageManager>(),
  MockSpec<FlutterSecureStorage>(),

  /* features/data */
  MockSpec<AuthDatasource>(),
  MockSpec<AuthRepository>(),
  MockSpec<LoginUsecase>(),
  // MockSpec<RegisterUsecase>(),
])
void main(List<String> args) {}
