// =============================================================================
// EcoPulse · lib/core/utils/inflation_math.dart
// Автор: Цымбал Е. В.
// Дата: 08.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: inflation_math.
// =============================================================================

/// Расчёт покупательной способности: сколько стоят [baseAmount] сегодня
/// с учётом накопленной инфляции с [fromYear].
double? purchasingPowerToday({
  required double baseAmount,
  required int fromYear,
  required List<({int year, double value})> history,
}) {
  if (history.isEmpty) return null;

  final latestYear = history.map((e) => e.year).reduce((a, b) => a > b ? a : b);
  if (fromYear >= latestYear) return baseAmount;

  var factor = 1.0;
  for (final entry in history) {
    if (entry.year > fromYear && entry.year <= latestYear) {
      factor *= 1 + entry.value / 100;
    }
  }
  return baseAmount * factor;
}

/// Функция [formatPurchasingPower] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
String formatPurchasingPower({
  required double amount,
  required int fromYear,
  required String currencySymbol,
}) {
  return '$currencySymbol${amount.toStringAsFixed(0)} в $fromYear';
}
