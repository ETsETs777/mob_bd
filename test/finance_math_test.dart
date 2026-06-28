// =============================================================================
// EcoPulse · test/finance_math_test.dart
// Автор: Цымбал Е. В.
// Дата: 25.06.2026
// Unit/widget тест: finance_math_test.
// =============================================================================

import 'package:ecopulse/core/utils/finance_math.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 26.06.2026
void main() {
  test('annuityPayment increases with rate', () {
    final low = annuityPayment(1_000_000, 12, 240);
    final high = annuityPayment(1_000_000, 18, 240);
    expect(high, greaterThan(low));
  });

  test('depositTotal capitalize beats simple interest', () {
    final cap = depositTotal(
      amount: 100000,
      annualRate: 16,
      months: 12,
      capitalize: true,
    );
    final simple = depositTotal(
      amount: 100000,
      annualRate: 16,
      months: 12,
      capitalize: false,
    );
    expect(cap, greaterThan(simple));
  });
}
