import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cloud/fcm_config.dart';
import '../../core/services/fcm_service.dart';
import '../../core/utils/chat_thread_mute_tracker.dart';
import '../../core/utils/message_push_utils.dart';
import '../../data/models/chat_thread.dart';
import '../../data/services/cache_service.dart';
import '../../data/models/home_server_auth.dart';
import '../../data/services/home_server_client.dart';
import '../../core/services/notification_service.dart';
import '../profile/home_server_provider.dart';

class MessagePushSettings {
  const MessagePushSettings({this.enabled = true});

  final bool enabled;

  MessagePushSettings copyWith({bool? enabled}) =>
      MessagePushSettings(enabled: enabled ?? this.enabled);
}

final messagePushProvider =
    NotifierProvider<MessagePushNotifier, MessagePushSettings>(
  MessagePushNotifier.new,
);

class MessagePushNotifier extends Notifier<MessagePushSettings> {
  static const enabledKey = 'message_push_enabled';

  @override
  MessagePushSettings build() {
    final raw = CacheService.instance.getString(enabledKey);
    // enabled by default when user opts in via UI; null => true for new installs
    return MessagePushSettings(enabled: raw == null || raw == '1');
  }

  Future<void> setEnabled(bool value) async {
    await CacheService.instance.putString(enabledKey, value ? '1' : '0');
    state = state.copyWith(enabled: value);
    if (value) {
      await syncPushToken();
    } else {
      await unregisterPushToken();
    }
  }

  Future<void> syncPushToken() async {
    if (!state.enabled) return;
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return;

    final client = ref.read(homeServerClientProvider);
    if (FcmConfig.isConfigured) {
      await FcmService.instance.init(onTokenRefreshed: (token) async {
        await _registerToken(client, auth, token);
      });
      final token = FcmService.instance.token;
      if (token.isNotEmpty) {
        await _registerToken(client, auth, token);
      }
    }
  }

  Future<void> unregisterPushToken() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return;
    final token = FcmService.instance.token;
    if (token.isEmpty) return;
    try {
      await ref.read(homeServerClientProvider).unregisterPushToken(auth, token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
    } catch (_) {}
  }

  Future<void> _registerToken(
    HomeServerClient client,
    HomeServerAuth auth,
    String token,
  ) async {
    try {
      await client.registerPushToken(auth, token: token, platform: 'android');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
    } catch (_) {}
  }

  Future<void> notifyNewThreads({
    required List<ChatThread> previous,
    required List<ChatThread> current,
    String activeThreadId = '',
  }) async {
    if (!state.enabled) return;

    final updates = threadsWithNewActivity(
      previous: previous,
      current: current,
      activeThreadId: activeThreadId,
    );
    if (updates.isEmpty) return;

    for (final thread in updates) {
      if (ChatThreadMuteTracker.isMuted(thread.id)) continue;
      final body = thread.lastText?.trim() ?? '';
      if (body.isEmpty) continue;
      await NotificationService.instance.showMessageNotification(
        id: 7000 + (thread.id.hashCode.abs() % 9000),
        title: thread.title,
        body: body,
        threadId: thread.id,
      );
    }
  }
}
