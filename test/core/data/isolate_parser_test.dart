import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('IsolateParser', () {
    test('parses single object in isolate', () async {
      final json = {'name': 'test', 'value': 42};
      final parser = IsolateParser<Map<String, dynamic>>(
        json,
        (j) => j,
      );

      final result = await parser.parseInBackground();
      expect(result, json);
    });

    test('parses single object with transformation', () async {
      final json = {'id': 1, 'title': 'hello'};
      final parser = IsolateParser<String>(
        json,
        (j) => j['title'] as String,
      );

      final result = await parser.parseInBackground();
      expect(result, 'hello');
    });
  });

  group('IsolateListParser', () {
    test('parses list of objects in isolate', () async {
      final jsonList = [
        {'id': 1},
        {'id': 2},
      ];
      final parser = IsolateListParser<Map<String, dynamic>>(
        jsonList,
        (j) => j,
      );

      final result = await parser.parseInBackground();
      expect(result, jsonList);
    });

    test('parses list with transformation', () async {
      final jsonList = [
        {'name': 'a'},
        {'name': 'b'},
      ];
      final parser = IsolateListParser<String>(
        jsonList,
        (j) => j['name'] as String,
      );

      final result = await parser.parseInBackground();
      expect(result, ['a', 'b']);
    });
  });
}
