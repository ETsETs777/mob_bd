import 'dart:convert';

import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Локальная отметка «прочитано» для статей ленты.
class ArticleReadTracker {
  ArticleReadTracker._();

  static const _cacheKey = 'article_read_at_v1';

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

  static Future<void> markRead(String articleId, {String? updatedAt}) async {
    final map = _load();
    map[articleId] = updatedAt ?? DateTime.now().toUtc().toIso8601String();
    await _save(map);
  }

  static Future<void> markUnread(String articleId) async {
    final map = _load();
    map.remove(articleId);
    await _save(map);
  }

  static bool isUnread(String articleId, DateTime updatedAt) {
    final seen = _load()[articleId];
    if (seen == null || seen.isEmpty) return true;
    final seenDt = DateTime.tryParse(seen);
    if (seenDt == null) return true;
    return updatedAt.isAfter(seenDt);
  }

  static int unreadCount(List<UserArticle> articles) {
    var count = 0;
    for (final article in articles) {
      if (isUnread(article.id, article.updatedAt)) count++;
    }
    return count;
  }

  static Future<void> markAllRead(List<UserArticle> articles) async {
    for (final article in articles) {
      await markRead(
        article.id,
        updatedAt: article.updatedAt.toIso8601String(),
      );
    }
  }
}
