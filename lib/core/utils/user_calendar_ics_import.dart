/// Черновик события из .ics.
class IcsEventDraft {
  const IcsEventDraft({
    required this.title,
    required this.date,
    this.note,
    this.amount,
    this.currency = 'RUB',
    this.recurrence = IcsRecurrence.none,
    this.reminderDaysBefore = const [],
  });

  final String title;
  final DateTime date;
  final String? note;
  final double? amount;
  final String currency;
  final IcsRecurrence recurrence;
  final List<int> reminderDaysBefore;
}

enum IcsRecurrence { none, monthly, yearly }

/// Минимальный парсер VEVENT из текста .ics.
List<IcsEventDraft> parseIcsText(String raw) {
  final lines = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');
  final events = <IcsEventDraft>[];
  String? title;
  DateTime? date;
  final noteParts = <String>[];
  double? amount;
  var currency = 'RUB';
  var recurrence = IcsRecurrence.none;
  final reminders = <int>{};
  var inEvent = false;
  var inAlarm = false;

  void flush() {
    final eventTitle = title;
    final eventDate = date;
    if (!inEvent || eventTitle == null || eventDate == null) return;
    events.add(
      IcsEventDraft(
        title: eventTitle,
        date: eventDate,
        note: noteParts.isEmpty ? null : noteParts.join('\n'),
        amount: amount,
        currency: currency,
        recurrence: recurrence,
        reminderDaysBefore: reminders.toList()..sort(),
      ),
    );
  }

  for (var line in lines) {
    while (line.startsWith(' ') && line.length > 1) {
      line = line.substring(1);
    }
    if (line == 'BEGIN:VEVENT') {
      inEvent = true;
      inAlarm = false;
      title = null;
      date = null;
      noteParts.clear();
      amount = null;
      currency = 'RUB';
      recurrence = IcsRecurrence.none;
      reminders.clear();
      continue;
    }
    if (line == 'END:VEVENT') {
      flush();
      inEvent = false;
      inAlarm = false;
      continue;
    }
    if (!inEvent) continue;

    if (line == 'BEGIN:VALARM') {
      inAlarm = true;
      continue;
    }
    if (line == 'END:VALARM') {
      inAlarm = false;
      continue;
    }

    if (inAlarm && line.startsWith('TRIGGER')) {
      final days = _parseTriggerDays(line);
      if (days != null) reminders.add(days);
      continue;
    }

    if (line.startsWith('SUMMARY:')) {
      title = _unescape(line.substring('SUMMARY:'.length));
    } else if (line.startsWith('DESCRIPTION:')) {
      noteParts.add(_unescape(line.substring('DESCRIPTION:'.length)));
    } else if (line.startsWith('DTSTART')) {
      final value = line.split(':').last;
      date = _parseIcsDate(value);
    } else if (line.startsWith('X-ECOPULSE-AMOUNT:')) {
      final rawAmount = line.substring('X-ECOPULSE-AMOUNT:'.length).trim();
      final parts = rawAmount.split(' ');
      amount = double.tryParse(parts.first);
      if (parts.length > 1) currency = parts[1].toUpperCase();
    } else if (line.startsWith('RRULE:')) {
      recurrence = _parseRrule(line.substring('RRULE:'.length));
    }
  }

  return events;
}

IcsRecurrence _parseRrule(String raw) {
  final upper = raw.toUpperCase();
  if (upper.contains('FREQ=MONTHLY')) return IcsRecurrence.monthly;
  if (upper.contains('FREQ=YEARLY')) return IcsRecurrence.yearly;
  return IcsRecurrence.none;
}

int? _parseTriggerDays(String line) {
  final value = line.contains(':') ? line.split(':').last : line;
  final trimmed = value.trim();
  if (trimmed.startsWith('-P') && trimmed.endsWith('D')) {
    final days = int.tryParse(trimmed.substring(2, trimmed.length - 1));
    return days;
  }
  return null;
}

DateTime? _parseIcsDate(String value) {
  if (value.length >= 8) {
    final y = int.tryParse(value.substring(0, 4));
    final m = int.tryParse(value.substring(4, 6));
    final d = int.tryParse(value.substring(6, 8));
    if (y != null && m != null && d != null) {
      return DateTime(y, m, d);
    }
  }
  return DateTime.tryParse(value)?.toLocal();
}

String _unescape(String value) =>
    value.replaceAll('\\n', '\n').replaceAll('\\,', ',').replaceAll('\\\\', '\\');
