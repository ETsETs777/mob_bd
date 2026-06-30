import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_moderation_notifications.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('moderation notifications enabled by default', () {
    expect(ArticleModerationNotifications.isEnabled, isTrue);
  });

  test('setEnabled persists preference', () async {
    await ArticleModerationNotifications.setEnabled(false);
    expect(ArticleModerationNotifications.isEnabled, isFalse);
    await ArticleModerationNotifications.setEnabled(true);
    expect(ArticleModerationNotifications.isEnabled, isTrue);
  });
}
