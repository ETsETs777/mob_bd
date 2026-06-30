import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/chat_thread.dart';
import '../../features/articles/article_detail_screen.dart';
import '../../features/calendar/user_calendar_screen.dart';
import '../../features/messages/chat_thread_screen.dart';
import '../motion/app_motion.dart';
import 'app_deep_link.dart';
import 'calendar_navigation_intent.dart';
import 'notification_navigator.dart';
import 'shell_navigation_intent.dart';

/// Отложенная навигация по deep link (cold start, PIN lock).
class AppLinkNavigationIntent {
  AppLinkNavigationIntent._();

  static AppDeepLink? pending;

  static void schedule(AppDeepLink link) {
    pending = link;
  }

  static void consume(WidgetRef ref) {
    final link = pending;
    if (link == null) return;
    pending = null;
    navigateFromAppDeepLink(link);
  }

  static void tryNavigateNow(AppDeepLink link) {
    schedule(link);
    if (rootNavigatorKey.currentContext != null) {
      pending = null;
      navigateFromAppDeepLink(link);
    }
  }
}

void navigateFromAppDeepLink(AppDeepLink link) {
  switch (link.kind) {
    case AppDeepLinkKind.article:
      ShellNavigationIntent.openCommunityArticles();
      _openArticle(link.id);
    case AppDeepLinkKind.thread:
      ShellNavigationIntent.openCommunityMessages();
      _openThread(link.id);
    case AppDeepLinkKind.calendar:
      CalendarNavigationIntent.openManualEvent(link.id);
      _openCalendar();
  }
}

void _openArticle(String id) {
  final context = rootNavigatorKey.currentContext;
  if (context == null) {
    AppLinkNavigationIntent.schedule(AppDeepLink.article(id));
    return;
  }
  openAppPage(context, ArticleDetailScreen(articleId: id));
}

void _openThread(String id) {
  final context = rootNavigatorKey.currentContext;
  if (context == null) {
    AppLinkNavigationIntent.schedule(AppDeepLink.thread(id));
    return;
  }
  openAppPage(
    context,
    ChatThreadScreen(
      thread: ChatThread(id: id, type: 'direct', title: ''),
    ),
  );
}

void _openCalendar() {
  final context = rootNavigatorKey.currentContext;
  if (context == null) return;
  openAppPage(context, const UserCalendarScreen());
}

/// Backward-compatible entry for notification payloads.
void dispatchNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) return;

  if (payload.startsWith('article:')) {
    final id = payload.substring('article:'.length).trim();
    if (id.isNotEmpty) navigateFromAppDeepLink(AppDeepLink.article(id));
    return;
  }
  if (payload.startsWith('thread:')) {
    final id = payload.substring('thread:'.length).trim();
    if (id.isNotEmpty) navigateFromAppDeepLink(AppDeepLink.thread(id));
    return;
  }
  if (payload.startsWith('calendar:')) {
    final id = payload.substring('calendar:'.length).trim();
    if (id.isNotEmpty) navigateFromAppDeepLink(AppDeepLink.calendarEvent(id));
    return;
  }

  if (payload == 'community:articles') {
    ShellNavigationIntent.openCommunityArticles();
    return;
  }
  if (payload == 'community:messages') {
    ShellNavigationIntent.openCommunityMessages();
    return;
  }
  if (payload.startsWith('community:')) {
    ShellNavigationIntent.openCommunity(subTab: 0);
    return;
  }

  final context = rootNavigatorKey.currentContext;
  if (context == null) return;
  if (!payload.contains(':')) {
    openAppPage(
      context,
      ChatThreadScreen(
        thread: ChatThread(id: payload, type: 'direct', title: ''),
      ),
    );
  }
}
