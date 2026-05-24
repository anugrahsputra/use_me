import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('AppPages', () {
    test('constants have correct paths', () {
      expect(AppPages.splash, '/splash');
      expect(AppPages.login, '/login');
      expect(AppPages.register, '/register');
      expect(AppPages.home, '/home');
    });
  });

  group('AppTransition', () {
    test('has all transition values', () {
      expect(AppTransition.values.length, 7);
      expect(AppTransition.values, contains(AppTransition.slideRight));
      expect(AppTransition.values, contains(AppTransition.slideLeft));
      expect(AppTransition.values, contains(AppTransition.slideUp));
      expect(AppTransition.values, contains(AppTransition.slideDown));
      expect(AppTransition.values, contains(AppTransition.fade));
      expect(AppTransition.values, contains(AppTransition.scale));
      expect(AppTransition.values, contains(AppTransition.none));
    });
  });

  group('AppRoutes', () {
    test('router has three routes', () {
      expect(AppRoutes.router.configuration.routes.length, 3);
    });
  });

  group('AppNavigator', () {
    Widget createTestApp(GoRouter router) {
      return MaterialApp.router(
        routerConfig: router,
        title: 'Test',
      );
    }

    testWidgets('go navigates to location', (tester) async {
      final router = GoRouter(
        initialLocation: '/page1',
        routes: [
          GoRoute(
            path: '/page1',
            builder: (_, __) => const Text('Page1'),
          ),
          GoRoute(
            path: '/page2',
            builder: (_, __) => const Text('Page2'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));

      final navigator = AppNavigator();
      navigator.go(tester.element(find.text('Page1')), '/page2');
      await tester.pumpAndSettle();

      expect(find.text('Page2'), findsOneWidget);
    });

    testWidgets('push navigates to location', (tester) async {
      final router = GoRouter(
        initialLocation: '/page1',
        routes: [
          GoRoute(
            path: '/page1',
            builder: (_, __) => const Text('Page1'),
          ),
          GoRoute(
            path: '/page2',
            builder: (_, __) => const Text('Page2'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));

      final navigator = AppNavigator();
      navigator.push(tester.element(find.text('Page1')), '/page2');
      await tester.pumpAndSettle();

      expect(find.text('Page2'), findsOneWidget);
    });

    testWidgets('back pops if possible', (tester) async {
      final router = GoRouter(
        initialLocation: '/page1',
        routes: [
          GoRoute(
            path: '/page1',
            builder: (_, __) => const Text('Page1'),
          ),
          GoRoute(
            path: '/page2',
            builder: (_, __) => const Text('Page2'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));
      await tester.pumpAndSettle();

      final navigator = AppNavigator();
      navigator.push(tester.element(find.text('Page1')), '/page2');
      await tester.pumpAndSettle();
      expect(find.text('Page2'), findsOneWidget);

      navigator.back(tester.element(find.text('Page2')));
      await tester.pumpAndSettle();

      expect(find.text('Page1'), findsOneWidget);
    });

    testWidgets('goToSplash navigates to splash', (tester) async {
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (_, __) => const Text('SplashPage'),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const Text('HomePage'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));

      final navigator = AppNavigator();
      navigator.goToSplash(tester.element(find.text('HomePage')));
      await tester.pumpAndSettle();

      expect(find.text('SplashPage'), findsOneWidget);
    });

    testWidgets('goToLogin navigates to login', (tester) async {
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/login',
            builder: (_, __) => const Text('LoginPage'),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const Text('HomePage'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));

      final navigator = AppNavigator();
      navigator.goToLogin(tester.element(find.text('HomePage')));
      await tester.pumpAndSettle();

      expect(find.text('LoginPage'), findsOneWidget);
    });

    testWidgets('goToRegister navigates to register', (tester) async {
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/register',
            builder: (_, __) => const Text('RegisterPage'),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const Text('HomePage'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));

      final navigator = AppNavigator();
      navigator.goToRegister(tester.element(find.text('HomePage')));
      await tester.pumpAndSettle();

      expect(find.text('RegisterPage'), findsOneWidget);
    });

    testWidgets('goToHome navigates to home', (tester) async {
      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (_, __) => const Text('SplashPage'),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const Text('HomePage'),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router));

      final navigator = AppNavigator();
      navigator.goToHome(tester.element(find.text('SplashPage')));
      await tester.pumpAndSettle();

      expect(find.text('HomePage'), findsOneWidget);
    });
  });
}
