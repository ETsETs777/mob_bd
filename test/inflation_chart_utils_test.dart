// =============================================================================
// EcoPulse · test/inflation_chart_utils_test.dart
// Автор: Цымбал Е. В.
// Дата: 25.06.2026
// Unit/widget тест: inflation_chart_utils_test.
// =============================================================================

import 'package:ecopulse/core/utils/inflation_chart_utils.dart';
import 'package:ecopulse/data/models/inflation_point.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 26.06.2026
void main() {
  test('alignInflationByYear keeps common years only', () {
    final aligned = alignInflationByYear([
      [
        const YearValue(year: 2019, value: 3),
        const YearValue(year: 2020, value: 4),
        const YearValue(year: 2021, value: 5),
      ],
      [
        const YearValue(year: 2020, value: 2),
        const YearValue(year: 2021, value: 6),
        const YearValue(year: 2022, value: 7),
      ],
    ]);

    expect(aligned.length, 2);
    expect(aligned[0].map((e) => e.year).toList(), [2020, 2021]);
    expect(aligned[0][1].value, 5);
    expect(aligned[1][1].value, 6);
  });
}
