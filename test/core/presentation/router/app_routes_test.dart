import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/home/home.dart';
import 'package:use_me/injections.dart';

import '../../../helper/mocks.dart';

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockAppNavigator extends Mock implements AppNavigator {}

Widget createTestApp() {
  return MaterialApp.router(routerConfig: router);
}

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  late MockLocalStorageManager mockStorage;
  late MockLogoutUsecase mockLogout;
  late MockLoginUsecase mockLogin;

  setUp(() {
    mockStorage = MockLocalStorageManager();
    mockLogout = MockLogoutUsecase();
    mockLogin = MockLoginUsecase();

    when(
      mockStorage.readFromStorage('refresh_token'),
    ).thenAnswer((_) async => null);
    when(
      mockStorage.readFromStorage('access_token'),
    ).thenAnswer((_) async => 'fake_token');

    di
      ..registerLazySingleton<AppNavigator>(() => MockAppNavigator())
      ..registerFactory<LocalStorageManager>(() => mockStorage)
      ..registerFactory<LogoutUsecase>(() => mockLogout)
      ..registerLazySingleton<AppCubit>(
        () => AppCubit(
          localStorageManager: mockStorage,
          logoutUsecase: mockLogout,
        ),
      )
      ..registerFactory<LoginUsecase>(() => mockLogin)
      ..registerFactory<LoginBloc>(() => LoginBloc(loginUsecase: mockLogin))
      ..registerFactory<HomeCubit>(() => HomeCubit());
  });

  tearDown(() {
    di.reset();
  });

  testWidgets('an authenticated user lands on home and cannot open login', (
    tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await settle(tester);

    expect(find.byType(HomePage), findsOneWidget);

    router.go(AppPages.login);
    await settle(tester);

    expect(
      find.byType(HomePage),
      findsOneWidget,
      reason: 'Authenticated user should be redirected from /login to /home',
    );
  });

  testWidgets('a signed-out user is pinned to login', (tester) async {
    when(
      mockStorage.readFromStorage('access_token'),
    ).thenAnswer((_) async => null);

    await tester.pumpWidget(createTestApp());
    await settle(tester);

    // The listenable may be bound to an earlier test's cubit, so ask the
    // router to re-evaluate rather than waiting for a notification.
    router.go(AppPages.home);
    await settle(tester);

    expect(
      find.byType(LoginPage),
      findsOneWidget,
      reason: 'A signed-out user must not reach /home',
    );
  });

  // _publicRoutes is only an allowlist for the redirect guard. A path can sit
  // in it with no GoRoute behind it, and GoRouter then fails to resolve it.
  test('every route reachable without auth is declared', () {
    final declared = router.configuration.routes
        .whereType<GoRoute>()
        .map((route) => route.path)
        .toSet();

    expect(declared, containsAll([AppPages.splash, AppPages.login]));
  });

  testWidgets('isCurrentPage returns true for current route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/test',
        routes: {'/test': (context) => const Text('TestPage')},
      ),
    );
    await tester.pump();

    final navigator = AppNavigator();
    final context = tester.element(find.text('TestPage'));
    expect(navigator.isCurrentPage(context), isTrue);
  });

  testWidgets('isCurrentPage returns false for non-current route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/a',
        routes: {
          '/a': (context) => const Text('PageA'),
          '/b': (context) => const Text('PageB'),
        },
      ),
    );
    await tester.pump();

    final navigator = AppNavigator();
    final ctx = tester.element(find.text('PageA'));
    expect(navigator.isCurrentPage(ctx), isTrue);
  });
}
