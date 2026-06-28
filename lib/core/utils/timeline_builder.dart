// =============================================================================
// EcoPulse · lib/core/utils/timeline_builder.dart
// Автор: Цымбал Е. В.
// Дата: 11.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: timeline_builder.
// =============================================================================

import '../../data/models/macro_event.dart';
import '../../data/models/key_rate_point.dart';
import '../utils/chart_events.dart';

/// Класс [TimelineItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
class TimelineItem {
/// Создаёт [TimelineItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  const TimelineItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.kind,
  });

/// Поле [date] класса [TimelineItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  final DateTime date;
/// Поле [title] класса [TimelineItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  final String title;
/// Поле [subtitle] класса [TimelineItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final String subtitle;
/// Поле [kind] класса [TimelineItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  final TimelineKind kind;
}

/// Значение enum [market].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
/// Значение enum [macro].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
/// Значение enum [keyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
/// Enum [TimelineKind] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
/// Значение enum [market].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
/// Значение enum [macro].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
/// Значение enum [keyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
enum TimelineKind { keyRate, macro, market }

/// Функция [buildTimeline] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
List<TimelineItem> buildTimeline({
  KeyRateSnapshot? keyRate,
  List<MacroEvent>? macroEvents,
  int macroLimit = 10,
}) {
  final items = <TimelineItem>[];

  if (keyRate != null && keyRate.history.length >= 2) {
    final events = keyRateChangeEvents(
      dates: keyRate.history.map((p) => p.date).toList(),
      rates: keyRate.history.map((p) => p.rate).toList(),
    );
    for (final e in events.reversed.take(8)) {
      items.add(TimelineItem(
        date: e.date,
        title: 'Ставка ЦБ → ${e.label}',
        subtitle: _formatDate(e.date),
        kind: TimelineKind.keyRate,
      ));
    }
  }

  if (macroEvents != null) {
    final now = DateTime.now();
    for (final ev in macroEvents.take(macroLimit)) {
      if (ev.date.isBefore(now.subtract(const Duration(days: 1)))) continue;
      items.add(TimelineItem(
        date: ev.date,
        title: ev.event,
        subtitle: '${ev.country}${ev.time != null ? ' · ${ev.time}' : ''}',
        kind: TimelineKind.macro,
      ));
    }
  }

  items.sort((a, b) => b.date.compareTo(a.date));
  return items.take(15).toList();
}

/// Приватная функция [_formatDate].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
String _formatDate(DateTime d) {
  return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
