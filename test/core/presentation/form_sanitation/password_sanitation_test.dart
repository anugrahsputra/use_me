import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('Password', () {
    test('pure creates empty input', () {
      final pw = Password.pure();
      expect(pw.value, '');
    });

    test('non-empty password passes', () {
      expect(Password.dirty('secret123').validator('secret123'), isNull);
    });

    test('empty password returns error', () {
      expect(
        Password.dirty('').validator(''),
        PasswordValidationError.empty,
      );
    });
  });
}
