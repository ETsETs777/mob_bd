// =============================================================================
// EcoPulse · lib/core/utils/macro_week.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// План «макро-недели»: события по дням на 7 дней вперёд.
// =============================================================================

import '../../data/models/macro_event.dart';
import '../../data/models/key_rate_point.dart';

/// Тип события на экране макро-недели.
enum MacroWeekEventKind { macro, keyRate }

/// Событие в дневной секции.
class MacroWeekEventItem {
  const MacroWeekEventItem({
    required this.kind,
    required this.title,
    this.subtitle,
    this.impact,
  });

  final MacroWeekEventKind kind;
  final String title;
  final String? subtitle;
  final String? impact;
}

/// Секция одного дня недели.
class MacroWeekDaySection {
  const MacroWeekDaySection({
    required this.date,
    required this.isToday,
    required this.events,
  });

  final DateTime date;
  final bool isToday;
  final List<MacroWeekEventItem> events;

  bool get hasEvents => events.isNotEmpty;
}

/// Сводка макро-недели.
class MacroWeekPlan {
  const MacroWeekPlan({
    required this.weekStart,
    required this.weekEnd,
    required this.days,
    required this.totalMacroEvents,
    this.keyRatePercent,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final List<MacroWeekDaySection> days;
  final int totalMacroEvents;
  final double? keyRatePercent;

  int get daysWithEvents => days.where((d) => d.hasEvents).length;
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Строит план на [horizonDays] дней от [asOf].
MacroWeekPlan buildMacroWeekPlan({
  List<MacroEvent>? macroEvents,
  KeyRateSnapshot? keyRate,
  DateTime? asOf,
  int horizonDays = 7,
}) {
  final now = _dateOnly(asOf ?? DateTime.now());
  final end = now.add(Duration(days: horizonDays - 1));

  final eventsByDay = <DateTime, List<MacroWeekEventItem>>{};

  for (var i = 0; i < horizonDays; i++) {
    eventsByDay[now.add(Duration(days: i))] = [];
  }

  if (macroEvents != null) {
    for (final ev in macroEvents) {
      final day = _dateOnly(ev.date);
      if (day.isBefore(now) || day.isAfter(end)) continue;
      eventsByDay.putIfAbsent(day, () => []);
      eventsByDay[day]!.add(
        MacroWeekEventItem(
          kind: MacroWeekEventKind.macro,
          title: ev.event,
          subtitle: ev.country,
          impact: ev.impact,
        ),
      );
    }
  }

  if (keyRate != null) {
    eventsByDay[now]?.insert(
      0,
      MacroWeekEventItem(
        kind: MacroWeekEventKind.keyRate,
        title: 'CBR_KEY_RATE',
        subtitle: keyRate.current.toStringAsFixed(2),
      ),
    );
  }

  var totalMacro = 0;
  final days = <MacroWeekDaySection>[];

  for (var i = 0; i < horizonDays; i++) {
    final day = now.add(Duration(days: i));
    final items = eventsByDay[day] ?? [];
    totalMacro += items.where((e) => e.kind == MacroWeekEventKind.macro).length;
    days.add(
      MacroWeekDaySection(
        date: day,
        isToday: _isSameDay(day, now),
        events: items,
      ),
    );
  }

  return MacroWeekPlan(
    weekStart: now,
    weekEnd: end,
    days: days,
    totalMacroEvents: totalMacro,
    keyRatePercent: keyRate?.current,
  );
}
