import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/home/home.dart';

final di = GetIt.instance;

Future<void> initDI() async {
  unawaited(initializeDateFormatting());

  final dir = await getTemporaryDirectory();

  di
    ..registerFactory<FlutterSecureStorage>(() => const FlutterSecureStorage())
    ..registerFactory<Client>(() => ClientImpl(dio: di<Dio>()))
    ..registerFactory<AppNavigator>(AppNavigator.new)
    ..registerLazySingleton<LocalStorageManager>(
      () => LocalStorageManagerImpl(storage: di<FlutterSecureStorage>()),
    )
    ..registerLazySingleton<StoreKey>(
      () => StoreKey(localStorageManager: di<LocalStorageManager>()),
    )
    /* -----------------> Network <-----------------*/
    ..registerFactory<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 35),
          receiveTimeout: const Duration(seconds: 35),
          sendTimeout: const Duration(seconds: 35),
        ),
      ),
      instanceName: 'interceptor',
    )
    ..registerFactory<Dio>(
      () =>
          Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 35),
                receiveTimeout: const Duration(seconds: 35),
                sendTimeout: const Duration(seconds: 35),
              ),
            )
            // ..addSentry(captureFailedRequests: true)
            // ..httpClientAdapter = NativeAdapter()
            ..interceptors.addAll([
              ClientInterceptor(localStoreManager: di<LocalStorageManager>()),
              // CertificatePinningInterceptor(
              //   allowedSHAFingerprints: ShaFingerprints.allowedSHAFingerprints,
              // ),
              DioCacheInterceptor(
                options: CacheOptions(
                  store: HiveCacheStore(dir.path),
                  priority: CachePriority.high,
                  policy: CachePolicy.forceCache,
                  maxStale: const Duration(days: 7),
                  cipher: CacheCipher(
                    encrypt: (byte) async {
                      final key = await di<StoreKey>().getStoredKey();
                      final iv = encrypt.IV.fromSecureRandom(16);
                      final encrypter = encrypt.Encrypter(
                        encrypt.AES(encrypt.Key.fromUtf8(key)),
                      );
                      final encrypted = encrypter.encryptBytes(
                        Uint8List.fromList(byte),
                        iv: iv,
                      );
                      return [...iv.bytes, ...encrypted.bytes];
                    },
                    decrypt: (byte) async {
                      final key = await di<StoreKey>().getStoredKey();
                      final iv = encrypt.IV(
                        Uint8List.fromList(byte.sublist(0, 16)),
                      );
                      final encryptedData = Uint8List.fromList(
                        byte.sublist(16),
                      );
                      final encrypter = encrypt.Encrypter(
                        encrypt.AES(encrypt.Key.fromUtf8(key)),
                      );
                      final encrypted = encrypt.Encrypted(encryptedData);
                      final decryptedBytes = encrypter.decryptBytes(
                        encrypted,
                        iv: iv,
                      );
                      return decryptedBytes;
                    },
                  ),
                ),
              ),
            ]),
    );

  di.registerFactory<AppCubit>(
    () => AppCubit(
      localStorageManager: di<LocalStorageManager>(),
      logoutUsecase: di<LogoutUsecase>(),
    ),
  );

  _authDI();
  _homeDI();
}

void _authDI() {
  di.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(client: di<Client>()),
  );
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      datasource: di<AuthDatasource>(),
      localStorageManager: di<LocalStorageManager>(),
    ),
  );

  di.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: di<AuthRepository>()),
  );

  di.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(repository: di<AuthRepository>()),
  );
  di.registerFactory<LoginBloc>(
    () => LoginBloc(loginUsecase: di<LoginUsecase>()),
  );
}

void _homeDI() {
  di.registerFactory<HomeCubit>(() => HomeCubit());
}
