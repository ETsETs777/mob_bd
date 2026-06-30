import '../utils/calendar_plan_focus.dart';
import '../utils/user_calendar_plan.dart';

/// Отложенное открытие события календаря (уведомления, home card).
class CalendarNavigationIntent {
  CalendarNavigationIntent._();

  static String? focusManualEventId;
  static String? focusPlanItemKey;

  static void openManualEvent(String eventId) {
    focusManualEventId = eventId;
    focusPlanItemKey = 'manual:$eventId';
  }

  static void openPlanItem(UserCalendarPlanItem item) {
    focusPlanItemKey = calendarPlanItemFocusKey(item);
    focusManualEventId = item.manualEventId;
  }

  static String? consumeFocusManualEventId() {
    final id = focusManualEventId;
    focusManualEventId = null;
    return id;
  }

  static String? consumeFocusPlanItemKey() {
    final key = focusPlanItemKey;
    focusPlanItemKey = null;
    focusManualEventId = null;
    return key;
  }
}
