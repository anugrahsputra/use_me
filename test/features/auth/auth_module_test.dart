import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

import '../../helper/mocks.dart';

void main() {
  late GetIt sl;

  setUp(() {
    sl = GetIt.asNewInstance();

    // AuthModule depends on Client and LocalStorageManager from CoreModule.
    // Register mocks so AuthModule can resolve its deps without CoreModule.
    sl.registerFactory<Client>(() => MockClient());
    sl.registerLazySingleton<LocalStorageManager>(() => MockLocalStorageManager());
  });

  tearDown(() async {
    await sl.reset();
  });

  group('AuthModule.register', () {
    test('registers all expected types', () async {
      await AuthModule.register(sl);

      expect(sl.isRegistered<AuthDatasource>(), isTrue);
      expect(sl.isRegistered<AuthRepository>(), isTrue);
      expect(sl.isRegistered<LoginUsecase>(), isTrue);
      expect(sl.isRegistered<LogoutUsecase>(), isTrue);
      expect(sl.isRegistered<LoginBloc>(), isTrue);
    });

    test('AuthDatasource resolves as a lazy singleton', () async {
      await AuthModule.register(sl);

      final a = sl<AuthDatasource>();
      final b = sl<AuthDatasource>();

      expect(a, isA<AuthDatasourceImpl>());
      expect(identical(a, b), isTrue);
    });

    test('AuthRepository resolves as a lazy singleton', () async {
      await AuthModule.register(sl);

      final a = sl<AuthRepository>();
      final b = sl<AuthRepository>();

      expect(a, isA<AuthRepositoryImpl>());
      expect(identical(a, b), isTrue);
    });

    test('LoginUsecase resolves as a lazy singleton', () async {
      await AuthModule.register(sl);

      final a = sl<LoginUsecase>();
      final b = sl<LoginUsecase>();

      expect(identical(a, b), isTrue);
    });

    test('LogoutUsecase resolves as a lazy singleton', () async {
      await AuthModule.register(sl);

      final a = sl<LogoutUsecase>();
      final b = sl<LogoutUsecase>();

      expect(identical(a, b), isTrue);
    });

    test('LoginBloc resolves as a new factory instance each time', () async {
      await AuthModule.register(sl);

      final a = sl<LoginBloc>();
      final b = sl<LoginBloc>();

      expect(a, isA<LoginBloc>());
      expect(identical(a, b), isFalse);
    });
  });
}
