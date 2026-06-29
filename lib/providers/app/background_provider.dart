// =============================================================================
// EcoPulse · lib/providers/background_provider.dart
// Автор: Цымбал Е. В.
// Дата: 19.05.2026
// Riverpod state: провайдеры и notifiers. Файл: background_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_backgrounds.dart';
import '../../data/services/cache_service.dart';

/// Riverpod-провайдер [backgroundPresetProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
final backgroundPresetProvider =
    NotifierProvider<BackgroundPresetNotifier, AppBackgroundPreset>(
  BackgroundPresetNotifier.new,
);

/// Riverpod AsyncNotifier [BackgroundPresetNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
class BackgroundPresetNotifier extends Notifier<AppBackgroundPreset> {
/// Поле [_cacheKey] класса [BackgroundPresetNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  static const _cacheKey = 'background_preset';

/// Отрисовывает UI [BackgroundPresetNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  @override
  AppBackgroundPreset build() {
    final stored = CacheService.instance.getString(_cacheKey);
    return AppBackgroundPresetX.fromString(stored);
  }

/// Метод [setPreset] класса [BackgroundPresetNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> setPreset(AppBackgroundPreset preset) async {
    state = preset;
    await CacheService.instance.putString(_cacheKey, preset.storageKey);
  }
}
