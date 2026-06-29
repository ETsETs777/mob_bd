import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../cloud/fcm_config.dart';
import 'notification_service.dart';

/// Обработчик FCM в фоне (top-level, отдельный isolate).
@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  if (!FcmConfig.isConfigured) return;

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: FcmConfig.apiKey,
      appId: FcmConfig.appId,
      messagingSenderId: FcmConfig.messagingSenderId,
      projectId: FcmConfig.projectId,
    ),
  );

  await NotificationService.instance.init();
  await _showFromRemoteMessage(message);
}

Future<void> showMessageFromRemoteData(Map<String, dynamic> data) async {
  final title = data['title'] as String? ?? 'EcoPulse';
  final body = data['body'] as String? ?? '';
  if (body.isEmpty) return;

  final threadId = data['threadId'] as String? ?? '';
  final id = threadId.isEmpty
      ? messageNotificationIdFromBody(body)
      : messageNotificationIdForThread(threadId);

  await NotificationService.instance.showMessageNotification(
    id: id,
    title: title,
    body: body,
    threadId: threadId.isEmpty ? null : threadId,
  );
}

Future<void> _showFromRemoteMessage(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null) {
    final threadId = message.data['threadId'] as String? ?? '';
    await NotificationService.instance.showMessageNotification(
      id: threadId.isEmpty
          ? messageNotificationIdFromBody(notification.body ?? '')
          : messageNotificationIdForThread(threadId),
      title: notification.title ?? 'EcoPulse',
      body: notification.body ?? '',
      threadId: threadId.isEmpty ? null : threadId,
    );
    return;
  }

  if (message.data.isNotEmpty) {
    await showMessageFromRemoteData(message.data);
  }
}

int messageNotificationIdForThread(String threadId) =>
    7000 + (threadId.hashCode.abs() % 9000);

int messageNotificationIdFromBody(String body) =>
    7000 + (body.hashCode.abs() % 9000);
