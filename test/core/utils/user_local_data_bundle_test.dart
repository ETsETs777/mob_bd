import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/user_local_data_bundle.dart';
import 'package:ecopulse/data/models/user_calendar_event.dart';
import 'package:ecopulse/data/services/cache_service.dart';
import 'package:ecopulse/providers/calendar/user_calendar_provider.dart';
import 'package:ecopulse/providers/calendar/user_calendar_settings_provider.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('build and apply roundtrip calendar events', () async {
    final events = [
      UserCalendarEvent(
        id: 'e1',
        title: 'Coupon',
        date: DateTime(2026, 6, 1),
        amount: 500,
        currency: 'RUB',
        createdAt: DateTime(2026, 1, 1),
      ),
    ];

    final payload = UserLocalDataBundle.build(
      events: events,
      calendarSettingsJson: '{"showPortfolioEvents":true}',
      useCustomAvatar: false,
    );

    expect(payload['fingerprint'], isNotEmpty);
    expect(payload['calendarEvents'], isA<List>());

    final restored = await UserLocalDataBundle.apply(payload);
    expect(restored, greaterThan(0));

    final raw = CacheService.instance.getString(UserCalendarNotifier.cacheKey);
    expect(raw, isNotNull);
    expect(raw, contains('Coupon'));

    final settings =
        CacheService.instance.getString(UserCalendarSettingsNotifier.cacheKey);
    expect(settings, contains('showPortfolioEvents'));
  });

  test('build and apply roundtrip community prefs', () async {
    await CacheService.instance.putString(
      UserLocalDataBundle.articleBookmarksKey,
      '["a1"]',
    );
    await CacheService.instance.putString(
      UserLocalDataBundle.articleReadAtKey,
      '{"a1":"2026-06-01T00:00:00.000Z"}',
    );

    final payload = UserLocalDataBundle.build(
      events: const [],
      calendarSettingsJson: '',
      useCustomAvatar: false,
    );

    await CacheService.instance.putString(
      UserLocalDataBundle.articleBookmarksKey,
      '',
    );
    await CacheService.instance.putString(
      UserLocalDataBundle.articleReadAtKey,
      '',
    );

    await UserLocalDataBundle.apply(payload);

    expect(
      CacheService.instance.getString(UserLocalDataBundle.articleBookmarksKey),
      '["a1"]',
    );
    expect(
      CacheService.instance.getString(UserLocalDataBundle.articleReadAtKey),
      contains('a1'),
    );
  });
}
