import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

import '../../../../helper/mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late LogoutUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUsecase(repository: mockRepository);
  });

  group('call', () {
    test('returns Unit on success', () async {
      when(mockRepository.logout())
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase();
      expect(result.isRight(), isTrue);
    });

    test('returns Failure on error', () async {
      when(mockRepository.logout())
          .thenAnswer((_) async => Left(Failure.serverFailure(message: 'error')));

      final result = await usecase();
      expect(result.isLeft(), isTrue);
    });
  });
}
