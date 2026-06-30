import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/user_calendar_plan.dart';
import 'package:ecopulse/features/calendar/user_calendar_month_grid.dart';

void main() {
  test('eventDatesFromPlan normalizes to date-only', () {
    final plan = UserCalendarPlan(
      events: [
        UserCalendarPlanItem(
          date: DateTime(2026, 6, 15, 14, 30),
          title: 'Coupon',
          currency: 'RUB',
          source: UserCalendarEventSource.manual,
        ),
      ],
      totalsByCurrency: {},
      byMonth: {},
    );

    final dates = eventDatesFromPlan(plan);
    expect(dates, contains(DateTime(2026, 6, 15)));
    expect(dates.length, 1);
  });
}
