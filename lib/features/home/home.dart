import 'package:get_it/get_it.dart';
import 'package:use_me/features/home/presentation/home_cubit/home_cubit.dart';

export 'presentation/presentation.dart';

mixin class HomeModule {
  static Future<void> register(GetIt sl) async {
    sl.registerFactory<HomeCubit>(() => HomeCubit());
  }
}
