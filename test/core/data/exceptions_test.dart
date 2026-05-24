import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('ServerException', () {
    test('uses default message', () {
      expect(ServerException().message, 'Server Exception');
      expect(ServerException().toString(), 'Server Exception');
    });

    test('uses custom message', () {
      final e = ServerException(message: 'custom');
      expect(e.message, 'custom');
      expect(e.toString(), 'custom');
    });
  });

  group('NetworkException', () {
    test('uses default message', () {
      expect(NetworkException().message, 'NetworkException');
      expect(NetworkException().toString(), 'NetworkException');
    });
  });

  group('UnauthorizedException', () {
    test('uses default message', () {
      expect(UnauthorizedException().message, 'UnauthorizedException');
      expect(UnauthorizedException().toString(), 'UnauthorizedException');
    });
  });

  group('BadRequestException', () {
    test('uses default message', () {
      expect(BadRequestException().message, 'BadRequestException');
      expect(BadRequestException().toString(), 'BadRequestException');
    });
  });

  group('ForbiddenException', () {
    test('uses default message', () {
      expect(ForbiddenException().message, 'ForbiddenException');
      expect(ForbiddenException().toString(), 'ForbiddenException');
    });
  });

  group('NotFoundException', () {
    test('uses default message', () {
      expect(NotFoundException().message, 'ForbiddenException');
      expect(NotFoundException().toString(), 'ForbiddenException');
    });
  });

  group('CacheException', () {
    test('uses default message', () {
      expect(CacheException().message, 'CacheException');
      expect(CacheException().toString(), 'CacheException');
    });
  });

  group('DatabaseException', () {
    test('uses default message', () {
      expect(DatabaseException().message, 'DatabaseException');
      expect(DatabaseException().toString(), 'DatabaseException');
    });
  });

  group('UnknownException', () {
    test('uses default message', () {
      expect(UnknownException().message, 'UnknownException');
      expect(UnknownException().toString(), 'UnknownException');
    });
  });
}
