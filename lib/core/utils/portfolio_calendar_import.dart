import '../../core/utils/bond_analytics.dart';
import '../../core/utils/portfolio_income_calendar.dart';
import '../../core/utils/user_calendar_plan.dart';
import '../../data/models/user_calendar_event.dart';
import '../../l10n/app_localizations.dart';

/// Параметры ручного события календаря из поступления портфеля.
class PortfolioCalendarImportDraft {
  const PortfolioCalendarImportDraft({
    required this.title,
    required this.date,
    required this.amount,
    this.currency = 'RUB',
    this.note,
  });

  final String title;
  final DateTime date;
  final double amount;
  final String currency;
  final String? note;
}

String _portfolioItemTitle(AppLocalizations l10n, UserCalendarPlanItem item) {
  if (item.source == UserCalendarEventSource.manual) {
    return item.title;
  }
  final typeLabel = switch (item.portfolioType) {
    PortfolioIncomeEventType.bondCoupon => l10n.portfolioIncomeCoupon,
    PortfolioIncomeEventType.bondCouponEstimate =>
      l10n.portfolioIncomeCouponEstimate,
    PortfolioIncomeEventType.bondMaturity => l10n.portfolioIncomeMaturity,
    PortfolioIncomeEventType.stockDividendEstimate =>
      l10n.portfolioIncomeDividendEstimate,
    null => '',
  };
  final symbol = item.symbol ?? item.title;
  return typeLabel.isEmpty ? symbol : '$symbol · $typeLabel';
}

PortfolioCalendarImportDraft draftFromPortfolioPlanItem(
  AppLocalizations l10n,
  UserCalendarPlanItem item,
) {
  return PortfolioCalendarImportDraft(
    title: _portfolioItemTitle(l10n, item),
    date: item.date,
    amount: item.amount ?? 0,
    currency: item.currency,
    note: item.isEstimate ? l10n.userCalendarImportPortfolioEstimateNote : null,
  );
}

PortfolioCalendarImportDraft draftFromPortfolioIncomeEvent(
  AppLocalizations l10n,
  PortfolioIncomeEvent event,
) {
  final typeLabel = switch (event.type) {
    PortfolioIncomeEventType.bondCoupon => l10n.portfolioIncomeCoupon,
    PortfolioIncomeEventType.bondCouponEstimate =>
      l10n.portfolioIncomeCouponEstimate,
    PortfolioIncomeEventType.bondMaturity => l10n.portfolioIncomeMaturity,
    PortfolioIncomeEventType.stockDividendEstimate =>
      l10n.portfolioIncomeDividendEstimate,
  };
  return PortfolioCalendarImportDraft(
    title: '${event.symbol} · $typeLabel',
    date: event.date,
    amount: event.amountRub,
    currency: 'RUB',
    note: event.isEstimate ? l10n.userCalendarImportPortfolioEstimateNote : null,
  );
}

PortfolioCalendarImportDraft draftFromBondCalendarEvent(
  AppLocalizations l10n,
  BondCalendarEvent event,
) {
  final symbol = event.bond.symbol;
  final typeLabel = switch (event.type) {
    BondCalendarEventType.maturity => l10n.bondEventMaturity,
    BondCalendarEventType.coupon => l10n.portfolioIncomeCoupon,
    BondCalendarEventType.couponEstimate => l10n.portfolioIncomeCouponEstimate,
  };
  final amount = event.bond.couponValueRub;
  final isEstimate = event.type == BondCalendarEventType.couponEstimate;
  return PortfolioCalendarImportDraft(
    title: '$symbol · $typeLabel',
    date: event.date,
    amount: amount ?? 0,
    currency: 'RUB',
    note: isEstimate ? l10n.userCalendarImportPortfolioEstimateNote : null,
  );
}

bool _manualMatchesDraft(UserCalendarEvent manual, PortfolioCalendarImportDraft draft) {
  final sameDay = manual.date.year == draft.date.year &&
      manual.date.month == draft.date.month &&
      manual.date.day == draft.date.day;
  return sameDay && manual.title.trim() == draft.title.trim();
}

/// Портфельные события плана, ещё не импортированные как ручные.
List<UserCalendarPlanItem> portfolioItemsNotYetManual(
  UserCalendarPlan plan,
  List<UserCalendarEvent> manual,
  AppLocalizations l10n,
) {
  final items = <UserCalendarPlanItem>[];
  for (final item in plan.events) {
    if (item.source != UserCalendarEventSource.portfolioAuto) continue;
    final draft = draftFromPortfolioPlanItem(l10n, item);
    final exists = manual.any((m) => _manualMatchesDraft(m, draft));
    if (!exists) items.add(item);
  }
  return items;
}
