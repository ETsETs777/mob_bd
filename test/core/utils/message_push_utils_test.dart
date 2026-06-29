import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/message_push_utils.dart';
import 'package:ecopulse/data/models/chat_thread.dart';

void main() {
  const t1 = ChatThread(
    id: 'a',
    type: 'direct',
    title: 'Alice',
    lastText: 'Hi',
    lastAt: '2026-06-28T10:00:00Z',
  );
  const t1Updated = ChatThread(
    id: 'a',
    type: 'direct',
    title: 'Alice',
    lastText: 'New message',
    lastAt: '2026-06-28T11:00:00Z',
  );
  const t2 = ChatThread(
    id: 'b',
    type: 'direct',
    title: 'Bob',
    lastText: 'Same',
    lastAt: '2026-06-28T09:00:00Z',
  );

  test('threadsWithNewActivity detects lastAt changes', () {
    final updates = threadsWithNewActivity(
      previous: const [t1, t2],
      current: const [t1Updated, t2],
    );
    expect(updates, hasLength(1));
    expect(updates.first.id, 'a');
  });

  test('threadsWithNewActivity skips active thread', () {
    final updates = threadsWithNewActivity(
      previous: const [t1],
      current: const [t1Updated],
      activeThreadId: 'a',
    );
    expect(updates, isEmpty);
  });

  test('threadsWithNewActivity returns empty on first load', () {
    final updates = threadsWithNewActivity(
      previous: const [],
      current: const [t1Updated],
    );
    expect(updates, isEmpty);
  });
}
