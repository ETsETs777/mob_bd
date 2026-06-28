// =============================================================================
// EcoPulse · lib/providers/alert_quiet_hours_provider.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Тихие часы для price alerts.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/price_alert_eval.dart';
import '../data/services/cache_service.dart';

final alertQuietHoursProvider =
    NotifierProvider<AlertQuietHoursNotifier, AlertQuietHoursSettings>(
  AlertQuietHoursNotifier.new,
);

class AlertQuietHoursNotifier extends Notifier<AlertQuietHoursSettings> {
  static const cacheKey = 'alert_quiet_hours_v1';

  @override
  AlertQuietHoursSettings build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) {
      return const AlertQuietHoursSettings();
    }
    try {
      return AlertQuietHoursSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const AlertQuietHoursSettings();
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = AlertQuietHoursSettings(
      enabled: enabled,
      startHour: state.startHour,
      endHour: state.endHour,
    );
    await _persist();
  }

  Future<void> setHours({required int startHour, required int endHour}) async {
    state = AlertQuietHoursSettings(
      enabled: state.enabled,
      startHour: startHour.clamp(0, 23),
      endHour: endHour.clamp(0, 23),
    );
    await _persist();
  }

  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.toJson()),
    );
  }
}
