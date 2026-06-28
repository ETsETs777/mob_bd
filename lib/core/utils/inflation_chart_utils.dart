// =============================================================================
// EcoPulse · lib/core/utils/inflation_chart_utils.dart
// Автор: Цымбал Е. В.
// Дата: 08.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: inflation_chart_utils.
// =============================================================================

import '../../data/models/inflation_point.dart';
import '../../data/models/price_point.dart';

/// Пересечение лет для нескольких рядов инфляции.
List<List<YearValue>> alignInflationByYear(List<List<YearValue>> series) {
  if (series.isEmpty) return [];
  var commonYears = series.first.map((e) => e.year).toSet();
  for (final s in series.skip(1)) {
    commonYears = commonYears.intersection(s.map((e) => e.year).toSet());
  }
  final years = commonYears.toList()..sort();
  if (years.length < 2) return [];

  return series.map((s) {
    final byYear = {for (final y in s) y.year: y};
    return years.map((y) => byYear[y]!).toList();
  }).toList();
}

/// Функция [yearValuesToPricePoints] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
List<PricePoint> yearValuesToPricePoints(List<YearValue> values) {
  return values
      .map((v) => PricePoint(date: DateTime(v.year), value: v.value))
      .toList();
}

/// Функция [buildInflationCompareSeries] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
List<InflationCompareSeries> buildInflationCompareSeries(
  List<InflationPoint> points,
  Set<String> countryCodes,
) {
  final selected =
      points.where((p) => countryCodes.contains(p.countryCode)).toList();
  if (selected.length < 2) return [];

  final aligned = alignInflationByYear(selected.map((p) => p.history).toList());
  if (aligned.length < 2) return [];

  return List.generate(selected.length, (i) {
    return InflationCompareSeries(
      label: selected[i].countryCode,
      points: yearValuesToPricePoints(aligned[i]),
    );
  });
}

/// Класс [InflationCompareSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
class InflationCompareSeries {
/// Создаёт [InflationCompareSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  const InflationCompareSeries({
    required this.label,
    required this.points,
  });

/// Поле [label] класса [InflationCompareSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final String label;
/// Поле [points] класса [InflationCompareSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  final List<PricePoint> points;
}
