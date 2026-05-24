import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/auth/data/data.dart';
import 'package:use_me/features/auth/domain/domain.dart';

import '../../../../helper/mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late LoginUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(repository: mockRepository);
  });

  group('call', () {
    final req = LoginRequest(email: 'a@b.com', password: 'secret');
    final entity = LoginEntity(
      id: 1,
      token: 'abc',
      meta: MetaEntity(
        poweredBy: 'Flutter',
        docsUrl: 'https://docs.com',
        upgradeUrl: 'https://upgrade.com',
        exampleUrl: 'https://example.com',
        variant: 'v1',
        message: 'Welcome',
        cta: const CtaEntity(label: 'Go', url: 'https://example.com'),
        context: 'login',
      ),
    );

    test('returns LoginEntity on success', () async {
      when(mockRepository.login(req))
          .thenAnswer((_) async => Right(entity));

      final result = await usecase(req);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => throw 'unexpected').token, 'abc');
    });

    test('returns Failure on error', () async {
      when(mockRepository.login(req))
          .thenAnswer((_) async => Left(Failure.serverFailure(message: 'error')));

      final result = await usecase(req);
      expect(result.isLeft(), isTrue);
    });
  });
}
