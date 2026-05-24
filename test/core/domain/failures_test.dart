import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('Failure variants', () {
    test('Failure.failure', () {
      final f = Failure.failure(message: 'error');
      expect(f.message, 'error');
      expect(f, isA<Failure>());
    });

    test('Failure.serverFailure', () {
      final f = Failure.serverFailure(message: 'server error');
      expect(f.message, 'server error');
      expect(f, isA<Failure>());
    });

    test('Failure.unauthorizeFailure', () {
      final f = Failure.unauthorizeFailure(message: 'auth error');
      expect(f.message, 'auth error');
      expect(f, isA<Failure>());
    });

    test('Failure.cacheFailure', () {
      final f = Failure.cacheFailure(message: 'cache error');
      expect(f.message, 'cache error');
      expect(f, isA<Failure>());
    });

    test('Failure.networkFailure', () {
      final f = Failure.networkFailure(message: 'network error');
      expect(f.message, 'network error');
      expect(f, isA<Failure>());
    });

    test('Failure.forbidden', () {
      final f = Failure.forbidden(message: 'forbidden');
      expect(f.message, 'forbidden');
      expect(f, isA<Failure>());
    });

    test('Failure.requestFailure', () {
      final f = Failure.requestFailure(message: 'bad request');
      expect(f.message, 'bad request');
      expect(f, isA<Failure>());
    });

    test('Failure.databaseFailre', () {
      final f = Failure.databaseFailre(message: 'db error');
      expect(f.message, 'db error');
      expect(f, isA<Failure>());
    });

    test('Failure.authFailure', () {
      final f = Failure.authFailure(message: 'auth error');
      expect(f.message, 'auth error');
      expect(f, isA<Failure>());
    });

    test('Failure.certificateFailure', () {
      final f = Failure.certificateFailure(message: 'cert error');
      expect(f.message, 'cert error');
      expect(f, isA<Failure>());
    });

    test('copyWith changes message', () {
      final f = Failure.failure(message: 'original');
      final copy = f.copyWith(message: 'updated');
      expect(copy.message, 'updated');
    });
  });
}
