import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  // Captured at registration time, before setUpAll swaps them out.
  final beforeFlutter = FlutterError.onError;
  final beforePlatform = PlatformDispatcher.instance.onError;

  setUpAll(() {
    AppLogging.initialize(settings: TalkerSettings(useConsoleLogs: false));
  });

  group('AppLogging.initialize', () {
    setUp(talker.cleanHistory);

    test('replaces both uncaught-error hooks', () {
      expect(FlutterError.onError, isNot(same(beforeFlutter)));
      expect(PlatformDispatcher.instance.onError, isNot(same(beforePlatform)));
    });

    test('routes framework errors into talker', () {
      FlutterError.onError!(FlutterErrorDetails(exception: Exception('boom')));

      expect(talker.history, hasLength(1));
      expect(talker.history.single.generateTextMessage(), contains('boom'));
    });

    test('reports platform errors and lets the app keep running', () {
      final handled = PlatformDispatcher.instance.onError!(
        Exception('async boom'),
        StackTrace.current,
      );

      // False would let the engine crash the app after we logged it.
      expect(handled, isTrue);
      expect(talker.history, hasLength(1));
      expect(talker.history.single.generateTextMessage(), contains('async boom'));
    });

    test('a second call keeps the settings the first one installed', () {
      final installed = FlutterError.onError;

      AppLogging.initialize(settings: TalkerSettings(enabled: false));

      expect(FlutterError.onError, same(installed));
      expect(talker.settings.enabled, isTrue);
    });
  });

  group('AppLogging.settingsFor', () {
    test('mutes the production flavor', () {
      expect(AppLogging.settingsFor(Flavor.espresso).enabled, isFalse);
    });

    test('keeps the dev and staging flavors talking', () {
      expect(AppLogging.settingsFor(Flavor.latte).enabled, isTrue);
      expect(AppLogging.settingsFor(Flavor.macchiato).enabled, isTrue);
    });

    test('answers for every flavor', () {
      for (final flavor in Flavor.values) {
        expect(AppLogging.settingsFor(flavor), isA<TalkerSettings>());
      }
    });
  });
}
