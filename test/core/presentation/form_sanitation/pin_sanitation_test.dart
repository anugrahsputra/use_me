import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/presentation/form_sanitation/pin_sanitation.dart';

void main() {
  group('Pin', () {
    test('pure creates empty input', () {
      final pin = const Pin.pure();
      expect(pin.value, '');
    });

    test('valid PIN (4-6 digits) passes', () {
      expect(const Pin.dirty('1234').validator('1234'), isNull);
      expect(const Pin.dirty('12345').validator('12345'), isNull);
      expect(const Pin.dirty('123456').validator('123456'), isNull);
    });

    test('too short returns tooShort error', () {
      expect(
        const Pin.dirty('12').validator('12'),
        PinValidationError.tooShort,
      );
      expect(
        const Pin.dirty('123').validator('123'),
        PinValidationError.tooShort,
      );
    });

    test('too long returns tooLong error', () {
      expect(
        const Pin.dirty('1234567').validator('1234567'),
        PinValidationError.tooLong,
      );
    });

    test('non-digit characters returns invalid error', () {
      expect(
        const Pin.dirty('abcd').validator('abcd'),
        PinValidationError.invalid,
      );
      expect(
        const Pin.dirty('12a4').validator('12a4'),
        PinValidationError.invalid,
      );
    });
  });
}
