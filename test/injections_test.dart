import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/home/home.dart';
import 'package:use_me/features/home/presentation/home_cubit/home_cubit.dart';
import 'package:use_me/injections.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await di.reset();

    // Mock the path_provider platform channel so getTemporaryDirectory()
    // doesn't throw MissingPluginException in unit test environments.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async {
        if (call.method == 'getTemporaryDirectory') return '/tmp';
        return null;
      },
    );
  });

  tearDown(() async {
    await di.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
  });

  group('configureDependencies', () {
    test('completes without throwing', () async {
      await expectLater(configureDependencies(), completes);
    });

    test('registers core types after configuration', () async {
      await configureDependencies();

      expect(di.isRegistered<FlutterSecureStorage>(), isTrue);
      expect(di.isRegistered<LocalStorageManager>(), isTrue);
      expect(di.isRegistered<StoreKey>(), isTrue);
      expect(di.isRegistered<Client>(), isTrue);
      expect(di.isRegistered<AppNavigator>(), isTrue);
      expect(di.isRegistered<Dio>(), isTrue);
    });

    test('registers auth types after configuration', () async {
      await configureDependencies();

      expect(di.isRegistered<AuthDatasource>(), isTrue);
      expect(di.isRegistered<AuthRepository>(), isTrue);
      expect(di.isRegistered<LoginUsecase>(), isTrue);
      expect(di.isRegistered<LogoutUsecase>(), isTrue);
      expect(di.isRegistered<LoginBloc>(), isTrue);
    });

    test('registers home types after configuration', () async {
      await configureDependencies();

      expect(di.isRegistered<HomeCubit>(), isTrue);
    });

    test('registers app types after configuration', () async {
      await configureDependencies();

      expect(di.isRegistered<AppCubit>(), isTrue);
    });
  });
}
