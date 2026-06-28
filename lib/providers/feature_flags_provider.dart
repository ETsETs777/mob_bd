// =============================================================================
// EcoPulse · lib/providers/feature_flags_provider.dart
// Автор: Цымбал Е. В.
// Дата: 21.05.2026
// Riverpod state: провайдеры и notifiers. Файл: feature_flags_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';
import 'app_providers.dart';

/// Enum [FeatureFlag] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
enum FeatureFlag {
/// Значение enum [sectorHeatmap].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  sectorHeatmap('flag_sector_heatmap', true),
/// Значение enum [stocksGrouped].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  stocksGrouped('flag_stocks_grouped', true),
/// Значение enum [verboseHttpLog].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  verboseHttpLog('flag_verbose_http', false);

  const FeatureFlag(this.storageKey, this.defaultValue);

  final String storageKey;
  final bool defaultValue;
}

/// Riverpod-провайдер [featureFlagsProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final featureFlagsProvider =
    NotifierProvider<FeatureFlagsNotifier, Map<FeatureFlag, bool>>(
  FeatureFlagsNotifier.new,
);

/// Riverpod AsyncNotifier [FeatureFlagsNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class FeatureFlagsNotifier extends Notifier<Map<FeatureFlag, bool>> {
/// Отрисовывает UI [FeatureFlagsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  @override
  Map<FeatureFlag, bool> build() {
    final cache = ref.watch(cacheServiceProvider);
    return {
      for (final flag in FeatureFlag.values)
        flag: _readFlag(cache, flag),
    };
  }

/// Приватный метод [_readFlag] класса [FeatureFlagsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  bool _readFlag(CacheService cache, FeatureFlag flag) {
    final raw = cache.getString(flag.storageKey);
    if (raw == null) return flag.defaultValue;
    return raw == '1';
  }

/// Метод [setFlag] класса [FeatureFlagsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> setFlag(FeatureFlag flag, bool value) async {
    await ref.read(cacheServiceProvider).putString(
          flag.storageKey,
          value ? '1' : '0',
        );
    state = {...state, flag: value};
  }

/// Метод [isEnabled] класса [FeatureFlagsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  bool isEnabled(FeatureFlag flag) => state[flag] ?? flag.defaultValue;
}
