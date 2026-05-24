import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';

import '../../helper/mocks.dart';

void main() {
  late MockLocalStorageManager mockStorage;
  late StoreKey storeKey;

  setUp(() {
    Logger.root.level = Level.OFF;
    mockStorage = MockLocalStorageManager();
    storeKey = StoreKey(localStorageManager: mockStorage);
  });

  group('StoreKey', () {
    test('generateKey creates a 32-char key and stores it', () async {
      when(mockStorage.writeToStorage(any, any)).thenAnswer((_) async {});

      final key = await storeKey.generateKey();

      expect(key.length, 32);
      verify(mockStorage.writeToStorage('encryption_key', key)).called(1);
    });

    test('getStoredKey returns existing key', () async {
      when(mockStorage.readFromStorage('encryption_key'))
          .thenAnswer((_) async => 'existing_key_value');

      final key = await storeKey.getStoredKey();

      expect(key, 'existing_key_value');
    });

    test('getStoredKey generates new key when none exists', () async {
      when(mockStorage.readFromStorage('encryption_key'))
          .thenAnswer((_) async => null);
      when(mockStorage.writeToStorage(any, any)).thenAnswer((_) async {});

      final key = await storeKey.getStoredKey();

      expect(key.length, 32);
      verify(mockStorage.writeToStorage('encryption_key', any)).called(1);
    });

    test('createCacheCipher returns a CacheCipher', () async {
      when(mockStorage.readFromStorage('encryption_key'))
          .thenAnswer((_) async => '1234567890123456'); // 16 chars = 128-bit AES

      final cipher = await storeKey.createCacheCipher();

      expect(cipher, isA<CacheCipher>());
      expect(cipher.encrypt, isA<Function>());
      expect(cipher.decrypt, isA<Function>());
    });

    test('CacheCipher encrypt then decrypt roundtrip', () async {
      when(mockStorage.readFromStorage('encryption_key'))
          .thenAnswer((_) async => '1234567890123456'); // 16 chars = 128-bit AES

      final cipher = await storeKey.createCacheCipher();
      final original = [1, 2, 3, 4, 5];

      final encrypted = await cipher.encrypt(original);
      expect(encrypted.length, greaterThan(original.length));

      final decrypted = await cipher.decrypt(encrypted);
      expect(decrypted, original);
    });
  });
}
