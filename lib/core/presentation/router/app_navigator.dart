import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/home/home.dart';
import 'package:use_me/injections.dart';

part 'app_pages.dart';
part 'app_routes.dart';
part 'app_transition.dart';

class AppNavigator {
  bool canPop(BuildContext context) => GoRouter.of(context).canPop();

  bool isCurrentPage(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent ?? false;
  }

  void back<T>(BuildContext context, [T? result]) {
    if (canPop(context)) {
      context.pop(result);
    }
  }

  void go(BuildContext context, String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  void push(BuildContext context, String location, {Object? extra}) {
    context.push(location, extra: extra);
  }

  /* === Specific GoTo Methods === */

  void goToSplash(BuildContext context) {
    go(context, AppPages.splash);
  }

  void goToLogin(BuildContext context) {
    go(context, AppPages.login);
  }

  void goToRegister(BuildContext context) {
    push(context, AppPages.register);
  }

  void goToHome(BuildContext context) {
    go(context, AppPages.home);
  }
}
