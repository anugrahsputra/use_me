part of 'app_navigator.dart';

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._cubit) {
    _subscription = _cubit.stream.listen((_) => notifyListeners());
  }

  final AppCubit _cubit;
  late final StreamSubscription<AppState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

const Set<String> _publicRoutes = {AppPages.splash, AppPages.login};

final GoRouter router = GoRouter(
  initialLocation: AppPages.splash,
  debugLogDiagnostics: true,
  observers: [TalkerRouteObserver(talker)],
  redirect: (context, state) {
    final appState = di<AppCubit>().state;
    final location = state.matchedLocation;

    if (appState is AppInitial || appState is AppLoading) {
      return location == AppPages.splash ? null : AppPages.splash;
    }

    final isAuthenticated = appState is AppAuthenticated;
    final isPublicRoute = _publicRoutes.contains(location);

    if (!isAuthenticated) {
      return isPublicRoute && location != AppPages.splash
          ? null
          : AppPages.login;
    }
    return isPublicRoute ? AppPages.home : null;
  },
  refreshListenable: _AuthRefreshNotifier(di<AppCubit>()),
  routes: [
    GoRoute(
      path: AppPages.splash,
      name: AppPages.splash,
      pageBuilder: (context, state) =>
          MaterialPage<void>(child: const AppSplash()),
    ),
    GoRoute(
      path: AppPages.login,
      name: AppPages.login,
      pageBuilder: (context, state) =>
          MaterialPage<void>(child: const LoginPage()),
    ),
    GoRoute(
      path: AppPages.home,
      name: AppPages.home,
      pageBuilder: (context, state) =>
          MaterialPage<void>(child: const HomePage()),
    ),
  ],
);
