// =============================================================================
// EcoPulse · lib/providers/compare_assets_provider.dart
// Автор: Цымбал Е. В.
// Дата: 20.05.2026
// Riverpod state: провайдеры и notifiers. Файл: compare_assets_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/app/app_providers.dart';

/// Top-level переменная [maxCompareAssets].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
const maxCompareAssets = 4;

/// Riverpod-провайдер [compareSelectionProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
final compareSelectionProvider =
    NotifierProvider<CompareSelectionNotifier, List<String>>(
  CompareSelectionNotifier.new,
);

/// Ключи активов `type:id` для экрана сравнения.
class CompareSelectionNotifier extends Notifier<List<String>> {
/// Поле [cacheKey] класса [CompareSelectionNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  static const cacheKey = 'compare_selection';

/// Отрисовывает UI [CompareSelectionNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  @override
  List<String> build() {
    final raw = ref.watch(cacheServiceProvider).getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    return raw.split(',').where((s) => s.contains(':')).take(maxCompareAssets).toList();
  }

/// Метод [contains] класса [CompareSelectionNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  bool contains(String key) => state.contains(key);

/// Метод [toggle] класса [CompareSelectionNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> toggle(String key) async {
    if (state.contains(key)) {
      state = state.where((k) => k != key).toList();
    } else if (state.length < maxCompareAssets) {
      state = [...state, key];
    }
    await _persist();
  }

/// Метод [clear] класса [CompareSelectionNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> clear() async {
    state = [];
    await _persist();
  }

/// Приватный метод [_persist] класса [CompareSelectionNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Future<void> _persist() async {
    await ref.read(cacheServiceProvider).putString(cacheKey, state.join(','));
  }
}
