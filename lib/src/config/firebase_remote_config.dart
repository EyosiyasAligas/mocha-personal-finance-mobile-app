import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  final ValueNotifier<RemoteThemeConfig> themeConfigNotifier;

  RemoteConfigService(this._remoteConfig)
    : themeConfigNotifier = ValueNotifier(_parseConfig(_remoteConfig)) {
    _remoteConfig.onConfigUpdated.listen((_) => _applyConfig());
  }

  /// Parse config values into RemoteThemeConfig
  static RemoteThemeConfig _parseConfig(FirebaseRemoteConfig rc) {
    Color parseColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }

    return RemoteThemeConfig(
      lightPrimary: parseColor(rc.getString('light_primary')),
      lightSecondary: parseColor(rc.getString('light_secondary')),
      darkPrimary: parseColor(rc.getString('dark_primary')),
      darkSecondary: parseColor(rc.getString('dark_secondary')),
    );
  }

  void _applyConfig() {
    themeConfigNotifier.value = _parseConfig(_remoteConfig);
  }

  /// Manually trigger fetch and activate
  Future<void> fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }
}

class RemoteThemeConfig {
  final Color lightPrimary;
  final Color lightSecondary;
  final Color darkPrimary;
  final Color darkSecondary;

  RemoteThemeConfig({
    required this.lightPrimary,
    required this.lightSecondary,
    required this.darkPrimary,
    required this.darkSecondary,
  });
}
