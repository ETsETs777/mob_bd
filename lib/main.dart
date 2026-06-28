// =============================================================================
// EcoPulse · lib/main.dart
// Автор: Цымбал Е. В.
// Дата: 28.04.2026
// Точка входа: инициализация Hive, уведомлений, API-ключей, запуск ProviderScope.
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/constants/api_keys_store.dart';
import 'core/services/background_alert_service.dart';
import 'core/services/background_alert_worker.dart';
import 'core/services/error_reporting_service.dart';
import 'core/services/notification_service.dart';
import 'data/services/cache_service.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorReportingService.instance.install();
  await CacheService.instance.init();  await NotificationService.instance.init();
  if (!kIsWeb) {
    await BackgroundAlertService.instance.register(backgroundAlertDispatcher);
  }
  await ApiKeysStore.instance.loadFromCache(
    (key) async => CacheService.instance.getString(key),
  );
  runApp(const ProviderScope(child: EcoPulseApp()));
}
