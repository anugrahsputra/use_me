import 'package:formz/formz.dart';

enum PinValidationError { invalid, tooShort, tooLong }

class Pin extends FormzInput<String, PinValidationError> {
  const Pin.pure() : super.pure('');
  const Pin.dirty([super.value = '']) : super.dirty();

  static const int _minLength = 4;
  static const int _maxLength = 6;

  // Only digits allowed
  static final _regex = RegExp(r'^\d+$');

  @override
  PinValidationError? validator(String value) {
    if (value.length < _minLength) return PinValidationError.tooShort;
    if (value.length > _maxLength) return PinValidationError.tooLong;
    if (!_regex.hasMatch(value)) return PinValidationError.invalid;
    return null;
  }
}
