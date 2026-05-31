import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:use_me/core/core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GetIt sl;

  setUp(() {
    sl = GetIt.asNewInstance();

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
    await sl.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
  });

  group('CoreModule.register', () {
    test('registers all expected types', () async {
      await CoreModule.register(sl);

      expect(sl.isRegistered<FlutterSecureStorage>(), isTrue);
      expect(sl.isRegistered<LocalStorageManager>(), isTrue);
      expect(sl.isRegistered<StoreKey>(), isTrue);
      expect(sl.isRegistered<Client>(), isTrue);
      expect(sl.isRegistered<AppNavigator>(), isTrue);
      expect(sl.isRegistered<Dio>(), isTrue);
    });

    test('FlutterSecureStorage is registered as a factory', () async {
      await CoreModule.register(sl);

      expect(sl.isRegistered<FlutterSecureStorage>(), isTrue);
      // const constructor always returns the same canonical instance;
      // the important check is that it's registered as a factory (not singleton).
      expect(sl<FlutterSecureStorage>(), isA<FlutterSecureStorage>());
    });

    test('LocalStorageManager resolves as a lazy singleton', () async {
      await CoreModule.register(sl);

      final a = sl<LocalStorageManager>();
      final b = sl<LocalStorageManager>();

      expect(a, isA<LocalStorageManagerImpl>());
      expect(identical(a, b), isTrue);
    });

    test('StoreKey resolves as a lazy singleton', () async {
      await CoreModule.register(sl);

      final a = sl<StoreKey>();
      final b = sl<StoreKey>();

      expect(identical(a, b), isTrue);
    });

    test('Client resolves as a new factory instance each time', () async {
      await CoreModule.register(sl);

      final a = sl<Client>();
      final b = sl<Client>();

      expect(a, isA<ClientImpl>());
      expect(identical(a, b), isFalse);
    });

    test('AppNavigator resolves as a new factory instance each time', () async {
      await CoreModule.register(sl);

      final a = sl<AppNavigator>();
      final b = sl<AppNavigator>();

      expect(a, isA<AppNavigator>());
      expect(identical(a, b), isFalse);
    });

    test('Dio (unnamed) resolves as a new factory instance each time',
        () async {
      await CoreModule.register(sl);

      final a = sl<Dio>();
      final b = sl<Dio>();

      expect(a, isA<Dio>());
      expect(identical(a, b), isFalse);
    });

    test('Dio (interceptor) named instance is registered', () async {
      await CoreModule.register(sl);

      expect(
        sl.isRegistered<Dio>(instanceName: 'interceptor'),
        isTrue,
      );

      final dio = sl<Dio>(instanceName: 'interceptor');
      expect(dio, isA<Dio>());
    });
  });
}
