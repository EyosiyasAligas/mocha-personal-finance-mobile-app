import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';

import '../../config/firebase_remote_config.dart';
import '../constants/api_constants.dart';
import '../local_storage/local_storage_service.dart';
import '../network/dio_client.dart';

final sl = GetIt.I;
final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> setupServiceLocator() async {
  /// Firebase remote config
  sl.registerSingletonAsync<RemoteConfigService>(() async {
    // Set default values
    await remoteConfig.setDefaults({
      'light_primary': '#B119FB',
      'light_secondary': '#E1992B',
      'dark_primary': '#B119FB',
      'dark_secondary': '#E1992B',
    });
    // Fetch and activate initial values
    try {
      await remoteConfig.fetchAndActivate();
    } catch (_) {}
    return RemoteConfigService(remoteConfig);
  });

  /// storage
  sl.registerSingletonAsync<LocalStorageService>(() async {
    LocalStorageService localStorageService = LocalStorageService();
    await localStorageService.init();
    return localStorageService;
  });

  /// network
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    ),
  );
  sl.registerLazySingleton(
    () {
      return DioClient(sl<LocalStorageService>(), sl<Dio>());
    },
  );

  /// Wait for all async singletons to be ready
  await sl.allReady();
}
