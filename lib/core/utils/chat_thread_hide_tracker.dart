import 'dart:convert';

import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Локально скрытые чаты (не удаляются с сервера).
class ChatThreadHideTracker {
  ChatThreadHideTracker._();

  static const _cacheKey = 'chat_thread_hidden_v1';

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

  static bool isHidden(String threadId) => load().contains(threadId);

  static Future<void> hide(String threadId) async {
    final ids = load()..add(threadId);
    await _save(ids);
  }

  static Future<void> unhide(String threadId) async {
    final ids = load()..remove(threadId);
    await _save(ids);
  }

  static int hiddenCount(Iterable<String> threadIds) {
    final hidden = load();
    var count = 0;
    for (final id in threadIds) {
      if (hidden.contains(id)) count++;
    }
    return count;
  }
}
