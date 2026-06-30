import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:ecopulse/core/utils/user_calendar_plan.dart';
import 'package:ecopulse/core/utils/user_calendar_share.dart';
import 'package:ecopulse/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  test('empty plan returns share empty message', () {
    const plan = UserCalendarPlan(
      events: [],
      totalsByCurrency: {},
      byMonth: {},
    );
    expect(buildUserCalendarShareText(l10n, plan), l10n.userCalendarShareEmpty);
  });

  test('includes title and events', () {
    final plan = UserCalendarPlan(
      events: [
        UserCalendarPlanItem(
          date: DateTime(2026, 6, 15),
          title: 'Salary',
          amount: 1000,
          currency: 'USD',
          source: UserCalendarEventSource.manual,
        ),
      ],
      totalsByCurrency: {'USD': 1000},
      byMonth: {},
    );
    final text = buildUserCalendarShareText(l10n, plan);
    expect(text, contains(l10n.userCalendarTitle));
    expect(text, contains('Salary'));
  });

  test('truncates at 50 events with more line', () {
    final events = List.generate(
      55,
      (i) => UserCalendarPlanItem(
        date: DateTime(2026, 1, 1).add(Duration(days: i)),
        title: 'Event $i',
        currency: 'RUB',
        source: UserCalendarEventSource.manual,
      ),
    );
    final plan = UserCalendarPlan(
      events: events,
      totalsByCurrency: {},
      byMonth: {},
    );
    final text = buildUserCalendarShareText(l10n, plan);
    expect(text, contains(l10n.userCalendarShareMore(5)));
    expect(text, isNot(contains('Event 54')));
  });
}
