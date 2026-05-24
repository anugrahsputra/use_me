import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/auth/data/data.dart';
import 'package:use_me/features/auth/domain/domain.dart';

import '../../../../helper/mocks.dart';

void main() {
  late MockAuthDatasource mockDatasource;
  late MockLocalStorageManager mockStorage;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockAuthDatasource();
    mockStorage = MockLocalStorageManager();
    repository = AuthRepositoryImpl(
      datasource: mockDatasource,
      localStorageManager: mockStorage,
    );
  });

  group('login', () {
    final req = LoginRequest(email: 'a@b.com', password: 'secret');
    final loginResponse = LoginResponse.fromJson({
      'id': 1,
      'token': 'abc123',
      '_meta': {
        'powered_by': 'Flutter',
        'docs_url': 'https://docs.com',
        'upgrade_url': 'https://upgrade.com',
        'example_url': 'https://example.com',
        'variant': 'v1',
        'message': 'Welcome',
        'cta': {'label': 'Go', 'url': 'https://example.com'},
        'context': 'login',
      },
    });

    test('returns LoginEntity and saves token on success', () async {
      when(mockDatasource.login(req))
          .thenAnswer((_) async => Right(loginResponse));
      when(mockStorage.writeToStorage(any, any))
          .thenAnswer((_) async {});

      final result = await repository.login(req);

      expect(result.isRight(), isTrue);
      final entity = result.getOrElse(() => throw 'unexpected');
      expect(entity, isA<LoginEntity>());
      expect(entity.id, 1);
      expect(entity.token, 'abc123');
      verify(mockStorage.writeToStorage('token', 'abc123')).called(1);
    });

    test('returns Failure when datasource fails', () async {
      when(mockDatasource.login(req))
          .thenAnswer((_) async => Left(Failure.serverFailure(message: 'error')));

      final result = await repository.login(req);

      expect(result.isLeft(), isTrue);
      verifyNever(mockStorage.writeToStorage(any, any));
    });
  });

  group('logout', () {
    test('returns Unit and deletes token on success', () async {
      when(mockDatasource.logout())
          .thenAnswer((_) async => const Right(unit));
      when(mockStorage.deleteFromStorage(any))
          .thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result.isRight(), isTrue);
      verify(mockStorage.deleteFromStorage('token')).called(1);
    });

    test('returns Failure when datasource fails', () async {
      when(mockDatasource.logout())
          .thenAnswer((_) async => Left(Failure.serverFailure(message: 'error')));

      final result = await repository.logout();

      expect(result.isLeft(), isTrue);
      verifyNever(mockStorage.deleteFromStorage(any));
    });
  });
}
