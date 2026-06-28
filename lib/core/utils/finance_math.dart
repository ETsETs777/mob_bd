// =============================================================================
// EcoPulse · lib/core/utils/finance_math.dart
// Автор: Цымбал Е. В.
// Дата: 05.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: finance_math.
// =============================================================================

import 'dart:math' as math;

/// Функция [annuityPayment] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
double annuityPayment(double principal, double annualRate, int months) {
  final monthlyRate = annualRate / 100 / 12;
  if (monthlyRate == 0) return principal / months;
  final factor = math.pow(1 + monthlyRate, months);
  return principal * monthlyRate * factor / (factor - 1);
}

/// Функция [depositTotal] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
double depositTotal({
  required double amount,
  required double annualRate,
  required int months,
  required bool capitalize,
}) {
  final monthlyRate = annualRate / 100 / 12;
  if (capitalize) {
    return amount * math.pow(1 + monthlyRate, months);
  }
  return amount + amount * monthlyRate * months;
}
