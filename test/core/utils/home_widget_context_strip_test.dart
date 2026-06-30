import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/home_widget_context_strip.dart';
import 'package:ecopulse/core/utils/user_calendar_plan.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

void main() {
  test('buildHomeWidgetContextStrip uses portfolio and nearest event', () {
    final strip = buildHomeWidgetContextStrip(
      portfolio: PortfolioSnapshot(
        portfolio: const PaperPortfolio(
          initialCapitalRub: 100000,
          cashRub: 50000,
          positions: [],
        ),
        totalValueRub: 112000,
        investedRub: 0,
        pnlRub: 12000,
        pnlPercent: 12,
        positions: [],
      ),
      calendarPlan: UserCalendarPlan(
        events: [
          UserCalendarPlanItem(
            date: DateTime(2026, 7, 15),
            title: 'Coupon payment',
            currency: 'RUB',
            source: UserCalendarEventSource.manual,
            manualEventId: 'evt-1',
          ),
        ],
        totalsByCurrency: const {},
        byMonth: const {},
      ),
    );

    expect(strip.portfolioValue, contains('112'));
    expect(strip.portfolioChange, contains('+12'));
    expect(strip.calendarTitle, 'Coupon payment');
    expect(strip.calendarEventId, 'evt-1');
  });

  test('buildHomeWidgetContextStrip handles empty calendar', () {
    final strip = buildHomeWidgetContextStrip(
      calendarPlan: const UserCalendarPlan(
        events: [],
        totalsByCurrency: {},
        byMonth: {},
      ),
      emptyCalendarHint: 'No events',
    );

    expect(strip.calendarTitle, HomeWidgetContextStrip.emptyCalendarTitle);
    expect(strip.calendarDate, 'No events');
  });
}
