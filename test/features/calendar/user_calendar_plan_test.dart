import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/portfolio_income_calendar.dart';
import 'package:ecopulse/core/utils/user_calendar_plan.dart';
import 'package:ecopulse/data/models/user_calendar_event.dart';

void main() {
  group('UserCalendarEvent', () {
    test('roundtrips json', () {
      final event = UserCalendarEvent(
        id: '1',
        title: 'Coupon SU26238',
        date: DateTime(2026, 3, 29),
        amount: 1000,
        currency: 'RUB',
        note: 'test',
        attachmentName: 'doc.pdf',
        attachmentMime: 'application/pdf',
        createdAt: DateTime(2026, 1, 1),
      );
      final restored =
          UserCalendarEvent.fromJson(event.toJson());
      expect(restored.title, event.title);
      expect(restored.amount, 1000);
      expect(restored.currency, 'RUB');
      expect(restored.hasAttachment, isTrue);
    });
  });

  group('buildUserCalendarPlan', () {
    final manual = [
      UserCalendarEvent(
        id: 'm1',
        title: 'Salary',
        date: DateTime(2026, 3, 15),
        amount: 1000,
        currency: 'USD',
        createdAt: DateTime.now(),
      ),
      UserCalendarEvent(
        id: 'm2',
        title: 'Coupon',
        date: DateTime(2026, 3, 29),
        amount: 1000,
        currency: 'RUB',
        createdAt: DateTime.now(),
      ),
    ];

    final portfolioPlan = PortfolioIncomePlan(
      events: [
        PortfolioIncomeEvent(
          date: DateTime(2026, 4, 10),
          type: PortfolioIncomeEventType.bondCoupon,
          symbol: 'SU26238',
          assetKey: 'bondRu:SU26238',
          amountRub: 500,
          quantity: 10,
          isEstimate: false,
        ),
      ],
      totalNext30Days: 500,
      totalNext90Days: 500,
      byMonth: const {},
    );

    test('merges manual and portfolio events', () {
      final plan = buildUserCalendarPlan(
        manualEvents: manual,
        portfolioPlan: portfolioPlan,
        showPortfolioEvents: true,
        asOf: DateTime(2026, 3, 1),
        horizonDays: 365,
      );
      expect(plan.events.length, 3);
      expect(
        plan.events.where((e) => e.source == UserCalendarEventSource.manual),
        hasLength(2),
      );
      expect(
        plan.events.where((e) => e.source == UserCalendarEventSource.portfolioAuto),
        hasLength(1),
      );
    });

    test('totalsByCurrency keeps currencies separate', () {
      final plan = buildUserCalendarPlan(
        manualEvents: manual,
        portfolioPlan: null,
        showPortfolioEvents: false,
        asOf: DateTime(2026, 3, 1),
        horizonDays: 365,
      );
      expect(plan.totalsByCurrency['RUB'], 1000);
      expect(plan.totalsByCurrency['USD'], 1000);
      expect(plan.totalsByCurrency.length, 2);
    });

    test('hides portfolio when disabled', () {
      final plan = buildUserCalendarPlan(
        manualEvents: manual,
        portfolioPlan: portfolioPlan,
        showPortfolioEvents: false,
        asOf: DateTime(2026, 3, 1),
        horizonDays: 365,
      );
      expect(
        plan.events.where((e) => e.source == UserCalendarEventSource.portfolioAuto),
        isEmpty,
      );
    });

    test('expands monthly recurrence within horizon', () {
      final rent = UserCalendarEvent(
        id: 'rent',
        title: 'Rent',
        date: DateTime(2026, 1, 15),
        amount: 30000,
        currency: 'RUB',
        recurrence: UserCalendarRecurrence.monthly,
        createdAt: DateTime.now(),
      );
      final plan = buildUserCalendarPlan(
        manualEvents: [rent],
        portfolioPlan: null,
        showPortfolioEvents: false,
        asOf: DateTime(2026, 3, 1),
        horizonDays: 90,
      );
      expect(plan.events.length, greaterThan(1));
      expect(plan.events.every((e) => e.title == 'Rent'), isTrue);
    });

    test('filters by horizon', () {
      final far = UserCalendarEvent(
        id: 'far',
        title: 'Far',
        date: DateTime(2027, 6, 1),
        amount: 100,
        currency: 'RUB',
        createdAt: DateTime.now(),
      );
      final plan = buildUserCalendarPlan(
        manualEvents: [...manual, far],
        portfolioPlan: null,
        showPortfolioEvents: false,
        asOf: DateTime(2026, 3, 1),
        horizonDays: 90,
      );
      expect(plan.events.any((e) => e.title == 'Far'), isFalse);
    });
  });
}
