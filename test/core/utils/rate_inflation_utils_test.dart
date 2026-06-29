// =============================================================================
// EcoPulse · test/rate_inflation_utils_test.dart
// Автор: Цымбал Е. В.
// Дата: 27.06.2026
// Unit/widget тест: rate_inflation_utils_test.
// =============================================================================

import 'package:ecopulse/core/utils/rate_inflation_utils.dart';
import 'package:ecopulse/data/models/inflation_point.dart';
import 'package:ecopulse/data/models/key_rate_point.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
void main() {
  test('buildRateVsInflationSeries aligns by year', () {
    final inflation = InflationPoint(
      countryCode: 'RU',
      countryName: 'Russia',
      year: 2023,
      value: 7.4,
      history: const [
        YearValue(year: 2021, value: 6.7),
        YearValue(year: 2022, value: 13.8),
        YearValue(year: 2023, value: 7.4),
      ],
    );

    final keyRate = [
      KeyRatePoint(date: DateTime(2021, 6), rate: 5.5),
      KeyRatePoint(date: DateTime(2021, 12), rate: 8.5),
      KeyRatePoint(date: DateTime(2022, 6), rate: 11.0),
      KeyRatePoint(date: DateTime(2023, 1), rate: 7.5),
    ];

    final result = buildRateVsInflationSeries(
      keyRateHistory: keyRate,
      ruInflation: inflation,
      keyRateLabel: 'Key rate',
      inflationLabel: 'CPI',
    );

    expect(result, isNotNull);
    expect(result!.keyRatePoints.length, 3);
    expect(result.inflationPoints.length, 3);
    expect(result.keyRatePoints.first.value, closeTo(7.0, 0.01));
    expect(result.inflationPoints.last.value, 7.4);
  });
}
