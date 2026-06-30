import 'dart:convert';

import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';
import '../../core/services/notification_service.dart';

/// Локальные уведомления при смене статуса статьи (pending → approved/rejected).
class ArticleStatusNotifications {
  ArticleStatusNotifications._();

  static const snapshotKey = 'user_articles_mine_status_v1';
  static const enabledKey = 'article_status_notify_enabled';

  static bool get isEnabled {
    final raw = CacheService.instance.getString(enabledKey);
    return raw == null || raw == '1';
  }

  static Future<void> setEnabled(bool value) async {
    await CacheService.instance.putString(enabledKey, value ? '1' : '0');
  }

  static Map<String, String> _loadSnapshot() {
    final raw = CacheService.instance.getString(snapshotKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v as String));
    } catch (_) {
      return {};
    }
  }

  static Future<void> _saveSnapshot(List<UserArticle> mine) async {
    final map = {for (final a in mine) a.id: a.status.name};
    await CacheService.instance.putString(snapshotKey, jsonEncode(map));
  }

  /// После загрузки «Мои статьи» — уведомить об одобрении/отклонении.
  static Future<void> handleMineList(List<UserArticle> mine) async {
    if (!isEnabled) {
      await _saveSnapshot(mine);
      return;
    }

    final previous = _loadSnapshot();
    if (previous.isEmpty) {
      await _saveSnapshot(mine);
      return;
    }

    final isRu = _isRuLocale();

    for (final article in mine) {
      final prev = previous[article.id];
      if (prev != UserArticleStatus.pending.name) continue;

      if (article.isApproved) {
        await NotificationService.instance.showArticleStatus(
          id: 8000 + (article.id.hashCode.abs() % 9000),
          title: isRu ? 'Статья одобрена' : 'Article approved',
          body: isRu
              ? '«${article.title}» опубликована в ленте'
              : '"${article.title}" is now published',
          articleId: article.id,
        );
      } else if (article.isRejected) {
        final reason = article.rejectReason?.trim();
        final reasonSuffix = reason != null && reason.isNotEmpty
            ? (isRu ? '\nПричина: $reason' : '\nReason: $reason')
            : '';
        await NotificationService.instance.showArticleStatus(
          id: 8000 + (article.id.hashCode.abs() % 9000),
          title: isRu ? 'Статья отклонена' : 'Article rejected',
          body: isRu
              ? '«${article.title}» не прошла модерацию$reasonSuffix'
              : '"${article.title}" was not approved$reasonSuffix',
          articleId: article.id,
        );
      }
    }

    await _saveSnapshot(mine);
  }

  static bool _isRuLocale() {
    final code = CacheService.instance.getString('app_locale');
    return code == null || code.startsWith('ru');
  }

  /// Сразу после отправки — зафиксировать pending в snapshot.
  static Future<void> recordSubmitted(UserArticle article) async {
    final snap = _loadSnapshot();
    snap[article.id] = article.status.name;
    await CacheService.instance.putString(snapshotKey, jsonEncode(snap));
  }
}
