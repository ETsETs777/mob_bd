import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/chat_thread_pin_tracker.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('pin and unpin thread', () async {
    expect(ChatThreadPinTracker.isPinned('t1'), isFalse);
    final pinned = await ChatThreadPinTracker.toggle('t1');
    expect(pinned, isTrue);
    expect(ChatThreadPinTracker.isPinned('t1'), isTrue);

    final unpinned = await ChatThreadPinTracker.toggle('t1');
    expect(unpinned, isFalse);
    expect(ChatThreadPinTracker.isPinned('t1'), isFalse);
  });
}
