import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

import '../helper/mocks.dart';

void main() {
  late MockLocalStorageManager storage;
  late MockAuthRepository repository;
  late AppCubit cubit;

  Future<AppCubit> buildCubit({String? token}) async {
    when(
      storage.readFromStorage('access_token'),
    ).thenAnswer((_) async => token);
    final built = AppCubit(
      localStorageManager: storage,
      logoutUsecase: LogoutUsecase(repository: repository),
    );
    await Future<void>.delayed(Duration.zero);
    return built;
  }

  setUp(() {
    storage = MockLocalStorageManager();
    repository = MockAuthRepository();
    when(storage.deleteFromStorage(any)).thenAnswer((_) async {});
  });

  tearDown(() => cubit.close());

  group('AppCubit._checkToken', () {
    test('emits AppAuthenticated when a token is stored', () async {
      cubit = await buildCubit(token: 'abc');
      expect(cubit.state, isA<AppAuthenticated>());
    });

    test('emits AppUnauthenticated when no token is stored', () async {
      cubit = await buildCubit();
      expect(cubit.state, isA<AppUnauthenticated>());
    });

    test('emits AppUnauthenticated when the token is empty', () async {
      cubit = await buildCubit(token: '');
      expect(cubit.state, isA<AppUnauthenticated>());
    });
  });

  test('loggedIn emits AppAuthenticated', () async {
    cubit = await buildCubit();
    cubit.loggedIn();
    expect(cubit.state, isA<AppAuthenticated>());
  });

  group('AppCubit.logout', () {
    test('clears both tokens and signs out on success', () async {
      when(repository.logout()).thenAnswer((_) async => const Right(unit));
      cubit = await buildCubit(token: 'abc');

      await cubit.logout();

      expect(cubit.state, isA<AppUnauthenticated>());
      verify(storage.deleteFromStorage('access_token')).called(1);
      verify(storage.deleteFromStorage('refresh_token')).called(1);
    });

    test('keeps the tokens and emits AppError on failure', () async {
      when(repository.logout()).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'boom')),
      );
      cubit = await buildCubit(token: 'abc');

      await cubit.logout();

      expect(cubit.state, const AppError('boom'));
      verifyNever(storage.deleteFromStorage(any));
    });
  });
}
