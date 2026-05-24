import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { latte, macchiato, espresso }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.latte:
        return Environment.appName;
      case Flavor.macchiato:
        return Environment.appName;
      case Flavor.espresso:
        return Environment.appName;
    }
  }

  static String get apiKey {
    switch (appFlavor) {
      case Flavor.latte:
        return Environment.apiKey;
      case Flavor.macchiato:
        return Environment.apiKey;
      case Flavor.espresso:
        return Environment.apiKey;
    }
  }
}

sealed class Environment {
  static String get appName => dotenv.env['APP_NAME'] ?? 'env not loade';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
