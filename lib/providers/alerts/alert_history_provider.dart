// =============================================================================
// EcoPulse · lib/providers/alert_history_provider.dart
// Автор: Цымбал Е. В.
// Дата: 17.05.2026
// Riverpod state: провайдеры и notifiers. Файл: alert_history_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/price_alert.dart';
import '../../data/services/cache_service.dart';

/// Riverpod-провайдер [alertHistoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
final alertHistoryProvider =
    NotifierProvider<AlertHistoryNotifier, List<AlertHistoryEntry>>(
  AlertHistoryNotifier.new,
);

/// Riverpod AsyncNotifier [AlertHistoryNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
class AlertHistoryNotifier extends Notifier<List<AlertHistoryEntry>> {
/// Поле [cacheKey] класса [AlertHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const cacheKey = 'alert_history_v1';
/// Поле [maxEntries] класса [AlertHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  static const maxEntries = 50;

/// Отрисовывает UI [AlertHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  @override
  List<AlertHistoryEntry> build() => _load();

/// Приватный метод [_load] класса [AlertHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  List<AlertHistoryEntry> _load() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => AlertHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Метод [add] класса [AlertHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> add({
    required String alertId,
    required String symbol,
    required String message,
  }) async {
    final entry = AlertHistoryEntry(
      alertId: alertId,
      symbol: symbol,
      message: message,
      triggeredAt: DateTime.now(),
    );
    final next = [...state, entry];
    state = next.length > maxEntries ? next.sublist(next.length - maxEntries) : next;
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }

/// Метод [clear] класса [AlertHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> clear() async {
    state = [];
    await CacheService.instance.putString(cacheKey, '[]');
  }
}
