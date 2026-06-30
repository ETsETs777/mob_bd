import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../data/services/cache_service.dart';

/// Настройки фоновой синхронизации календаря/аватара.
class UserLocalDataSyncPreferences {
  UserLocalDataSyncPreferences._();

  static const _cacheKey = 'user_local_data_sync_wifi_only_v1';
  static const _autoPushKey = 'user_local_data_sync_auto_push_v1';

  static bool get wifiOnly {
    final raw = CacheService.instance.getString(_cacheKey);
    return raw == '1';
  }

  static bool get autoPushOnChange {
    final raw = CacheService.instance.getString(_autoPushKey);
    return raw == null || raw == '1';
  }

  static Future<void> setWifiOnly(bool value) async {
    await CacheService.instance.putString(_cacheKey, value ? '1' : '0');
  }

  static Future<void> setAutoPushOnChange(bool value) async {
    await CacheService.instance.putString(_autoPushKey, value ? '1' : '0');
  }

  /// Можно ли запускать auto smart-sync сейчас.
  static Future<bool> canAutoSync() async {
    if (!wifiOnly) return true;
    if (kIsWeb) return true;

    final results = await Connectivity().checkConnectivity();
    return results.any(
      (r) =>
          r == ConnectivityResult.wifi || r == ConnectivityResult.ethernet,
    );
  }
}
