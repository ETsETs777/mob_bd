import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/message_read_tracker.dart';
import 'package:ecopulse/data/models/chat_thread.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('markUnread makes thread unread again', () async {
    const thread = ChatThread(
      id: 't1',
      type: 'direct',
      title: 'Chat',
      lastAt: '2026-06-01T12:00:00.000Z',
    );
    await MessageReadTracker.markRead(thread.id, lastAt: thread.lastAt);
    expect(MessageReadTracker.isUnread(thread), isFalse);

    await MessageReadTracker.markUnread(thread.id);
    expect(MessageReadTracker.isUnread(thread), isTrue);
  });
}
