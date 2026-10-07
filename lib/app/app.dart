export 'app_cubit.dart';
export 'app_initialize.dart';
export 'app_splash.dart';
export 'talker_overlay.dart';

import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:use_me/app/talker_overlay.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: (context, child) {
        return _flavorBanner(
          child: MaterialApp.router(
            routerConfig: router,
            scaffoldMessengerKey: scaffoldMessengerKey,
            title: F.title,
            // theme: AppTheme.light,
            // darkTheme: AppTheme.dark,

            // Inside the router app so the alert overlay and the log screen
            // both have a Navigator and an Overlay above them.
            builder: (context, child) => TalkerWrapper(
              talker: talker,
              options: const TalkerWrapperOptions(
                enableErrorAlerts: true,
                enableExceptionAlerts: true,
              ),
              child: TalkerOverlay(child: child ?? const SizedBox.shrink()),
            ),

            // localizationsDelegates: const [
            //   AppLocalizations.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
      },
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          textDirection: TextDirection.ltr,
          child: child,
        )
      : Container(child: child);
}
