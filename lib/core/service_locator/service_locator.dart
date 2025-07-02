import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';

import '../../config/firebase_remote_config.dart';

final sl = GetIt.I;
final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> setupServiceLocator() async {
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

  // Wait for all async singletons to be ready
  await sl.allReady();
}
