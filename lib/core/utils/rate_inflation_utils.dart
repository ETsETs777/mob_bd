// =============================================================================
// EcoPulse · lib/core/utils/rate_inflation_utils.dart
// Автор: Цымбал Е. В.
// Дата: 10.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: rate_inflation_utils.
// =============================================================================

import '../../data/models/inflation_point.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/price_point.dart';

/// Класс [RateInflationSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
class RateInflationSeries {
/// Создаёт [RateInflationSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  const RateInflationSeries({
    required this.keyRateLabel,
    required this.inflationLabel,
    required this.keyRatePoints,
    required this.inflationPoints,
  });

/// Поле [keyRateLabel] класса [RateInflationSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  final String keyRateLabel;
/// Поле [inflationLabel] класса [RateInflationSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  final String inflationLabel;
/// Поле [keyRatePoints] класса [RateInflationSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  final List<PricePoint> keyRatePoints;
/// Поле [inflationPoints] класса [RateInflationSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final List<PricePoint> inflationPoints;
}

/// Средняя ключевая ставка ЦБ и CPI РФ по общим годам.
RateInflationSeries? buildRateVsInflationSeries({
  required List<KeyRatePoint> keyRateHistory,
  required InflationPoint? ruInflation,
  required String keyRateLabel,
  required String inflationLabel,
}) {
  if (ruInflation == null || keyRateHistory.isEmpty) return null;

  final rateByYear = <int, List<double>>{};
  for (final point in keyRateHistory) {
    rateByYear.putIfAbsent(point.date.year, () => []).add(point.rate);
  }

  final inflationByYear = {
    for (final entry in ruInflation.history) entry.year: entry.value,
  };

  final years = rateByYear.keys
      .toSet()
      .intersection(inflationByYear.keys.toSet())
      .toList()
    ..sort();
  if (years.length < 2) return null;

  final keyRatePoints = years
      .map(
        (year) => PricePoint(
          date: DateTime(year),
          value: rateByYear[year]!.reduce((a, b) => a + b) /
              rateByYear[year]!.length,
        ),
      )
      .toList();

  final inflationPoints = years
      .map(
        (year) => PricePoint(
          date: DateTime(year),
          value: inflationByYear[year]!,
        ),
      )
      .toList();

  return RateInflationSeries(
    keyRateLabel: keyRateLabel,
    inflationLabel: inflationLabel,
    keyRatePoints: keyRatePoints,
    inflationPoints: inflationPoints,
  );
}
