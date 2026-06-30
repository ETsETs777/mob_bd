import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../cloud/fcm_config.dart';
import 'fcm_remote_handler.dart';
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
  await handleFcmRemoteData(data);
}

Future<void> _showFromRemoteMessage(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    await handleFcmRemoteData(message.data);
    return;
  }

  final notification = message.notification;
  if (notification != null) {
    await handleFcmRemoteData({
      'title': notification.title ?? 'EcoPulse',
      'body': notification.body ?? '',
    });
  }
}
