// =============================================================================
// EcoPulse · lib/core/utils/chart_events.dart
// Автор: Цымбал Е. В.
// Дата: 07.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: chart_events.
// =============================================================================

/// Класс [ChartEventMarker].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
class ChartEventMarker {
/// Создаёт [ChartEventMarker].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  const ChartEventMarker({
    required this.index,
    required this.label,
    required this.date,
  });

/// Поле [index] класса [ChartEventMarker].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  final int index;
/// Поле [label] класса [ChartEventMarker].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final String label;
/// Поле [date] класса [ChartEventMarker].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final DateTime date;
}

/// Индексы точек, где значение изменилось (для вертикальных маркеров).
List<ChartEventMarker> rateChangeEvents({
  required List<DateTime> dates,
  required List<double> values,
  required String Function(double value) labelFor,
}) {
  if (dates.length != values.length || values.length < 2) return [];

  final events = <ChartEventMarker>[];
  for (var i = 1; i < values.length; i++) {
    if (values[i] != values[i - 1]) {
      events.add(
        ChartEventMarker(
          index: i,
          label: labelFor(values[i]),
          date: dates[i],
        ),
      );
    }
  }
  return events;
}

/// Функция [keyRateChangeEvents] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
List<ChartEventMarker> keyRateChangeEvents({
  required List<DateTime> dates,
  required List<double> rates,
}) {
  return rateChangeEvents(
    dates: dates,
    values: rates,
    labelFor: (v) => '${v.toStringAsFixed(2)}%',
  );
}
