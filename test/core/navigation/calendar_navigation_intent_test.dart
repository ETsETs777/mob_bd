import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/navigation/calendar_navigation_intent.dart';
import 'package:ecopulse/core/utils/calendar_plan_focus.dart';
import 'package:ecopulse/core/utils/portfolio_income_calendar.dart';
import 'package:ecopulse/core/utils/user_calendar_plan.dart';

void main() {
  test('openManualEvent stores id until consumed once', () {
    CalendarNavigationIntent.openManualEvent('evt-1');
    expect(CalendarNavigationIntent.consumeFocusPlanItemKey(), 'manual:evt-1');
    expect(CalendarNavigationIntent.consumeFocusPlanItemKey(), isNull);
  });

  test('portfolio focus key resolves plan item', () {
    final item = UserCalendarPlanItem(
      date: DateTime(2026, 7, 1),
      title: 'SBER',
      currency: 'RUB',
      source: UserCalendarEventSource.portfolioAuto,
      symbol: 'SBER',
      portfolioType: PortfolioIncomeEventType.bondCoupon,
    );
    final key = calendarPlanItemFocusKey(item);
    CalendarNavigationIntent.openPlanItem(item);

    final plan = UserCalendarPlan(
      events: [item],
      totalsByCurrency: const {},
      byMonth: const {},
    );

    expect(CalendarNavigationIntent.consumeFocusPlanItemKey(), key);
    expect(findPlanItemByFocusKey(plan, key), item);
  });
}
