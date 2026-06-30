import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/chat_thread_mute_tracker.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('mute and unmute thread', () async {
    expect(ChatThreadMuteTracker.isMuted('t1'), isFalse);
    final muted = await ChatThreadMuteTracker.toggle('t1');
    expect(muted, isTrue);
    expect(ChatThreadMuteTracker.isMuted('t1'), isTrue);

    final unmuted = await ChatThreadMuteTracker.toggle('t1');
    expect(unmuted, isFalse);
    expect(ChatThreadMuteTracker.isMuted('t1'), isFalse);
  });
}
