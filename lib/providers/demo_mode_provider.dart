// =============================================================================
// EcoPulse · lib/providers/demo_mode_provider.dart
// Автор: Цымбал Е. В.
// Дата: 21.05.2026
// Riverpod state: провайдеры и notifiers. Файл: demo_mode_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';
import 'app_providers.dart';
import 'commodities_provider.dart';
import 'indices_provider.dart';
import 'news_provider.dart';

/// Riverpod: демо-режим с mock-данными.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
final demoModeProvider =
    NotifierProvider<DemoModeNotifier, bool>(DemoModeNotifier.new);

/// Riverpod AsyncNotifier [DemoModeNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
class DemoModeNotifier extends Notifier<bool> {
/// Поле [cacheKey] класса [DemoModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  static const cacheKey = 'demo_mode_enabled';

/// Отрисовывает UI [DemoModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  @override
  bool build() {
    return ref.watch(cacheServiceProvider).getString(cacheKey) == '1';
  }

/// Метод [setEnabled] класса [DemoModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> setEnabled(bool value) async {
    await ref.read(cacheServiceProvider).putString(cacheKey, value ? '1' : '0');
    state = value;
    _invalidateData();
  }

/// Приватный метод [_invalidateData] класса [DemoModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  void _invalidateData() {
    ref.invalidate(currencyRatesProvider);
    ref.invalidate(inflationProvider);
    ref.invalidate(cryptoProvider);
    ref.invalidate(stocksProvider);
    ref.invalidate(bondsProvider);
    ref.invalidate(keyRateProvider);
    ref.invalidate(commoditiesProvider);
    ref.invalidate(fearGreedProvider);
    ref.invalidate(usIndicesProvider);
    ref.invalidate(marketNewsProvider);
    ref.invalidate(macroCalendarProvider);
  }
}

/// Функция [isDemoMode] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
bool isDemoMode(Ref ref) => ref.read(demoModeProvider);
