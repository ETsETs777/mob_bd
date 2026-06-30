import 'dart:convert';
import 'dart:io';

import '../db/database.dart';
import 'push_token_service.dart';

/// Отправка FCM data-push (legacy HTTP API). Без ключа — no-op.
class PushNotificationService {
  PushNotificationService({
    required this.db,
    required this.tokens,
    this.fcmServerKey = '',
  });

  final AppDatabase db;
  final PushTokenService tokens;
  final String fcmServerKey;

  bool get isConfigured => fcmServerKey.trim().isNotEmpty;

  Future<void> notifyArticleApproved({
    required String authorId,
    required String articleId,
    required String title,
  }) async {
    await _sendToUser(
      userId: authorId,
      data: {
        'type': 'article_status',
        'status': 'approved',
        'title': 'Статья одобрена',
        'body': '«$title» опубликована в ленте',
        'articleId': articleId,
      },
    );
  }

  Future<void> notifyArticleRejected({
    required String authorId,
    required String articleId,
    required String title,
    String? reason,
  }) async {
    final reasonSuffix =
        reason != null && reason.trim().isNotEmpty ? '\nПричина: ${reason.trim()}' : '';
    await _sendToUser(
      userId: authorId,
      data: {
        'type': 'article_status',
        'status': 'rejected',
        'title': 'Статья отклонена',
        'body': '«$title» не прошла модерацию$reasonSuffix',
        'articleId': articleId,
      },
    );
  }

  Future<void> notifyAdminsNewPending({
    required String articleId,
    required String title,
    required String authorLogin,
    String? excludeUserId,
  }) async {
    if (!isConfigured) return;
    final deviceTokens = await tokens.tokensForModerators(excludeUserId: excludeUserId);
    if (deviceTokens.isEmpty) return;

    await _sendToTokens(
      deviceTokens,
      data: {
        'type': 'article_moderation',
        'title': 'Новая статья на модерации',
        'body': '$authorLogin: «$title»',
        'articleId': articleId,
      },
    );
  }

  Future<void> _sendToUser({
    required String userId,
    required Map<String, String> data,
  }) async {
    if (!isConfigured) return;
    final deviceTokens = await tokens.tokensForUser(userId);
    if (deviceTokens.isEmpty) return;
    await _sendToTokens(deviceTokens, data: data);
  }

  Future<void> _sendToTokens(
    List<String> deviceTokens, {
    required Map<String, String> data,
  }) async {
    if (!isConfigured || deviceTokens.isEmpty) return;

    final client = HttpClient();
    try {
      for (final chunk in _chunks(deviceTokens, 500)) {
        final request = await client.postUrl(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
        );
        request.headers.set('Authorization', 'key=$fcmServerKey');
        request.headers.set('Content-Type', 'application/json');
        request.add(utf8.encode(jsonEncode({
          'registration_ids': chunk,
          'data': data,
          'priority': 'high',
        })));
        final response = await request.close();
        await response.drain();
      }
    } catch (e) {
      stderr.writeln('FCM send failed: $e');
    } finally {
      client.close(force: true);
    }
  }

  Iterable<List<String>> _chunks(List<String> items, int size) sync* {
    for (var i = 0; i < items.length; i += size) {
      yield items.sublist(i, i + size > items.length ? items.length : i + size);
    }
  }
}
