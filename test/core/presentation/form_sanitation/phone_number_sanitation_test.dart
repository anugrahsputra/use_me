import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('PhoneNumber', () {
    test('pure creates empty input', () {
      final phone = PhoneNumber.pure();
      expect(phone.value, '');
    });

    test('valid Indonesian phone numbers pass', () {
      expect(PhoneNumber.dirty('08123456789').validator('08123456789'), isNull);
      expect(PhoneNumber.dirty('+628123456789').validator('+628123456789'), isNull);
      expect(PhoneNumber.dirty('628123456789').validator('628123456789'), isNull);
      expect(PhoneNumber.dirty('0812345678').validator('0812345678'), isNull);
      expect(PhoneNumber.dirty('081234567890').validator('081234567890'), isNull);
    });

    test('empty value returns empty error', () {
      expect(
        PhoneNumber.dirty('').validator(''),
        PhoneNumberValidationError.empty,
      );
      expect(
        PhoneNumber.dirty('   ').validator('   '),
        PhoneNumberValidationError.empty,
      );
    });

    test('invalid phone number returns invalid error', () {
      expect(
        PhoneNumber.dirty('12345').validator('12345'),
        PhoneNumberValidationError.invalid,
      );
      expect(
        PhoneNumber.dirty('08123').validator('08123'),
        PhoneNumberValidationError.invalid,
      );
      expect(
        PhoneNumber.dirty('+621234').validator('+621234'),
        PhoneNumberValidationError.invalid,
      );
    });
  });
}
