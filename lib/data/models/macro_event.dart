// =============================================================================
// EcoPulse · lib/data/models/macro_event.dart
// Автор: Цымбал Е. В.
// Дата: 03.05.2026
// Модели данных (DTO, immutable классы). Файл: macro_event.
// =============================================================================

/// Класс [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class MacroEvent {
/// Создаёт [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  const MacroEvent({
    required this.event,
    required this.country,
    required this.date,
    this.time,
    this.impact,
    this.estimate,
    this.actual,
    this.previous,
    this.unit,
  });

/// Поле [event] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String event;
/// Поле [country] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String country;
/// Поле [date] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final DateTime date;
/// Поле [time] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String? time;
/// Поле [impact] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String? impact;
/// Поле [estimate] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String? estimate;
/// Поле [actual] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String? actual;
/// Поле [previous] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String? previous;
/// Поле [unit] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String? unit;

/// Метод [toJson] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  Map<String, dynamic> toJson() => {
        'event': event,
        'country': country,
        'date': date.toIso8601String(),
        'time': time,
        'impact': impact,
        'estimate': estimate,
        'actual': actual,
        'previous': previous,
        'unit': unit,
      };

/// Создаёт [MacroEvent] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  factory MacroEvent.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String? ?? '';
    final parsedDate = DateTime.tryParse(dateStr) ??
        DateTime.tryParse('${dateStr}T00:00:00') ??
        DateTime.now();

    return MacroEvent(
      event: json['event'] as String? ?? '',
      country: json['country'] as String? ?? '',
      date: parsedDate,
      time: json['time'] as String?,
      impact: json['impact'] as String?,
      estimate: _stringOrNum(json['estimate']),
      actual: _stringOrNum(json['actual']),
      previous: _stringOrNum(json['prev'] ?? json['previous']),
      unit: json['unit'] as String?,
    );
  }

/// Приватный метод [_stringOrNum] класса [MacroEvent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  static String? _stringOrNum(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}
