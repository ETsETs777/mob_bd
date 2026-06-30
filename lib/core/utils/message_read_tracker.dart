import 'dart:convert';

import '../../data/models/chat_thread.dart';
import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Локальная отметка «прочитано» для чатов (по lastAt потока).
class MessageReadTracker {
  MessageReadTracker._();

  static const _cacheKey = 'chat_thread_read_at_v1';

  static Map<String, String> _load() {
    final raw = CacheService.instance.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      return Map<String, String>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return {};
    }
  }

  static Future<void> _save(Map<String, String> map) async {
    await CacheService.instance.putString(_cacheKey, jsonEncode(map));
    UserLocalDataAutoSync.onCommunityPrefsChanged();
  }

  static Future<void> markRead(String threadId, {String? lastAt}) async {
    if (lastAt == null || lastAt.isEmpty) return;
    final map = _load();
    map[threadId] = lastAt;
    await _save(map);
  }

  static Future<void> markUnread(String threadId) async {
    final map = _load();
    map.remove(threadId);
    await _save(map);
  }

  static bool isUnread(ChatThread thread) {
    final lastAt = thread.lastAt;
    if (lastAt == null || lastAt.isEmpty) return false;
    final seen = _load()[thread.id];
    if (seen == null || seen.isEmpty) return true;
    final seenDt = DateTime.tryParse(seen);
    final lastDt = DateTime.tryParse(lastAt);
    if (seenDt == null || lastDt == null) {
      return seen != lastAt;
    }
    return lastDt.isAfter(seenDt);
  }

  static int unreadCount(List<ChatThread> threads) {
    var count = 0;
    for (final thread in threads) {
      if (isUnread(thread)) count++;
    }
    return count;
  }

  static Future<void> markAllRead(List<ChatThread> threads) async {
    for (final thread in threads) {
      if (thread.lastAt != null && thread.lastAt!.isNotEmpty) {
        await markRead(thread.id, lastAt: thread.lastAt);
      }
    }
  }
}
