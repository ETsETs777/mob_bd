// =============================================================================
// EcoPulse · lib/core/services/notification_service.dart
// Автор: Цымбал Е. В.
// Дата: 26.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: notification_service.
// =============================================================================

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../navigation/notification_navigator.dart';

/// Сервис [NotificationService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
class NotificationService {
/// Создаёт [NotificationService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  NotificationService._();

/// Поле [instance] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static final NotificationService instance = NotificationService._();

/// Поле [_plugin] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

/// Поле [_initialized] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  bool _initialized = false;

/// Метод [init] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        navigateFromNotificationPayload(response.payload);
      },
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

/// Метод [showPriceAlert] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  Future<void> showPriceAlert({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_price_alerts',
        'Price Alerts',
        channelDescription: 'EcoPulse price threshold notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, details);
  }

/// Метод [showMorningDigest] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  Future<void> showMorningDigest({
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_morning_digest',
        'Morning Digest',
        channelDescription: 'EcoPulse morning market summary',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(9001, title, body, details);
  }

/// Метод [showBondEvent] класса [NotificationService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  Future<void> showBondEvent({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_bond_events',
        'Bond Events',
        channelDescription: 'Coupon and maturity reminders for tracked bonds',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, details);
  }

  Future<void> showMessageNotification({
    required int id,
    required String title,
    required String body,
    String? threadId,
  }) async {
    if (!_initialized) await init();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_messages',
        'Messages',
        channelDescription: 'New chat messages from EcoPulse home server',
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.message,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final payload = threadId != null && threadId.isNotEmpty
        ? 'thread:$threadId'
        : null;
    await _plugin.show(id, title, body, details, payload: payload);
  }

  Future<void> showArticleStatus({
    required int id,
    required String title,
    required String body,
    String? articleId,
  }) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_articles',
        'Articles',
        channelDescription: 'Article moderation status updates',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final payload =
        articleId != null && articleId.isNotEmpty ? 'article:$articleId' : null;
    await _plugin.show(id, title, body, details, payload: payload);
  }

  Future<void> showArticleModeration({
    required int id,
    required String title,
    required String body,
    String? articleId,
  }) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_article_moderation',
        'Article moderation',
        channelDescription: 'New articles waiting for admin review',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final payload = articleId != null && articleId.isNotEmpty
        ? 'article:$articleId'
        : 'community:articles';
    await _plugin.show(id, title, body, details, payload: payload);
  }

  Future<void> scheduleCalendarReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledAt,
    String? eventId,
  }) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ecopulse_calendar_reminders',
        'Calendar reminders',
        channelDescription: 'Reminders before personal calendar events',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final payload = eventId != null && eventId.isNotEmpty
        ? 'calendar:$eventId'
        : 'calendar:';

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledAt,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    if (!_initialized) await init();
    await _plugin.cancel(id);
  }
}
