// =============================================================================
// EcoPulse · lib/providers/accent_provider.dart
// Автор: Цымбал Е. В.
// Дата: 17.05.2026
// Riverpod state: провайдеры и notifiers. Файл: accent_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_accent.dart';
import '../data/services/cache_service.dart';

/// Riverpod-провайдер [accentColorProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
final accentColorProvider =
    NotifierProvider<AccentColorNotifier, AppAccentColor>(
  AccentColorNotifier.new,
);

/// Riverpod AsyncNotifier [AccentColorNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
class AccentColorNotifier extends Notifier<AppAccentColor> {
/// Поле [_key] класса [AccentColorNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const _key = 'accent_color';

/// Отрисовывает UI [AccentColorNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  AppAccentColor build() {
    return AppAccentColor.fromKey(CacheService.instance.getString(_key));
  }

/// Метод [setAccent] класса [AccentColorNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<void> setAccent(AppAccentColor accent) async {
    state = accent;
    await CacheService.instance.putString(_key, accent.key);
  }
}
