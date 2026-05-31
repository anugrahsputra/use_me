import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/home/home.dart';

part 'app_pages.dart';
part 'app_routes.dart';
part 'app_transition.dart';

class AppNavigator {
  /// Check if can pop
  bool canPop(BuildContext context) => GoRouter.of(context).canPop();

  /// Check if current page
  bool isCurrentPage(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent ?? false;
  }

  /// Go back
  void back<T>(BuildContext context, [T? result]) {
    if (canPop(context)) {
      context.pop(result);
    }
  }

  /// Navigate to location (clears stack if it's a new branch, but here we use it for replacement)
  void go(BuildContext context, String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  /// Push to stack
  void push(BuildContext context, String location, {Object? extra}) {
    context.push(location, extra: extra);
  }

  /* === Specific GoTo Methods === */

  /// Go to Splash
  void goToSplash(BuildContext context) {
    go(context, AppPages.splash);
  }

  /// Go to Login
  void goToLogin(BuildContext context) {
    go(context, AppPages.login);
  }

  /// Go to Register
  void goToRegister(BuildContext context) {
    push(context, AppPages.register);
  }

  /// Go to Main
  void goToHome(BuildContext context) {
    go(context, AppPages.home);
  }
}
