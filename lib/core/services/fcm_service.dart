import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../cloud/fcm_config.dart';
import 'fcm_background.dart';

typedef FcmTokenCallback = Future<void> Function(String token);

/// Инициализация Firebase Messaging (опционально, через dart-define).
class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<String>? _tokenSub;
  FcmTokenCallback? _onToken;

  bool _initialized = false;
  String _token = '';

  bool get isAvailable => FcmConfig.isConfigured && _initialized;
  String get token => _token;

  Future<void> init({FcmTokenCallback? onTokenRefreshed}) async {
    if (!FcmConfig.isConfigured || kIsWeb) return;
    if (_initialized) return;

    _onToken = onTokenRefreshed;

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: FcmConfig.apiKey,
        appId: FcmConfig.appId,
        messagingSenderId: FcmConfig.messagingSenderId,
        projectId: FcmConfig.projectId,
      ),
    );

    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    await _messaging.requestPermission();

    _token = await _messaging.getToken() ?? '';
    if (_token.isNotEmpty && _onToken != null) {
      await _onToken!(_token);
    }

    _tokenSub = _messaging.onTokenRefresh.listen((token) async {
      _token = token;
      if (_onToken != null) await _onToken!(token);
    });

    FirebaseMessaging.onMessage.listen((message) async {
      await showMessageFromRemoteData({
        ...message.data,
        if (message.notification?.title != null)
          'title': message.notification!.title!,
        if (message.notification?.body != null)
          'body': message.notification!.body!,
      });
    });

    _initialized = true;
  }

  Future<void> dispose() async {
    await _tokenSub?.cancel();
    _tokenSub = null;
  }
}
