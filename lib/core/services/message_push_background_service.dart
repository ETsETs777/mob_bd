import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../data/models/chat_thread.dart';
import '../../data/models/home_server_auth.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/home_server_client.dart';
import '../../core/utils/message_push_utils.dart';
import '../../providers/messages/message_push_provider.dart';
import 'notification_service.dart';

const messagePushBackgroundTaskName = 'ecopulse_message_push_check';

/// Фоновая проверка новых сообщений (fallback без FCM от сервера).
class MessagePushBackgroundService {
  MessagePushBackgroundService._();

  static final instance = MessagePushBackgroundService._();

  static Future<bool> runCheck() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CacheService.instance.init();
    await NotificationService.instance.init();

    final enabled =
        CacheService.instance.getString(MessagePushNotifier.enabledKey);
    if (enabled == '0') return true;

    final authRaw = CacheService.instance.getString('home_server_auth');
    if (authRaw == null || authRaw.isEmpty) return true;

    HomeServerAuth auth;
    try {
      auth = HomeServerAuth.fromJson(
        jsonDecode(authRaw) as Map<String, dynamic>,
      );
    } catch (_) {
      return true;
    }
    if (!auth.isLoggedIn) return true;

    const threadsCacheKey = 'home_server_threads_cache';
    List<ChatThread> previous = [];
    final cached = CacheService.instance.getString(threadsCacheKey);
    if (cached != null && cached.isNotEmpty) {
      try {
        previous = (jsonDecode(cached) as List<dynamic>)
            .map((e) => ChatThread.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    final client = HomeServerClient();
    List<ChatThread> current;
    try {
      current = await client.fetchThreads(auth);
    } catch (_) {
      return true;
    }

    final updates = threadsWithNewActivity(
      previous: previous,
      current: current,
    );

    for (final thread in updates) {
      final body = thread.lastText?.trim() ?? '';
      if (body.isEmpty) continue;
      await NotificationService.instance.showMessageNotification(
        id: 7000 + (thread.id.hashCode.abs() % 9000),
        title: thread.title,
        body: body,
        threadId: thread.id,
      );
    }

    await CacheService.instance.putString(
      threadsCacheKey,
      jsonEncode(current.map((t) => t.toJson()).toList()),
    );

    return true;
  }
}
