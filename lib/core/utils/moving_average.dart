import 'dart:ui';

/// Простая скользящая средняя (SMA) по значениям close/price.
List<double?> simpleMovingAverage(List<double> values, int period) {
  if (period <= 0 || values.isEmpty) return const [];
  final result = List<double?>.filled(values.length, null);
  if (values.length < period) return result;

  var sum = 0.0;
  for (var i = 0; i < period; i++) {
    sum += values[i];
  }
  result[period - 1] = sum / period;

  for (var i = period; i < values.length; i++) {
    sum += values[i] - values[i - period];
    result[i] = sum / period;
  }
  return result;
}

const chartMaPeriods = [7, 25, 99];

Color maColorForPeriod(int period, {required Color fallback}) {
  return switch (period) {
    7 => const Color(0xFFFFB020),
    25 => const Color(0xFF5B8DEF),
    99 => const Color(0xFFE879F9),
    _ => fallback,
  };
}
