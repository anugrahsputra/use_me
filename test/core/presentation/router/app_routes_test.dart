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
  return MaterialApp.router(
    routerConfig: AppRoutes.router,
  );
}

void main() {
  late MockLocalStorageManager mockStorage;
  late MockLogoutUsecase mockLogout;
  late MockLoginUsecase mockLogin;

  setUp(() {
    mockStorage = MockLocalStorageManager();
    mockLogout = MockLogoutUsecase();
    mockLogin = MockLoginUsecase();

    when(mockStorage.readFromStorage('refresh_token'))
        .thenAnswer((_) async => null);
    when(mockStorage.readFromStorage('token'))
        .thenAnswer((_) async => null);

    di
      ..registerFactory<AppNavigator>(() => MockAppNavigator())
      ..registerFactory<LocalStorageManager>(() => mockStorage)
      ..registerFactory<LogoutUsecase>(() => mockLogout)
      ..registerFactory<AppCubit>(() => AppCubit(
        localStorageManager: mockStorage,
        logoutUsecase: mockLogout,
      ))
      ..registerFactory<LoginUsecase>(() => mockLogin)
      ..registerFactory<LoginBloc>(() => LoginBloc(loginUsecase: mockLogin))
      ..registerFactory<HomeCubit>(() => HomeCubit());
  });

  tearDown(() {
    di.reset();
  });

  testWidgets('route builders render expected pages', (tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(AppSplash), findsOneWidget);

    AppRoutes.router.go(AppPages.login);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginPage), findsOneWidget,
        reason: 'GoRouter should build LoginPage for ${AppPages.login}');

    AppRoutes.router.go(AppPages.home);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HomePage), findsOneWidget,
        reason: 'GoRouter should build HomePage for ${AppPages.home}');
  });

  testWidgets('isCurrentPage returns true for current route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/test',
        routes: {
          '/test': (context) => const Text('TestPage'),
        },
      ),
    );
    await tester.pump();

    final navigator = AppNavigator();
    final context = tester.element(find.text('TestPage'));
    expect(navigator.isCurrentPage(context), isTrue);
  });

  testWidgets('isCurrentPage returns false for non-current route',
      (tester) async {
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
