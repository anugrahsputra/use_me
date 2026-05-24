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
    final token = await localStorageManager.readFromStorage('token');
    if (token != null && token.isNotEmpty) {
      emit(const AppAuthenticated());
    } else {
      emit(const AppUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(const AppLoading());
    localStorageManager.deleteFromStorage('token');
    // final result = await logoutUsecase();
    // result.fold(
    //   (left) => emit(AppError(left.message)),
    //   (_) => emit(const AppUnauthenticated()),
    // );
    emit(const AppUnauthenticated());
  }
}
