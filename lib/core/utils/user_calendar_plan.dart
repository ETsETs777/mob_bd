import '../../data/models/user_calendar_event.dart';
import 'portfolio_income_calendar.dart';

enum UserCalendarEventSource { manual, portfolioAuto }

/// Элемент объединённого календаря (ручной + авто).
class UserCalendarPlanItem {
  const UserCalendarPlanItem({
    required this.date,
    required this.title,
    this.amount,
    required this.currency,
    required this.source,
    this.isEstimate = false,
    this.manualEventId,
    this.note,
    this.hasAttachment = false,
    this.portfolioType,
    this.symbol,
    this.recurrence = UserCalendarRecurrence.none,
    this.isRecurrenceInstance = false,
  });

  final DateTime date;
  final String title;
  final double? amount;
  final String currency;
  final UserCalendarEventSource source;
  final bool isEstimate;
  final String? manualEventId;
  final String? note;
  final bool hasAttachment;
  final PortfolioIncomeEventType? portfolioType;
  final String? symbol;
  final UserCalendarRecurrence recurrence;
  final bool isRecurrenceInstance;
}

/// Сводка календаря за горизонт.
class UserCalendarPlan {
  const UserCalendarPlan({
    required this.events,
    required this.totalsByCurrency,
    required this.byMonth,
  });

  final List<UserCalendarPlanItem> events;
  final Map<String, double> totalsByCurrency;
  final Map<String, List<UserCalendarPlanItem>> byMonth;

  List<UserCalendarPlanItem> get upcoming => events.take(20).toList();
}

String monthKeyFor(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _addMonths(DateTime date, int months) {
  final monthIndex = date.month - 1 + months;
  final year = date.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = date.day > lastDay ? lastDay : date.day;
  return DateTime(year, month, day);
}

DateTime _addYears(DateTime date, int years) {
  final targetYear = date.year + years;
  final lastDay = DateTime(targetYear, date.month + 1, 0).day;
  final day = date.day > lastDay ? lastDay : date.day;
  return DateTime(targetYear, date.month, day);
}

/// Разворачивает даты события с учётом повторения в диапазоне [start, end].
List<DateTime> expandEventDates(
  UserCalendarEvent event,
  DateTime start,
  DateTime end,
) {
  final base = _dateOnly(event.date);
  final from = _dateOnly(start);
  final to = _dateOnly(end);

  if (event.recurrence == UserCalendarRecurrence.none) {
    if (base.isBefore(from) || base.isAfter(to)) return const [];
    return [base];
  }

  final dates = <DateTime>[];
  var cursor = base;

  if (event.recurrence == UserCalendarRecurrence.monthly) {
    while (cursor.isBefore(from)) {
      cursor = _addMonths(cursor, 1);
    }
    while (!cursor.isAfter(to)) {
      dates.add(cursor);
      cursor = _addMonths(cursor, 1);
    }
  } else if (event.recurrence == UserCalendarRecurrence.yearly) {
    while (cursor.isBefore(from)) {
      cursor = _addYears(cursor, 1);
    }
    while (!cursor.isAfter(to)) {
      dates.add(cursor);
      cursor = _addYears(cursor, 1);
    }
  }

  return dates;
}

UserCalendarPlanItem _fromManual(
  UserCalendarEvent event,
  DateTime occurrence, {
  required bool isRecurrenceInstance,
}) {
  return UserCalendarPlanItem(
    date: _dateOnly(occurrence),
    title: event.title,
    amount: event.amount,
    currency: event.currency.toUpperCase(),
    source: UserCalendarEventSource.manual,
    manualEventId: event.id,
    note: event.note,
    hasAttachment: event.hasAttachment,
    recurrence: event.recurrence,
    isRecurrenceInstance: isRecurrenceInstance,
  );
}

UserCalendarPlanItem _fromPortfolio(PortfolioIncomeEvent event) {
  return UserCalendarPlanItem(
    date: _dateOnly(event.date),
    title: event.symbol,
    amount: event.amountRub,
    currency: 'RUB',
    source: UserCalendarEventSource.portfolioAuto,
    isEstimate: event.isEstimate,
    portfolioType: event.type,
    symbol: event.symbol,
  );
}

/// Строит объединённый календарь.
UserCalendarPlan buildUserCalendarPlan({
  required List<UserCalendarEvent> manualEvents,
  PortfolioIncomePlan? portfolioPlan,
  required bool showPortfolioEvents,
  DateTime? asOf,
  int horizonDays = 365,
}) {
  final now = _dateOnly(asOf ?? DateTime.now());
  final end = now.add(Duration(days: horizonDays));

  final items = <UserCalendarPlanItem>[];

  for (final event in manualEvents) {
    final occurrences = expandEventDates(event, now, end);
    for (final day in occurrences) {
      items.add(
        _fromManual(
          event,
          day,
          isRecurrenceInstance: event.isRecurring &&
              !_dateOnly(event.date).isAtSameMomentAs(_dateOnly(day)),
        ),
      );
    }
  }

  if (showPortfolioEvents && portfolioPlan != null) {
    for (final event in portfolioPlan.events) {
      final day = _dateOnly(event.date);
      if (day.isBefore(now) || day.isAfter(end)) continue;
      items.add(_fromPortfolio(event));
    }
  }

  items.sort((a, b) {
    final byDate = a.date.compareTo(b.date);
    if (byDate != 0) return byDate;
    return a.title.compareTo(b.title);
  });

  final totalsByCurrency = <String, double>{};
  final byMonth = <String, List<UserCalendarPlanItem>>{};

  for (final item in items) {
    final amount = item.amount;
    if (amount != null && amount > 0) {
      final code = item.currency.toUpperCase();
      totalsByCurrency[code] = (totalsByCurrency[code] ?? 0) + amount;
    }
    final key = monthKeyFor(item.date);
    byMonth.putIfAbsent(key, () => []).add(item);
  }

  return UserCalendarPlan(
    events: items,
    totalsByCurrency: totalsByCurrency,
    byMonth: byMonth,
  );
}
