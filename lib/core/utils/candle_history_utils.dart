// =============================================================================
// EcoPulse · lib/core/utils/candle_history_utils.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Merge/dedupe candle history for lazy load.
// =============================================================================

import '../../data/models/candle_point.dart';
import '../../data/models/price_point.dart';

/// Объединяет старые и новые свечи, сортирует по дате, убирает дубликаты.
List<CandlePoint> mergeCandleHistory(
  List<CandlePoint> existing,
  List<CandlePoint> older,
) {
  if (older.isEmpty) return existing;
  final byDay = <String, CandlePoint>{};
  for (final c in [...older, ...existing]) {
    byDay[_dayKey(c.date)] = c;
  }
  final merged = byDay.values.toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return merged;
}

List<PricePoint> mergePriceHistory(
  List<PricePoint> existing,
  List<PricePoint> older,
) {
  if (older.isEmpty) return existing;
  final byDay = <String, PricePoint>{};
  for (final p in [...older, ...existing]) {
    byDay[_dayKey(p.date)] = p;
  }
  final merged = byDay.values.toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return merged;
}

String _dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
