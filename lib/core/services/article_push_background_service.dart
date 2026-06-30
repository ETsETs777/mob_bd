import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../data/models/home_server_auth.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/home_server_client.dart';
import '../utils/article_moderation_notifications.dart';
import '../utils/article_status_notifications.dart';
import 'notification_service.dart';

const articlePushBackgroundTaskName = 'ecopulse_article_push_check';

/// Фоновая проверка статусов статей и очереди модерации (fallback без FCM).
class ArticlePushBackgroundService {
  ArticlePushBackgroundService._();

  static final instance = ArticlePushBackgroundService._();

  static Future<bool> runCheck() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CacheService.instance.init();
    await NotificationService.instance.init();

    final auth = _loadAuth();
    if (auth == null || !auth.isLoggedIn) return true;

    final client = HomeServerClient();

    if (ArticleStatusNotifications.isEnabled) {
      try {
        final mine = await client.fetchMyArticles(auth);
        await ArticleStatusNotifications.handleMineList(mine);
      } catch (_) {}
    }

    if (auth.canModerateArticles && ArticleModerationNotifications.isEnabled) {
      try {
        final pending = await client.fetchPendingArticles(auth);
        await ArticleModerationNotifications.handlePendingList(pending);
      } catch (_) {}
    }

    return true;
  }

  static HomeServerAuth? _loadAuth() {
    final raw = CacheService.instance.getString('home_server_auth');
    if (raw == null || raw.isEmpty) return null;
    try {
      return HomeServerAuth.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
