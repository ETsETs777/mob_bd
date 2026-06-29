import '../../data/models/chat_thread.dart';

/// Потоки с новой активностью (lastAt изменился).
List<ChatThread> threadsWithNewActivity({
  required List<ChatThread> previous,
  required List<ChatThread> current,
  String activeThreadId = '',
}) {
  if (previous.isEmpty) return const [];

  final prevById = {for (final t in previous) t.id: t.lastAt};
  final updates = <ChatThread>[];

  for (final thread in current) {
    if (thread.id == activeThreadId) continue;
    final lastAt = thread.lastAt;
    if (lastAt == null || lastAt.isEmpty) continue;
    if (prevById[thread.id] == lastAt) continue;
    updates.add(thread);
  }

  return updates;
}
