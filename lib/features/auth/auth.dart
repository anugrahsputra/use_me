import 'package:get_it/get_it.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';

mixin class AuthModule {
  static Future<void> register(GetIt sl) async {
    sl.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(client: sl<Client>()),
    );
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        datasource: sl<AuthDatasource>(),
        localStorageManager: sl<LocalStorageManager>(),
      ),
    );

    sl.registerLazySingleton<LoginUsecase>(
      () => LoginUsecase(repository: sl<AuthRepository>()),
    );

    sl.registerLazySingleton<LogoutUsecase>(
      () => LogoutUsecase(repository: sl<AuthRepository>()),
    );
    sl.registerFactory<LoginBloc>(
      () => LoginBloc(loginUsecase: sl<LoginUsecase>()),
    );
  }
}
