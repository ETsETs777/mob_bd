import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/pro/pro_limits.dart';
import '../../data/services/cache_service.dart';

final proTierProvider = NotifierProvider<ProTierNotifier, bool>(ProTierNotifier.new);

class ProTierNotifier extends Notifier<bool> {
  static const cacheKey = 'ecopulse_pro_unlocked';

  @override
  bool build() {
    if (ProConfig.compileTimePro) return true;
    return CacheService.instance.getString(cacheKey) == '1';
  }

  Future<void> unlockLocal() async {
    await CacheService.instance.putString(cacheKey, '1');
    state = true;
  }

  Future<void> resetLocal() async {
    if (ProConfig.compileTimePro) return;
    await CacheService.instance.deleteKey(cacheKey);
    state = false;
  }
}
