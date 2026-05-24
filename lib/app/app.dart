export 'app_cubit.dart';
export 'app_initialize.dart';
export 'app_splash.dart';

import 'package:flutter/material.dart';
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
            routerConfig: AppRoutes.router,
            scaffoldMessengerKey: scaffoldMessengerKey,
            title: 'Flutter Demo',
            // theme: AppTheme.light,
            // darkTheme: AppTheme.dark,

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
