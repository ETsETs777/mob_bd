import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/user_calendar_ics_import.dart';

void main() {
  test('parses single VEVENT', () {
    const raw = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
SUMMARY:Coupon payment
DTSTART;VALUE=DATE:20260629
DESCRIPTION:Line one\\nLine two
X-ECOPULSE-AMOUNT:1500.00 RUB
RRULE:FREQ=MONTHLY
BEGIN:VALARM
TRIGGER:-P3D
END:VALARM
END:VEVENT
END:VCALENDAR
''';

    final events = parseIcsText(raw);
    expect(events, hasLength(1));
    expect(events.first.title, 'Coupon payment');
    expect(events.first.date, DateTime(2026, 6, 29));
    expect(events.first.note, 'Line one\nLine two');
    expect(events.first.amount, 1500);
    expect(events.first.currency, 'RUB');
    expect(events.first.recurrence, IcsRecurrence.monthly);
    expect(events.first.reminderDaysBefore, [3]);
  });

  test('returns empty for invalid text', () {
    expect(parseIcsText('not a calendar'), isEmpty);
  });
}
