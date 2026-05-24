import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('prettyPrintJson', () {
    test('formats simple JSON', () {
      final result = prettyPrintJson('{"key": "value"}');
      expect(result, '{\n  "key": "value"\n}');
    });

    test('formats JSON with number', () {
      final result = prettyPrintJson('{"num": 42}');
      expect(result, '{\n  "num": 42\n}');
    });

    test('formats JSON with nested map', () {
      final result = prettyPrintJson('{"outer": {"inner": "val"}}');
      expect(result, '{\n  "outer": {\n    "inner": "val"\n  }\n}');
    });

    test('formats JSON with list', () {
      final result = prettyPrintJson('{"items": [1, 2, 3]}');
      expect(result, '{\n  "items": [1,2,3]\n}');
    });

    test('formats JSON with boolean', () {
      final result = prettyPrintJson('{"flag": true}');
      expect(result, '{\n  "flag": true\n}');
    });

    test('formats JSON with multiple keys', () {
      final result = prettyPrintJson('{"a": 1, "b": 2}');
      expect(result, '{\n  "a": 1,\n  "b": 2\n}');
    });
  });
}
