// =============================================================================
// EcoPulse · lib/core/utils/scenario_math.dart
// Автор: Цымбал Е. В.
// Дата: 10.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: scenario_math.
// =============================================================================

/// Функция [annuityPayment] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
double annuityPayment(double principal, double annualRatePercent, int months) {
  if (months <= 0 || principal <= 0) return 0;
  final r = annualRatePercent / 100 / 12;
  if (r == 0) return principal / months;
  final pow = _pow1Plus(r, months);
  return principal * r * pow / (pow - 1);
}

/// Функция [depositFuture] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
double depositFuture({
  required double principal,
  required double annualRatePercent,
  required int months,
  required bool capitalize,
}) {
  if (months <= 0) return principal;
  final r = annualRatePercent / 100 / 12;
  if (capitalize) {
    return principal * _pow1Plus(r, months);
  }
  return principal + principal * r * months;
}

/// Приватная функция [_pow1Plus].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
double _pow1Plus(double r, int n) {
  var result = 1.0;
  for (var i = 0; i < n; i++) {
    result *= 1 + r;
  }
  return result;
}
