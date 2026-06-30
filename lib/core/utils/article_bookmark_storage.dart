import 'dart:convert';

import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Локальные закладки статей.
class ArticleBookmarkStorage {
  ArticleBookmarkStorage._();

  static const _cacheKey = 'article_bookmarks_v1';

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

  static bool isBookmarked(String articleId) => load().contains(articleId);

  static Future<bool> toggle(String articleId) async {
    final ids = load();
    if (ids.contains(articleId)) {
      ids.remove(articleId);
      await _save(ids);
      return false;
    }
    ids.add(articleId);
    await _save(ids);
    return true;
  }
}
