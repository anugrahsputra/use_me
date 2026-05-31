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
import 'package:use_me/core/core.dart';

export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
export 'utils/utils.dart';

mixin class CoreModule {
  static Future<void> register(GetIt sl) async {
    unawaited(initializeDateFormatting());

    final dir = await getTemporaryDirectory();

    sl.registerFactory<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
    sl.registerFactory<Client>(() => ClientImpl(dio: sl<Dio>()));
    sl.registerFactory<AppNavigator>(AppNavigator.new);
    sl.registerLazySingleton<LocalStorageManager>(
      () => LocalStorageManagerImpl(storage: sl<FlutterSecureStorage>()),
    );
    sl.registerLazySingleton<StoreKey>(
      () => StoreKey(localStorageManager: sl<LocalStorageManager>()),
    );

    /* -----------------> Network <-----------------*/
    sl.registerFactory<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 35),
          receiveTimeout: const Duration(seconds: 35),
          sendTimeout: const Duration(seconds: 35),
        ),
      ),
      instanceName: 'interceptor',
    );

    sl.registerFactory<Dio>(
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
              ClientInterceptor(
                dio: sl<Dio>(instanceName: 'interceptor'),
                localStoreManager: sl<LocalStorageManager>(),
              ),

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
                      final key = await sl<StoreKey>().getStoredKey();
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
                      final key = await sl<StoreKey>().getStoredKey();
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
  }
}
