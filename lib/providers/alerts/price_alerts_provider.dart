import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/pro/pro_limits.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/price_alert_eval.dart';
import '../../data/models/price_alert.dart';
import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/alerts/alert_history_provider.dart';
import 'package:ecopulse/providers/alerts/alert_quiet_hours_provider.dart';
import 'package:ecopulse/providers/app/app_providers.dart';
import 'package:ecopulse/providers/app/locale_provider.dart';

/// Riverpod-провайдер [priceAlertsProvider].
final priceAlertsProvider =
    NotifierProvider<PriceAlertsNotifier, List<PriceAlert>>(
  PriceAlertsNotifier.new,
);

class PriceAlertsNotifier extends Notifier<List<PriceAlert>> {
  static const cacheKey = 'price_alerts';

  @override
  List<PriceAlert> build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => PriceAlert.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> add(PriceAlert alert, {required bool isPro}) async {
    if (!ProLimits.canAddAlert(isPro: isPro, currentCount: state.length)) {
      return false;
    }
    state = [...state, alert];
    await _persist();
    return true;
  }

  Future<void> remove(String id) async {
    state = state.where((a) => a.id != id).toList();
    await _persist();
  }

  Future<void> toggleEnabled(String id) async {
    state = state
        .map(
          (a) => a.id == id
              ? a.copyWith(
                  enabled: !a.enabled,
                  clearLastNotified: !a.enabled,
                )
              : a,
        )
        .toList();
    await _persist();
  }

  Future<void> markNotified(String id) async {
    state = state
        .map(
          (a) => a.id == id
              ? a.copyWith(lastNotifiedAt: DateTime.now())
              : a,
        )
        .toList();
    await _persist();
  }

  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.map((a) => a.toJson()).toList()),
    );
  }
}

/// Проверяет алерты и отправляет push (если не тихие часы).
Future<void> evaluatePriceAlerts(WidgetRef ref) async {
  final alerts = ref.read(priceAlertsProvider);
  if (alerts.isEmpty) return;

  final quiet = ref.read(alertQuietHoursProvider);
  if (isInAlertQuietHours(quiet)) return;

  final rates = ref.read(currencyRatesProvider).valueOrNull;
  final crypto = ref.read(cryptoProvider).valueOrNull?.assets;
  final stocks = ref.read(stocksProvider).valueOrNull;
  final notifier = ref.read(priceAlertsProvider.notifier);
  final history = ref.read(alertHistoryProvider.notifier);
  final isRu = ref.read(localeProvider).code == 'ru';

  for (final alert in alerts.where((a) => a.enabled)) {
    if (isAlertInCooldown(alert)) continue;
    if (!isPriceAlertTriggered(alert, rates, crypto, stocks)) continue;

    final body = formatPriceAlertBody(
      alert,
      rates,
      crypto,
      stocks,
      isRu: isRu,
    );
    await NotificationService.instance.showPriceAlert(
      id: alert.id.hashCode,
      title: 'EcoPulse · ${alert.symbol.label}',
      body: body,
    );
    await history.add(
      alertId: alert.id,
      symbol: alert.symbol.label,
      message: body,
    );
    await notifier.markNotified(alert.id);
  }
}
