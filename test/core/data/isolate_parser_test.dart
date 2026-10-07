import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('IsolateParser', () {
    test('parses single object in isolate', () async {
      final json = {'name': 'test', 'value': 42};
      final parser = IsolateParser<Map<String, dynamic>>(json, (j) => j);

      final result = await parser.parseInBackground();
      expect(result, json);
    });

    test('parses single object with transformation', () async {
      final json = {'id': 1, 'title': 'hello'};
      final parser = IsolateParser<String>(json, (j) => j['title'] as String);

      final result = await parser.parseInBackground();
      expect(result, 'hello');
    });

    test('surfaces a throwing converter instead of hanging', () async {
      final parser = IsolateParser<String>({
        'title': 42,
      }, (j) => j['title'] as String);

      await expectLater(
        parser.parseInBackground(),
        throwsA(isA<UnknownException>()),
      );
    });
  });
}
