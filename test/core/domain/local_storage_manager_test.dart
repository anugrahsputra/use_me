import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';

import '../../helper/mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late LocalStorageManagerImpl manager;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    manager = LocalStorageManagerImpl(storage: mockStorage);
  });

  group('LocalStorageManagerImpl', () {
    test('writeToStorage delegates to secure storage', () async {
      await manager.writeToStorage('key', 'value');

      verify(mockStorage.write(
        key: 'key',
        value: 'value',
        aOptions: anyNamed('aOptions'),
        iOptions: anyNamed('iOptions'),
      )).called(1);
    });

    test('readFromStorage delegates to secure storage', () async {
      when(mockStorage.read(
        key: 'key',
        aOptions: anyNamed('aOptions'),
        iOptions: anyNamed('iOptions'),
      )).thenAnswer((_) async => 'stored_value');

      final result = await manager.readFromStorage('key');

      expect(result, 'stored_value');
      verify(mockStorage.read(
        key: 'key',
        aOptions: anyNamed('aOptions'),
        iOptions: anyNamed('iOptions'),
      )).called(1);
    });

    test('readFromStorage returns null for missing key', () async {
      when(mockStorage.read(
        key: anyNamed('key'),
        aOptions: anyNamed('aOptions'),
        iOptions: anyNamed('iOptions'),
      )).thenAnswer((_) async => null);

      final result = await manager.readFromStorage('missing');

      expect(result, isNull);
    });

    test('deleteFromStorage delegates to secure storage', () async {
      await manager.deleteFromStorage('key');

      verify(mockStorage.delete(
        key: 'key',
        aOptions: anyNamed('aOptions'),
        iOptions: anyNamed('iOptions'),
      )).called(1);
    });
  });
}
