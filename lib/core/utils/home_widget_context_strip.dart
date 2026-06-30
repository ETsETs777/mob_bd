import '../../data/models/portfolio_position.dart';
import '../../core/utils/user_calendar_plan.dart';
import 'formatters.dart';

/// Нижняя полоска виджета: портфель + ближайшее событие календаря.
class HomeWidgetContextStrip {
  const HomeWidgetContextStrip({
    required this.portfolioLabel,
    required this.portfolioValue,
    required this.portfolioChange,
    required this.calendarLabel,
    required this.calendarTitle,
    required this.calendarDate,
    this.calendarEventId,
  });

  final String portfolioLabel;
  final String portfolioValue;
  final String portfolioChange;
  final String calendarLabel;
  final String calendarTitle;
  final String calendarDate;
  final String? calendarEventId;

  static const emptyCalendarTitle = '—';
  static const emptyCalendarDate = '';
}

HomeWidgetContextStrip buildHomeWidgetContextStrip({
  PortfolioSnapshot? portfolio,
  UserCalendarPlan? calendarPlan,
  String portfolioLabel = 'Portfolio',
  String calendarLabel = 'Next',
  String emptyCalendarHint = 'No events',
}) {
  String portfolioValue = '—';
  String portfolioChange = '';
  if (portfolio != null) {
    portfolioValue = Formatters.rub(portfolio.totalValueRub);
    portfolioChange = Formatters.percent(portfolio.pnlPercent);
  }

  final next = calendarPlan?.events.isNotEmpty == true
      ? calendarPlan!.events.first
      : null;

  if (next == null) {
    return HomeWidgetContextStrip(
      portfolioLabel: portfolioLabel,
      portfolioValue: portfolioValue,
      portfolioChange: portfolioChange,
      calendarLabel: calendarLabel,
      calendarTitle: HomeWidgetContextStrip.emptyCalendarTitle,
      calendarDate: emptyCalendarHint,
    );
  }

  final title = next.title.trim();
  final truncated = title.length > 28 ? '${title.substring(0, 25)}…' : title;

  return HomeWidgetContextStrip(
    portfolioLabel: portfolioLabel,
    portfolioValue: portfolioValue,
    portfolioChange: portfolioChange,
    calendarLabel: calendarLabel,
    calendarTitle: truncated.isEmpty ? HomeWidgetContextStrip.emptyCalendarTitle : truncated,
    calendarDate: Formatters.date(next.date),
    calendarEventId: next.manualEventId,
  );
}
