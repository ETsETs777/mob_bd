import 'dart:convert';

import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';

/// Кэш полного текста статьи для офлайн-просмотра.
class ArticleDetailCache {
  ArticleDetailCache._();

  static String _key(String id) => 'article_detail_v1:$id';

  static UserArticle? get(String id) {
    final raw = CacheService.instance.getString(_key(id));
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserArticle.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> put(UserArticle article) async {
    await CacheService.instance.putString(
      _key(article.id),
      jsonEncode({
        'id': article.id,
        'title': article.title,
        'body': article.body,
        'status': article.status.name,
        'authorId': article.authorId,
        'authorName': article.authorName,
        'authorLogin': article.authorLogin,
        'rejectReason': article.rejectReason,
        'createdAt': article.createdAt.toIso8601String(),
        'updatedAt': article.updatedAt.toIso8601String(),
        'moderatedAt': article.moderatedAt?.toIso8601String(),
      }),
    );
  }

  static UserArticle? fromPublishedList(
    String id,
    List<UserArticle> published,
  ) {
    for (final article in published) {
      if (article.id == id) return article;
    }
    return null;
  }
}
