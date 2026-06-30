import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_status_notifications.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('article status notifications enabled by default', () {
    expect(ArticleStatusNotifications.isEnabled, isTrue);
  });

  test('setEnabled persists preference', () async {
    await ArticleStatusNotifications.setEnabled(false);
    expect(ArticleStatusNotifications.isEnabled, isFalse);
    await ArticleStatusNotifications.setEnabled(true);
    expect(ArticleStatusNotifications.isEnabled, isTrue);
  });
}
