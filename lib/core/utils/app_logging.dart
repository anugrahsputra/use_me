import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

abstract class AppLogging {
  static bool isInitialize = false;

  static Future<void> initialize({bool showLog = false}) async {
    if (!isInitialize) {
      talker.configure(
        settings: TalkerSettings(enabled: showLog),
      );
      isInitialize = true;
    }
  }
}
