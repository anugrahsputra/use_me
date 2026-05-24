part of 'app_navigator.dart';

abstract class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: AppPages.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppPages.splash,
        name: AppPages.splash,
        builder: (context, state) => const AppSplash(),
      ),

      GoRoute(
        path: AppPages.login,
        name: AppPages.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppPages.home,
        name: AppPages.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
