import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

class TestMap {
  @override
  String toString() => '{"a": 1}';
}

void main() {
  group('Parser.get', () {
    test('returns value when cast succeeds', () {
      expect(Parser.get<int>(42), 42);
      expect(Parser.get<String>('hello'), 'hello');
    });

    test('returns null when cast fails', () {
      expect(Parser.get<int>('not int'), isNull);
      expect(Parser.get<String>(42), isNull);
      expect(Parser.get<Map<String, dynamic>>('string'), isNull);
    });

    test('returns null for null input', () {
      expect(Parser.get<int>(null), isNull);
    });
  });

  group('Parser.getMap', () {
    test('parses JSON string to map', () {
      final result = Parser.getMap('{"key": "value"}');
      expect(result, {'key': 'value'});
    });

    test('parses object with valid JSON toString', () {
      final result = Parser.getMap(TestMap());
      expect(result, {'a': 1});
    });

    test('returns null for invalid JSON', () {
      expect(Parser.getMap('not json'), isNull);
    });

    test('returns null for JSON array', () {
      expect(Parser.getMap('[1, 2, 3]'), isNull);
    });
  });
}
