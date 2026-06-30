import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/portfolio_income_calendar.dart';
import 'package:ecopulse/core/utils/portfolio_calendar_import.dart';
import 'package:ecopulse/core/utils/user_calendar_plan.dart';
import 'package:ecopulse/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('draftFromPortfolioPlanItem fills title amount and date', () {
    final item = UserCalendarPlanItem(
      date: DateTime(2026, 4, 10),
      title: 'SU26238',
      amount: 500,
      currency: 'RUB',
      source: UserCalendarEventSource.portfolioAuto,
      isEstimate: false,
      portfolioType: PortfolioIncomeEventType.bondCoupon,
      symbol: 'SU26238',
    );

    final draft = draftFromPortfolioPlanItem(l10n, item);
    expect(draft.title, contains('SU26238'));
    expect(draft.amount, 500);
    expect(draft.date, item.date);
  });

  test('draftFromPortfolioIncomeEvent marks estimate note', () {
    final event = PortfolioIncomeEvent(
      date: DateTime(2026, 5, 1),
      type: PortfolioIncomeEventType.bondCouponEstimate,
      symbol: 'SU26238',
      assetKey: 'bondRu:SU26238',
      amountRub: 120,
      quantity: 2,
      isEstimate: true,
    );

    final draft = draftFromPortfolioIncomeEvent(l10n, event);
    expect(draft.note, isNotNull);
    expect(draft.title, contains('SU26238'));
  });
}
