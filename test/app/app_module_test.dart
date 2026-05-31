import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

import '../helper/mocks.dart';

void main() {
  late GetIt sl;

  setUp(() async {
    sl = GetIt.asNewInstance();

    // Register deps that AppCubit requires
    sl.registerLazySingleton<LocalStorageManager>(() => MockLocalStorageManager());
    sl.registerLazySingleton<LogoutUsecase>(
      () => LogoutUsecase(repository: MockAuthRepository()),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  group('AppModule.register', () {
    test('registers AppCubit', () async {
      await AppModule.register(sl);

      expect(sl.isRegistered<AppCubit>(), isTrue);
    });

    test('AppCubit resolves as a new factory instance each time', () async {
      await AppModule.register(sl);

      final a = sl<AppCubit>();
      // Flush pending microtasks so _checkToken completes before we close.
      await Future<void>.microtask(() {});
      await a.close();

      final b = sl<AppCubit>();
      await Future<void>.microtask(() {});
      await b.close();

      expect(a, isA<AppCubit>());
      expect(identical(a, b), isFalse);
    });
  });
}
