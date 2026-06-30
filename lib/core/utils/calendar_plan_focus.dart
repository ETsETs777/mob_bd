import 'user_calendar_plan.dart';

/// Стабильный ключ для фокуса на событии портфеля в календаре.
String calendarPlanItemFocusKey(UserCalendarPlanItem item) {
  if (item.manualEventId != null) return 'manual:${item.manualEventId}';
  final date = item.date.toIso8601String().substring(0, 10);
  final symbol = item.symbol ?? item.title;
  final type = item.portfolioType?.name ?? '';
  return 'portfolio:$date:$symbol:$type';
}

UserCalendarPlanItem? findPlanItemByFocusKey(
  UserCalendarPlan plan,
  String key,
) {
  if (key.startsWith('manual:')) {
    final id = key.substring('manual:'.length);
    for (final item in plan.events) {
      if (item.manualEventId == id) return item;
    }
    return null;
  }
  if (key.startsWith('portfolio:')) {
    for (final item in plan.events) {
      if (item.source == UserCalendarEventSource.manual) continue;
      if (calendarPlanItemFocusKey(item) == key) return item;
    }
  }
  return null;
}
