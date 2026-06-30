import 'dart:convert';

import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Отключённые чаты — без локальных push при новых сообщениях.
class ChatThreadMuteTracker {
  ChatThreadMuteTracker._();

  static const _cacheKey = 'chat_thread_muted_v1';

  static Set<String> load() {
    final raw = CacheService.instance.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      return Set<String>.from(jsonDecode(raw) as List<dynamic>);
    } catch (_) {
      return {};
    }
  }

  static Future<void> _save(Set<String> ids) async {
    await CacheService.instance.putString(_cacheKey, jsonEncode(ids.toList()));
    UserLocalDataAutoSync.onCommunityPrefsChanged();
  }

  static bool isMuted(String threadId) => load().contains(threadId);

  static Future<bool> toggle(String threadId) async {
    final ids = load();
    if (ids.contains(threadId)) {
      ids.remove(threadId);
      await _save(ids);
      return false;
    }
    ids.add(threadId);
    await _save(ids);
    return true;
  }
}
