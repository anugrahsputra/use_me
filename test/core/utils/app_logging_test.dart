import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('AppLogging', () {
    setUp(() {
      AppLogging.isInitialize = false;
      Logger.root.level = Level.OFF;
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

    test('second initialize call skips', () async {
      await AppLogging.initialize();
      AppLogging.isInitialize = true;
      await AppLogging.initialize();
      expect(AppLogging.isInitialize, isTrue);
    });

    group('listener', () {
      test('handles WARNING+ records via stderr', () async {
        await AppLogging.initialize(showLog: true);
        Logger.root.warning('warn test');
      });

      test('handles below WARNING records via stdout', () async {
        await AppLogging.initialize(showLog: true);
        Logger.root.info('info test');
      });

      test('handles FINE level color', () async {
        await AppLogging.initialize(showLog: true);
        Logger.root.fine('fine test');
      });

      test('handles records with error and stack trace', () async {
        await AppLogging.initialize(showLog: true);
        Logger.root.severe('severe error', Exception('test'), StackTrace.current);
      });
    });
  });
}

