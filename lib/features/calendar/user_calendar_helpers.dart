import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_income_calendar.dart';
import '../../data/models/user_calendar_event.dart';
import '../../core/utils/user_calendar_plan.dart';
import '../../l10n/app_localizations.dart';

String formatCalendarAmount(double amount, String currency) {
  switch (currency.toUpperCase()) {
    case 'RUB':
      return Formatters.rub(amount);
    case 'USD':
      return Formatters.price(amount, symbol: r'$');
    case 'EUR':
      return Formatters.price(amount, symbol: '€');
    case 'CNY':
      return Formatters.price(amount, symbol: '¥');
    default:
      return '${Formatters.price(amount)} $currency';
  }
}

String calendarItemTitle(AppLocalizations l10n, UserCalendarPlanItem item) {
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

String monthLabel(String monthKey, String locale) {
  final parts = monthKey.split('-');
  if (parts.length != 2) return monthKey;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  if (year == null || month == null) return monthKey;
  const namesRu = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];
  const namesEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final names = locale.startsWith('ru') ? namesRu : namesEn;
  if (month < 1 || month > 12) return monthKey;
  return '${names[month - 1]} $year';
}

String calendarRecurrenceLabel(
  AppLocalizations l10n,
  UserCalendarRecurrence recurrence,
) {
  return switch (recurrence) {
    UserCalendarRecurrence.none => l10n.userCalendarRecurrenceNone,
    UserCalendarRecurrence.monthly => l10n.userCalendarRecurrenceMonthly,
    UserCalendarRecurrence.yearly => l10n.userCalendarRecurrenceYearly,
  };
}
