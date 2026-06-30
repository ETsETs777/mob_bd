import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/navigation/calendar_navigation_intent.dart';
import 'package:ecopulse/core/navigation/notification_navigator.dart';
import 'package:ecopulse/core/navigation/shell_navigation_intent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    ShellNavigationIntent.shellTab = null;
    ShellNavigationIntent.communitySubTab = null;
    CalendarNavigationIntent.focusManualEventId = null;
    CalendarNavigationIntent.focusPlanItemKey = null;
  });

  test('null or empty payload is ignored', () {
    navigateFromNotificationPayload(null);
    navigateFromNotificationPayload('');
    expect(ShellNavigationIntent.shellTab, isNull);
  });

  test('community:articles sets shell intent', () {
    navigateFromNotificationPayload('community:articles');
    expect(ShellNavigationIntent.shellTab, 5);
    expect(ShellNavigationIntent.communitySubTab, 1);
  });

  test('community:messages sets messages sub tab', () {
    navigateFromNotificationPayload('community:messages');
    expect(ShellNavigationIntent.shellTab, 5);
    expect(ShellNavigationIntent.communitySubTab, 0);
  });

  test('community:unknown sub tab defaults to messages', () {
    navigateFromNotificationPayload('community:other');
    expect(ShellNavigationIntent.shellTab, 5);
    expect(ShellNavigationIntent.communitySubTab, 0);
  });

  test('page payloads without navigator context are ignored', () {
    navigateFromNotificationPayload('article:art-42');
    navigateFromNotificationPayload('thread:t-99');
    navigateFromNotificationPayload('calendar:evt-7');
    navigateFromNotificationPayload('legacy-thread-id');
    expect(ShellNavigationIntent.shellTab, isNull);
    expect(CalendarNavigationIntent.consumeFocusPlanItemKey(), isNull);
  });
}
