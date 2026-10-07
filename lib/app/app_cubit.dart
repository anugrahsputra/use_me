import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';

part 'app_state.dart';
part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.localStorageManager, required this.logoutUsecase})
    : super(const AppInitial()) {
    _checkToken();
  }

  final LocalStorageManager localStorageManager;
  final LogoutUsecase logoutUsecase;

  Future<void> _checkToken() async {
    emit(const AppLoading());
    final token = await localStorageManager.readFromStorage('access_token');
    if (token == null || token.isEmpty) {
      emit(const AppUnauthenticated());
      return;
    }
    emit(const AppAuthenticated());
  }

  void loggedIn() => emit(const AppAuthenticated());

  Future<void> logout() async {
    emit(const AppLoading());
    final result = await logoutUsecase();

    await result.fold(
      (failure) async {
        emit(AppError(failure.message));
      },
      (_) async {
        await _clearSession();
        emit(const AppUnauthenticated());
      },
    );
  }

  Future<void> _clearSession() async {
    await localStorageManager.deleteFromStorage('access_token');
    await localStorageManager.deleteFromStorage('refresh_token');
  }
}
