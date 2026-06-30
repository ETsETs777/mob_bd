import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/chat_sort_preferences.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('unreadFirst defaults to true', () {
    expect(ChatSortPreferences.unreadFirst, isTrue);
  });

  test('setUnreadFirst persists', () async {
    await ChatSortPreferences.setUnreadFirst(false);
    expect(ChatSortPreferences.unreadFirst, isFalse);
    await ChatSortPreferences.setUnreadFirst(true);
    expect(ChatSortPreferences.unreadFirst, isTrue);
  });
}
