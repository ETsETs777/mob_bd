// =============================================================================
// EcoPulse · lib/core/utils/chart_normalize.dart
// Автор: Цымбал Е. В.
// Дата: 07.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: chart_normalize.
// =============================================================================

import '../../data/models/price_point.dart';

/// Выравнивает серии по минимальной длине (берёт последние N точек).
List<List<PricePoint>> alignPriceSeries(List<List<PricePoint>> series) {
  if (series.isEmpty) return [];
  final minLen = series.map((s) => s.length).reduce((a, b) => a < b ? a : b);
  if (minLen < 2) return [];
  return series.map((s) => s.sublist(s.length - minLen)).toList();
}

/// Нормализует ряд к индексу 100 в первой точке (для сравнения на одном графике).
List<PricePoint> normalizeSeriesToIndex(List<PricePoint> points) {
  if (points.isEmpty) return [];
  final base = points.first.value;
  if (base == 0) {
    return points.map((p) => PricePoint(date: p.date, value: 100)).toList();
  }
  return points
      .map((p) => PricePoint(date: p.date, value: p.value / base * 100))
      .toList();
}
