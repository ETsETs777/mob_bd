import 'package:flutter/material.dart';

import '../../features/articles/article_detail_screen.dart';
import '../../features/calendar/user_calendar_screen.dart';
import '../../features/messages/chat_thread_screen.dart';
import '../../data/models/chat_thread.dart';
import '../motion/app_motion.dart';
import 'calendar_navigation_intent.dart';
import 'shell_navigation_intent.dart';

/// Ключ корневого навигатора для deep-link из уведомлений.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Открыть экран по payload локального уведомления.
void navigateFromNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) return;

  if (payload == 'community:articles') {
    ShellNavigationIntent.openCommunityArticles();
    return;
  }

  if (payload == 'community:messages') {
    ShellNavigationIntent.openCommunity(subTab: 0);
    return;
  }

  if (payload.startsWith('community:')) {
    final sub = payload.substring('community:'.length).trim();
    if (sub == 'articles') {
      ShellNavigationIntent.openCommunityArticles();
    } else {
      ShellNavigationIntent.openCommunity(subTab: 0);
    }
    return;
  }

  final context = rootNavigatorKey.currentContext;
  if (context == null) return;

  if (payload.startsWith('article:')) {
    final id = payload.substring('article:'.length).trim();
    if (id.isEmpty) return;
    openAppPage(context, ArticleDetailScreen(articleId: id));
    return;
  }

  if (payload.startsWith('thread:')) {
    final id = payload.substring('thread:'.length).trim();
    if (id.isEmpty) return;
    _openThread(context, id);
    return;
  }

  if (payload.startsWith('calendar:')) {
    final id = payload.substring('calendar:'.length).trim();
    if (id.isNotEmpty) {
      CalendarNavigationIntent.openManualEvent(id);
    }
    openAppPage(context, const UserCalendarScreen());
    return;
  }

  // Legacy: raw thread id from older notifications.
  if (!payload.contains(':')) {
    _openThread(context, payload);
  }
}

void _openThread(BuildContext context, String id) {
  openAppPage(
    context,
    ChatThreadScreen(
      thread: ChatThread(id: id, type: 'direct', title: ''),
    ),
  );
}
