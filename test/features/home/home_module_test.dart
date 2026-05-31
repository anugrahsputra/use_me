import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:use_me/features/home/home.dart';
import 'package:use_me/features/home/presentation/home_cubit/home_cubit.dart';

void main() {
  late GetIt sl;

  setUp(() {
    sl = GetIt.asNewInstance();
  });

  tearDown(() async {
    await sl.reset();
  });

  group('HomeModule.register', () {
    test('registers HomeCubit', () async {
      await HomeModule.register(sl);

      expect(sl.isRegistered<HomeCubit>(), isTrue);
    });

    test('HomeCubit resolves as a new factory instance each time', () async {
      await HomeModule.register(sl);

      final a = sl<HomeCubit>();
      final b = sl<HomeCubit>();

      expect(a, isA<HomeCubit>());
      expect(identical(a, b), isFalse);
    });
  });
}
