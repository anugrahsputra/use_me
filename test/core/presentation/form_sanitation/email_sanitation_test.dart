import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('Email', () {
    test('pure creates empty input', () {
      final email = Email.pure();
      expect(email.value, '');
    });

    test('valid email passes', () {
      expect(Email.dirty('test@example.com').validator('test@example.com'), isNull);
      expect(Email.dirty('user.name@domain.co').validator('user.name@domain.co'), isNull);
      expect(Email.dirty('a@b.cd').validator('a@b.cd'), isNull);
    });

    test('invalid email returns error', () {
      expect(
        Email.dirty('not-email').validator('not-email'),
        EmailValidationError.invalid,
      );
      expect(
        Email.dirty('').validator(''),
        EmailValidationError.invalid,
      );
      expect(
        Email.dirty('@domain.com').validator('@domain.com'),
        EmailValidationError.invalid,
      );
    });
  });
}
