// =============================================================================
// EcoPulse · test/chart_normalize_test.dart
// Автор: Цымбал Е. В.
// Дата: 23.06.2026
// Unit/widget тест: chart_normalize_test.
// =============================================================================

import 'package:ecopulse/core/utils/chart_normalize.dart';
import 'package:ecopulse/data/models/price_point.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
void main() {
  test('normalizeSeriesToIndex scales from base 100', () {
    final points = [
      PricePoint(date: DateTime(2024), value: 80),
      PricePoint(date: DateTime(2024, 1, 2), value: 84),
    ];

    final normalized = normalizeSeriesToIndex(points);

    expect(normalized.first.value, 100);
    expect(normalized.last.value, closeTo(105, 0.01));
  });

  test('alignPriceSeries trims to shortest history', () {
    final aligned = alignPriceSeries([
      [
        PricePoint(date: DateTime(2024), value: 1),
        PricePoint(date: DateTime(2024, 1, 2), value: 2),
        PricePoint(date: DateTime(2024, 1, 3), value: 3),
      ],
      [
        PricePoint(date: DateTime(2024, 1, 2), value: 10),
        PricePoint(date: DateTime(2024, 1, 3), value: 11),
      ],
    ]);

    expect(aligned.length, 2);
    expect(aligned[0].length, 2);
    expect(aligned[0].last.value, 3);
  });
}
