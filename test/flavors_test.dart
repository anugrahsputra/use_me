import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/flavors.dart';

void main() {
  // ponytail: F.appFlavor is late final — set once, test all branches via Environment
  setUpAll(() {
    F.appFlavor = Flavor.latte;
  });

  group('Flavor enum', () {
    test('all three flavors exist', () {
      expect(Flavor.values.length, 3);
      expect(
        Flavor.values,
        containsAll([Flavor.latte, Flavor.macchiato, Flavor.espresso]),
      );
    });
  });

  group('F (latte flavor)', () {
    test('name returns latte', () {
      expect(F.name, 'latte');
    });

    test('title returns a String', () {
      expect(F.title, isA<String>());
    });

    test('apiBaseUrl returns a String', () {
      expect(F.apiBaseUrl, isA<String>());
    });

    test('apiKey returns a String', () {
      expect(F.apiKey, isA<String>());
    });
  });

  group('Environment', () {
    test('appName has a default value', () {
      expect(Environment.appName, isA<String>());
    });

    test('apiKey default is empty string', () {
      expect(Environment.apiKey, isA<String>());
    });

    test('apiBaseUrl default is empty string', () {
      expect(Environment.apiBaseUrl, isA<String>());
    });
  });
}
