import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/chat_thread_hide_tracker.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('hide and unhide thread', () async {
    await ChatThreadHideTracker.hide('t1');
    expect(ChatThreadHideTracker.isHidden('t1'), isTrue);
    expect(ChatThreadHideTracker.hiddenCount(['t1', 't2']), 1);

    await ChatThreadHideTracker.unhide('t1');
    expect(ChatThreadHideTracker.isHidden('t1'), isFalse);
  });
}
