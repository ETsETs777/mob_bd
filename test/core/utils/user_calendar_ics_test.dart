import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/user_calendar_ics.dart';
import 'package:ecopulse/data/models/user_calendar_event.dart';

void main() {
  test('empty manual events produce valid calendar shell', () {
    final ics = buildUserCalendarIcs([]);
    expect(ics, contains('BEGIN:VCALENDAR'));
    expect(ics, contains('END:VCALENDAR'));
    expect(ics, isNot(contains('BEGIN:VEVENT')));
  });

  test('includes event fields and escapes commas', () {
    final ics = buildUserCalendarIcs([
      UserCalendarEvent(
        id: 'e1',
        title: 'Coupon, SU26238',
        date: DateTime(2026, 6, 29),
        amount: 1000,
        currency: 'RUB',
        note: 'Line one\nLine two',
        createdAt: DateTime(2026, 1, 1),
        recurrence: UserCalendarRecurrence.monthly,
        reminderDaysBefore: const [1, 3],
      ),
    ]);

    expect(ics, contains('SUMMARY:Coupon\\, SU26238'));
    expect(ics, contains('DTSTART;VALUE=DATE:20260629'));
    expect(ics, contains('X-ECOPULSE-AMOUNT:1000.00 RUB'));
    expect(ics, contains('RRULE:FREQ=MONTHLY'));
    expect(ics, contains('DESCRIPTION:Line one\\nLine two'));
    expect(ics, contains('BEGIN:VALARM'));
    expect(ics, contains('TRIGGER:-P1D'));
    expect(ics, contains('TRIGGER:-P3D'));
  });
}
