import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUsecase}) : super(LoginState()) {
    on<OnEmailChanged>(
      _loginOnEmailChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<OnPasswordChanged>(
      _loginOnPasswordChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<OnError>(_onError);
    on<OnLogin>(_onLogin);
  }

  final LoginUsecase loginUsecase;

  void _loginOnEmailChanged(OnEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    final isValid = Formz.validate([email, state.password]);
    emit(state.copyWith(email: email, isValid: isValid));
  }

  void _loginOnPasswordChanged(
    OnPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    final isValid = Formz.validate([password, state.email]);
    emit(state.copyWith(password: password, isValid: isValid));
  }

  void _onError(OnError event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: null),
    );
  }

  Future<void> _onLogin(OnLogin event, Emitter<LoginState> emit) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final isValid = Formz.validate([email, password]);

    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: isValid,
        hasSubmitted: true,
      ),
    );

    if (!isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final loginReq = LoginRequest(email: email.value, password: password.value);
    final result = await loginUsecase(loginReq);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }
}
