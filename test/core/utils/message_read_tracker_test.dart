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

  test('unread when lastAt is newer than seen', () async {
    const thread = ChatThread(
      id: 't1',
      type: 'direct',
      title: 'Peer',
      lastAt: '2026-06-28T12:00:00.000Z',
    );
    expect(MessageReadTracker.isUnread(thread), isTrue);

    await MessageReadTracker.markRead('t1', lastAt: thread.lastAt);
    expect(MessageReadTracker.isUnread(thread), isFalse);
  });

  test('unreadCount aggregates threads', () async {
    final threads = [
      const ChatThread(
        id: 'a',
        type: 'direct',
        title: 'A',
        lastAt: '2026-06-28T10:00:00.000Z',
      ),
      const ChatThread(
        id: 'b',
        type: 'direct',
        title: 'B',
        lastAt: '2026-06-28T11:00:00.000Z',
      ),
    ];
    expect(MessageReadTracker.unreadCount(threads), 2);
    await MessageReadTracker.markRead('a', lastAt: '2026-06-28T10:00:00.000Z');
    expect(MessageReadTracker.unreadCount(threads), 1);
  });

  test('markAllRead clears unread for all threads', () async {
    final threads = [
      const ChatThread(
        id: 'a',
        type: 'direct',
        title: 'A',
        lastAt: '2026-06-28T10:00:00.000Z',
      ),
      const ChatThread(
        id: 'b',
        type: 'direct',
        title: 'B',
        lastAt: '2026-06-28T11:00:00.000Z',
      ),
    ];
    expect(MessageReadTracker.unreadCount(threads), 2);

    await MessageReadTracker.markAllRead(threads);
    expect(MessageReadTracker.unreadCount(threads), 0);
  });
}
