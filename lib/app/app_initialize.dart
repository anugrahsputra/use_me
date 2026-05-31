import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/injections.dart';

Future<void> appInitialize() async {
  unawaited(AppLogging.initialize(showLog: true));
  Bloc.observer = TalkerBlocObserver(
    settings: TalkerBlocLoggerSettings(
      enabled: true,
      printChanges: true,
      printClosings: false,
      printCreations: true,
      printEvents: false,
      printTransitions: true,
    ),
  );
  await configureDependencies();

  // Listen for isolate errors too
  // Isolate.current.addErrorListener(
  //   RawReceivePort((List<dynamic> pair) async {
  //     final errorAndStacktrace = pair;
  //     final error = errorAndStacktrace.first;
  //     final stack = errorAndStacktrace.last;
  //     await Sentry.captureException(
  //       error,
  //       stackTrace: stack is StackTrace ? stack : null,
  //     );
  //   }).sendPort,
  // );

  // await SentryFlutter.init(
  //   (options) {
  //     options
  //       ..dsn =
  //           'https://ab1e53778899db2e6b6bd7ae324577f1@o4508516549984256.ingest.us.sentry.io/4509677872152576'
  //       ..sendDefaultPii = true
  //       ..tracesSampleRate = 1.0
  //       ..captureFailedRequests = true
  //       ..addIntegration(LoggingIntegration());
  //   },
  //   // Keep runApp inside the same zone
  //   appRunner: () => runApp(SentryWidget(child: const App())),
  // );
  runApp(const App());
}

mixin class AppModule {
  static Future<void> register(GetIt sl) async {
    sl.registerFactory<AppCubit>(
      () => AppCubit(
        localStorageManager: sl<LocalStorageManager>(),
        logoutUsecase: sl<LogoutUsecase>(),
      ),
    );
  }
}
