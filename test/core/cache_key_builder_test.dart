import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('cacheKeyBuilder', () {
    const url = 'https://example.com/api/items/active';

    test('same header and url produces the same key', () {
      final key1 = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'authorization': 'Bearer token-aaa'},
      );
      final key2 = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'authorization': 'Bearer token-aaa'},
      );
      expect(key1, equals(key2));
    });

    test('different headers on the same url produce different keys', () {
      final keyA = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'authorization': 'Bearer token-aaa'},
      );
      final keyB = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'authorization': 'Bearer token-bbb'},
      );
      expect(keyA, isNot(equals(keyB)));
    });

    test('missing Authorization header still produces a valid key', () {
      final key = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'content-type': 'application/json'},
      );
      expect(key, isA<String>());
      expect(key.isNotEmpty, isTrue);
    });

    test('null headers produces a valid key', () {
      final key = cacheKeyBuilder(url: Uri.parse(url));
      expect(key, isA<String>());
      expect(key.isNotEmpty, isTrue);
    });

    test('Authorization header is case-insensitive', () {
      final keyLower = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'authorization': 'Bearer token-aaa'},
      );
      final keyUpper = cacheKeyBuilder(
        url: Uri.parse(url),
        headers: {'Authorization': 'Bearer token-aaa'},
      );
      expect(keyLower, equals(keyUpper));
    });
  });
}
