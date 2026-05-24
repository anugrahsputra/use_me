import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('Name', () {
    test('pure creates empty input', () {
      final name = Name.pure();
      expect(name.value, '');
    });

    test('valid name passes', () {
      expect(Name.dirty('John').validator('John'), isNull);
      expect(Name.dirty('A B C').validator('A B C'), isNull);
    });

    test('empty value returns empty error', () {
      expect(
        Name.dirty('').validator(''),
        NameValidationError.empty,
      );
      expect(
        Name.dirty('   ').validator('   '),
        NameValidationError.empty,
      );
    });

    test('too short returns tooShort error', () {
      expect(
        Name.dirty('ab').validator('ab'),
        NameValidationError.tooShort,
      );
    });
  });
}
