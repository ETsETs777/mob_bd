import '../../data/models/user_calendar_event.dart';
import 'user_calendar_plan.dart';

String _icsDate(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return '${d.year.toString().padLeft(4, '0')}'
      '${d.month.toString().padLeft(2, '0')}'
      '${d.day.toString().padLeft(2, '0')}';
}

String _escapeIcs(String value) =>
    value.replaceAll('\\', '\\\\').replaceAll('\n', '\\n').replaceAll(',', '\\,');

void _writeValarms(StringBuffer buffer, List<int> reminderDaysBefore) {
  for (final days in reminderDaysBefore) {
    if (days <= 0) continue;
    buffer
      ..writeln('BEGIN:VALARM')
      ..writeln('ACTION:DISPLAY')
      ..writeln('DESCRIPTION:Reminder')
      ..writeln('TRIGGER:-P${days}D')
      ..writeln('END:VALARM');
  }
}

/// Экспорт ручных событий календаря в формат iCalendar (.ics).
String buildUserCalendarIcs(
  List<UserCalendarEvent> manualEvents, {
  String calendarName = 'EcoPulse Calendar',
}) {
  final buffer = StringBuffer()
    ..writeln('BEGIN:VCALENDAR')
    ..writeln('VERSION:2.0')
    ..writeln('PRODID:-//EcoPulse//User Calendar//EN')
    ..writeln('CALSCALE:GREGORIAN')
    ..writeln('X-WR-CALNAME:${_escapeIcs(calendarName)}');

  for (final event in manualEvents) {
    final uid = 'ecopulse-${event.id}@local';
    buffer
      ..writeln('BEGIN:VEVENT')
      ..writeln('UID:$uid')
      ..writeln('DTSTAMP:${_icsDate(DateTime.now().toUtc())}T000000Z')
      ..writeln('DTSTART;VALUE=DATE:${_icsDate(event.date)}')
      ..writeln('SUMMARY:${_escapeIcs(event.title)}');

    if (event.note != null && event.note!.trim().isNotEmpty) {
      buffer.writeln('DESCRIPTION:${_escapeIcs(event.note!.trim())}');
    }
    if (event.amount != null && event.amount! > 0) {
      buffer.writeln(
        'X-ECOPULSE-AMOUNT:${event.amount!.toStringAsFixed(2)} ${event.currency}',
      );
    }
    if (event.recurrence != UserCalendarRecurrence.none) {
      final freq = event.recurrence == UserCalendarRecurrence.monthly
          ? 'MONTHLY'
          : 'YEARLY';
      buffer.writeln('RRULE:FREQ=$freq');
    }
    _writeValarms(buffer, event.reminderDaysBefore);
    buffer.writeln('END:VEVENT');
  }

  buffer.writeln('END:VCALENDAR');
  return buffer.toString();
}

/// ICS только для ручных событий из плана (без авто-портфеля).
String buildUserCalendarIcsFromPlan(
  UserCalendarPlan plan, {
  String calendarName = 'EcoPulse Calendar',
}) {
  final manual = plan.events
      .where((e) => e.source == UserCalendarEventSource.manual && e.manualEventId != null)
      .map(
        (e) => UserCalendarEvent(
          id: e.manualEventId!,
          title: e.title,
          date: e.date,
          amount: e.amount,
          currency: e.currency,
          note: e.note,
          recurrence: e.recurrence,
          reminderDaysBefore: const [],
          createdAt: DateTime.now(),
        ),
      )
      .toList();
  return buildUserCalendarIcs(manual, calendarName: calendarName);
}
