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
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:uuid/uuid.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/flavors.dart';

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
    sl.registerLazySingleton<AppNavigator>(AppNavigator.new);
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
          baseUrl: F.apiBaseUrl,
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
                baseUrl: F.apiBaseUrl,
                connectTimeout: const Duration(seconds: 35),
                receiveTimeout: const Duration(seconds: 35),
                sendTimeout: const Duration(seconds: 35),
              ),
            )
            // ..addSentry(captureFailedRequests: true)
            // ..httpClientAdapter = NativeAdapter()
            ..interceptors.addAll([
              TalkerDioLogger(
                talker: talker,
                settings: const TalkerDioLoggerSettings(
                  printRequestData: true,
                  printResponseData: true,

                  // Safe to print because hiddenHeaders masks the bearer, the API key,
                  // and the refresh cookie below.
                  printRequestHeaders: true,
                  hiddenHeaders: {'authorization', 'cookie', 'x-api-key'},

                  // Off, and they must stay off: as of talker_dio_logger
                  // 5.1.20 only DioRequestLog applies hiddenHeaders, so a 401
                  // would write `set-cookie: refresh_token=...` into history
                  // in full.
                  printErrorHeaders: false,
                  printResponseHeaders: false,
                ),
              ),
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
                  priority: CachePriority.low,
                  policy: CachePolicy.request,
                  maxStale: const Duration(days: 7),
                  keyBuilder: cacheKeyBuilder,
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

const _uuid = Uuid();

String cacheKeyBuilder({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
}) {
  final auth =
      headers?.entries
          .where((e) => e.key.toLowerCase() == 'authorization')
          .map((e) => e.value)
          .firstOrNull ??
      '';
  return _uuid.v5(Namespace.url.value, '$auth|$url');
}
