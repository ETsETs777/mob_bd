import 'notification_service.dart';

/// Маршрутизация FCM data-сообщений по типу.
Future<void> handleFcmRemoteData(Map<String, dynamic> data) async {
  final type = data['type'] as String? ?? '';
  final title = data['title'] as String? ?? 'EcoPulse';
  final body = data['body'] as String? ?? '';
  if (body.isEmpty && type != 'message') return;

  switch (type) {
    case 'article_status':
      final articleId = data['articleId'] as String? ?? '';
      await NotificationService.instance.showArticleStatus(
        id: articleNotificationId(articleId),
        title: title,
        body: body,
        articleId: articleId.isEmpty ? null : articleId,
      );
      return;
    case 'article_moderation':
      final articleId = data['articleId'] as String? ?? '';
      await NotificationService.instance.showArticleModeration(
        id: articleNotificationId('mod_$articleId'),
        title: title,
        body: body,
        articleId: articleId.isEmpty ? null : articleId,
      );
      return;
    default:
      final threadId = data['threadId'] as String? ?? '';
      await NotificationService.instance.showMessageNotification(
        id: threadId.isEmpty
            ? messageNotificationIdFromBody(body)
            : messageNotificationIdForThread(threadId),
        title: title,
        body: body,
        threadId: threadId.isEmpty ? null : threadId,
      );
  }
}

int articleNotificationId(String key) => 8000 + (key.hashCode.abs() % 9000);

int messageNotificationIdForThread(String threadId) =>
    7000 + (threadId.hashCode.abs() % 9000);

int messageNotificationIdFromBody(String body) =>
    7000 + (body.hashCode.abs() % 9000);
