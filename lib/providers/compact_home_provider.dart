// =============================================================================
// EcoPulse · lib/providers/compact_home_provider.dart
// Автор: Цымбал Е. В.
// Дата: 19.05.2026
// Riverpod state: провайдеры и notifiers. Файл: compact_home_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';

/// Riverpod-провайдер [compactHomeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
final compactHomeProvider =
    NotifierProvider<CompactHomeNotifier, bool>(CompactHomeNotifier.new);

/// Riverpod AsyncNotifier [CompactHomeNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
class CompactHomeNotifier extends Notifier<bool> {
/// Поле [_key] класса [CompactHomeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  static const _key = 'compact_home';

/// Отрисовывает UI [CompactHomeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  @override
  bool build() {
    return CacheService.instance.getString(_key) == 'true';
  }

/// Метод [setEnabled] класса [CompactHomeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await CacheService.instance.putString(_key, enabled ? 'true' : 'false');
  }
}
