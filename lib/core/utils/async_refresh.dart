// =============================================================================
// EcoPulse · lib/core/utils/async_refresh.dart
// Автор: Цымбал Е. В.
// Дата: 06.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: async_refresh.
// =============================================================================

import 'package:flutter/foundation.dart';

/// Функция [debugLog] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
void debugLog(String message) {
  if (kDebugMode) {
    // ignore: avoid_print
    print('[EcoPulse] $message');
  }
}

/// Функция [parallelMap] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
Future<List<T>> parallelMap<E, T>(
  List<E> items,
  Future<T> Function(E item) mapper, {
  int concurrency = 4,
}) async {
  if (items.isEmpty) return [];
  final results = List<T?>.filled(items.length, null);
  var index = 0;

  Future<void> worker() async {
    while (true) {
      final i = index++;
      if (i >= items.length) break;
      results[i] = await mapper(items[i]);
    }
  }

  final workers = List.generate(
    concurrency.clamp(1, items.length),
    (_) => worker(),
  );
  await Future.wait(workers);
  return results.whereType<T>().toList();
}
