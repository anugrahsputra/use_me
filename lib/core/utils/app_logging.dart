import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:use_me/flavors.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  logger: TalkerLogger(output: Platform.isAndroid ? null : debugPrint),
);

abstract class AppLogging {
  static bool _initialized = false;

  static void initialize({TalkerSettings? settings}) {
    if (_initialized) return;
    _initialized = true;

    talker.configure(settings: settings ?? settingsFor(F.appFlavor));

    // Framework errors: a failed build, a layout assert, a bad gesture.
    FlutterError.onError = (details) =>
        talker.handle(details.exception, details.stack, 'FlutterError');

    // Everything that escapes to the engine: async gaps, platform channels.
    // Returning true says we reported it, so the app keeps running.
    PlatformDispatcher.instance.onError = (error, stack) {
      talker.handle(error, stack, 'PlatformDispatcher');
      return true;
    };
  }

  static TalkerSettings settingsFor(Flavor flavor) {
    switch (flavor) {
      case Flavor.espresso:
        return TalkerSettings(enabled: false);
      case Flavor.macchiato:
      case Flavor.latte:
        return TalkerSettings(enabled: true);
    }
  }
}
