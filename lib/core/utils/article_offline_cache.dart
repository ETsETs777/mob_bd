import 'dart:convert';

import '../../data/models/article_taxonomy.dart';
import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';

/// Локальный кэш ленты и «моих» статей Community.
class ArticleOfflineCache {
  ArticleOfflineCache._();

  static const publishedKey = 'user_articles_published_cache';
  static const mineKey = 'user_articles_mine_cache_v1';
  static const metaKey = 'user_articles_cache_meta_v1';

  static List<UserArticle> loadPublished() => _loadList(publishedKey);

  static List<UserArticle> loadMine() => _loadList(mineKey);

  static Future<void> savePublished(List<UserArticle> articles) async {
    await _saveList(publishedKey, articles);
    await _touchMeta();
  }

  static Future<void> saveMine(List<UserArticle> articles) async {
    await _saveList(mineKey, articles);
    await _touchMeta();
  }

  static DateTime? lastCachedAt() {
    final raw = CacheService.instance.getString(metaKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return DateTime.tryParse(json['cachedAt'] as String? ?? '');
    } catch (_) {
      return null;
    }
  }

  static Future<void> _touchMeta() async {
    await CacheService.instance.putString(
      metaKey,
      jsonEncode({'cachedAt': DateTime.now().toUtc().toIso8601String()}),
    );
  }

  static List<UserArticle> _loadList(String key) {
    final raw = CacheService.instance.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => UserArticle.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveList(String key, List<UserArticle> articles) async {
    await CacheService.instance.putString(
      key,
      jsonEncode(articles.map(_articleToJson).toList()),
    );
  }

  static Map<String, dynamic> _articleToJson(UserArticle a) => {
        'id': a.id,
        'title': a.title,
        'body': a.body,
        'status': a.status.name,
        'authorId': a.authorId,
        'authorName': a.authorName,
        'authorLogin': a.authorLogin,
        'rejectReason': a.rejectReason,
        'createdAt': a.createdAt.toIso8601String(),
        'updatedAt': a.updatedAt.toIso8601String(),
        'moderatedAt': a.moderatedAt?.toIso8601String(),
        'coverUrl': a.coverUrl,
        'publishAt': a.publishAt?.toIso8601String(),
        'category': a.category,
        'tags': a.tags,
        'featured': a.featured,
      };
}

/// Сохраняет taxonomy для офлайн-фильтров (best-effort).
class ArticleTaxonomyCache {
  ArticleTaxonomyCache._();

  static const key = 'user_articles_taxonomy_cache_v1';

  static ArticleTaxonomy? load() {
    final raw = CacheService.instance.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return ArticleTaxonomy.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(ArticleTaxonomy taxonomy) async {
    await CacheService.instance.putString(key, jsonEncode(taxonomy.toJson()));
  }
}
