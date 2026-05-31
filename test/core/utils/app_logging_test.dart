import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('AppLogging', () {
    setUp(() {
      AppLogging.isInitialize = false;
    });

    test('initialize sets isInitialize to true', () async {
      expect(AppLogging.isInitialize, isFalse);
      await AppLogging.initialize();
      expect(AppLogging.isInitialize, isTrue);
    });

    test('initialize is idempotent', () async {
      await AppLogging.initialize();
      expect(AppLogging.isInitialize, isTrue);
    });

    test('second initialize call skips re-configuration', () async {
      await AppLogging.initialize();
      AppLogging.isInitialize = true;
      await AppLogging.initialize();
      expect(AppLogging.isInitialize, isTrue);
    });

    test('initialize with showLog: true enables talker', () async {
      await AppLogging.initialize(showLog: true);
      expect(AppLogging.isInitialize, isTrue);
    });

    test('initialize with showLog: false disables talker', () async {
      await AppLogging.initialize(showLog: false);
      expect(AppLogging.isInitialize, isTrue);
    });
  });
}
