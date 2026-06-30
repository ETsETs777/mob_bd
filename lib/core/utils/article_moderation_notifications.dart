import 'dart:convert';

import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';
import '../../core/services/notification_service.dart';

/// Локальные push админу при новых статьях в очереди модерации.
class ArticleModerationNotifications {
  ArticleModerationNotifications._();

  static const snapshotKey = 'admin_pending_articles_v1';
  static const enabledKey = 'article_moderation_notify_enabled';

  static bool get isEnabled {
    final raw = CacheService.instance.getString(enabledKey);
    return raw == null || raw == '1';
  }

  static Future<void> setEnabled(bool value) async {
    await CacheService.instance.putString(enabledKey, value ? '1' : '0');
  }

  static Set<String> _loadSnapshot() {
    final raw = CacheService.instance.getString(snapshotKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => e as String).toSet();
    } catch (_) {
      return {};
    }
  }

  static Future<void> _saveSnapshot(List<UserArticle> pending) async {
    await CacheService.instance.putString(
      snapshotKey,
      jsonEncode(pending.map((a) => a.id).toList()),
    );
  }

  static Future<void> handlePendingList(List<UserArticle> pending) async {
    if (!isEnabled) {
      await _saveSnapshot(pending);
      return;
    }

    final previous = _loadSnapshot();
    if (previous.isEmpty) {
      await _saveSnapshot(pending);
      return;
    }

    final isRu = _isRuLocale();
    for (final article in pending) {
      if (previous.contains(article.id)) continue;
      await NotificationService.instance.showArticleModeration(
        id: 8500 + (article.id.hashCode.abs() % 8000),
        title: isRu ? 'Новая статья на модерации' : 'New article to review',
        body: isRu
            ? '${article.authorLogin}: «${article.title}»'
            : '${article.authorLogin}: "${article.title}"',
        articleId: article.id,
      );
    }

    await _saveSnapshot(pending);
  }

  static bool _isRuLocale() {
    final code = CacheService.instance.getString('app_locale');
    return code == null || code.startsWith('ru');
  }
}
