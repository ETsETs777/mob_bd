/// Firebase Cloud Messaging (compile-time через --dart-define).
abstract final class FcmConfig {
  static const projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static const appId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '',
  );

  static const apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );

  static bool get isConfigured =>
      projectId.isNotEmpty &&
      appId.isNotEmpty &&
      apiKey.isNotEmpty &&
      messagingSenderId.isNotEmpty;
}
