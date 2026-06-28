// =============================================================================
// EcoPulse · test/inflation_math_test.dart
// Автор: Цымбал Е. В.
// Дата: 25.06.2026
// Unit/widget тест: inflation_math_test.
// =============================================================================

import 'package:ecopulse/core/utils/inflation_math.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 26.06.2026
void main() {
  group('purchasingPowerToday', () {
    test('accumulates inflation from base year', () {
      final result = purchasingPowerToday(
        baseAmount: 1000,
        fromYear: 2020,
        history: [
          (year: 2021, value: 10.0),
          (year: 2022, value: 5.0),
        ],
      );
      expect(result, closeTo(1155, 1));
    });

    test('returns null for empty history', () {
      expect(
        purchasingPowerToday(
          baseAmount: 1000,
          fromYear: 2020,
          history: [],
        ),
        isNull,
      );
    });
  });
}
