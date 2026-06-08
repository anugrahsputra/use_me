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
  static String appName = const String.fromEnvironment('APP_NAME', defaultValue: 'env not loaded');
  static String apiKey = const String.fromEnvironment('API_KEY', defaultValue: '');
  static String apiBaseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: '');
}
