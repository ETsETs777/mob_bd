// =============================================================================
// EcoPulse · lib/core/services/background_alert_worker.dart
// Автор: Цымбал Е. В.
// Дата: 28.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: background_alert_worker.
// =============================================================================

import 'package:workmanager/workmanager.dart';

import 'background_alert_service.dart';

/// Функция [backgroundAlertDispatcher] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
@pragma('vm:entry-point')
void backgroundAlertDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == backgroundAlertTaskName) {
      return BackgroundAlertService.runCheck();
    }
    return false;
  });
}
