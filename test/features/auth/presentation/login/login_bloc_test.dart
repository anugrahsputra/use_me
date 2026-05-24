import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

import '../../../../helper/mocks.dart';

void main() {
  late MockLoginUsecase mockLoginUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
  });

  group('LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'emits updated email on OnEmailChanged',
      build: () => LoginBloc(loginUsecase: mockLoginUsecase),
      act: (bloc) => bloc.add(const OnEmailChanged('test@example.com')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        LoginState(
          email: Email.dirty('test@example.com'),
          isValid: Formz.validate([
            Email.dirty('test@example.com'),
            Password.pure(),
          ]),
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits updated password on OnPasswordChanged',
      build: () => LoginBloc(loginUsecase: mockLoginUsecase),
      act: (bloc) => bloc.add(const OnPasswordChanged('secret123')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        LoginState(
          password: Password.dirty('secret123'),
          isValid: Formz.validate([
            Email.pure(),
            Password.dirty('secret123'),
          ]),
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure status on OnError',
      build: () => LoginBloc(loginUsecase: mockLoginUsecase),
      act: (bloc) => bloc.add(const OnError()),
      expect: () => [
        LoginState(status: FormzSubmissionStatus.failure, errorMessage: null),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'does not login when form is invalid',
      build: () => LoginBloc(loginUsecase: mockLoginUsecase),
      act: (bloc) => bloc.add(const OnLogin()),
      expect: () => [
        LoginState(
          email: Email.dirty(''),
          password: Password.dirty(''),
          isValid: false,
          hasSubmitted: true,
        ),
      ],
      verify: (_) {
        verifyNever(mockLoginUsecase(any));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'logs in when form is valid',
      build: () {
        when(mockLoginUsecase(any))
            .thenAnswer((_) async => Right(
              LoginEntity(
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
              ),
            ));
        return LoginBloc(loginUsecase: mockLoginUsecase);
      },
      seed: () => LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('secret123'),
        isValid: true,
      ),
      act: (bloc) => bloc.add(const OnLogin()),
      skip: 2,
      verify: (_) {
        verify(mockLoginUsecase(any)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits success status on login success',
      build: () {
        when(mockLoginUsecase(any))
            .thenAnswer((_) async => Right(
              LoginEntity(
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
              ),
            ));
        return LoginBloc(loginUsecase: mockLoginUsecase);
      },
      seed: () => LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('secret123'),
        isValid: true,
      ),
      act: (bloc) => bloc.add(const OnLogin()),
      expect: () => [
        LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('secret123'),
          isValid: true,
          hasSubmitted: true,
        ),
        LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('secret123'),
          isValid: true,
          hasSubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
        LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('secret123'),
          isValid: true,
          hasSubmitted: true,
          status: FormzSubmissionStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure status on login failure',
      build: () {
        when(mockLoginUsecase(any))
            .thenAnswer((_) async => Left(Failure.serverFailure(message: 'error')));
        return LoginBloc(loginUsecase: mockLoginUsecase);
      },
      seed: () => LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('secret123'),
        isValid: true,
      ),
      act: (bloc) => bloc.add(const OnLogin()),
      expect: () => [
        LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('secret123'),
          isValid: true,
          hasSubmitted: true,
        ),
        LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('secret123'),
          isValid: true,
          hasSubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
        LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('secret123'),
          isValid: true,
          hasSubmitted: true,
          status: FormzSubmissionStatus.failure,
          errorMessage: 'error',
        ),
      ],
    );
  });
}
