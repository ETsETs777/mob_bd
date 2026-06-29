import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/constants/api_keys_store.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/morning_digest_service.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/price_alert.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/repositories/market_repository.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/retry_interceptor.dart';
import '../../providers/morning_digest_provider.dart';
import '../../core/utils/price_alert_eval.dart';
import '../../providers/alert_quiet_hours_provider.dart';
import '../../providers/price_alerts_provider.dart';

/// Top-level переменная [backgroundAlertTaskName].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
const backgroundAlertTaskName = 'ecopulse_price_alert_check';

/// Сервис [BackgroundAlertService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
class BackgroundAlertService {
/// Создаёт [BackgroundAlertService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  BackgroundAlertService._();

/// Поле [instance] класса [BackgroundAlertService].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static final instance = BackgroundAlertService._();

/// Метод [register] класса [BackgroundAlertService].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  Future<void> register(void Function() dispatcher) async {
    await Workmanager().initialize(dispatcher);
    await Workmanager().registerPeriodicTask(
      backgroundAlertTaskName,
      backgroundAlertTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    await Workmanager().registerPeriodicTask(
      messagePushBackgroundTaskName,
      messagePushBackgroundTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

/// Метод [runCheck] класса [BackgroundAlertService].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  static Future<bool> runCheck() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CacheService.instance.init();
    await NotificationService.instance.init();
    await ApiKeysStore.instance.loadFromCache(
      (key) async => CacheService.instance.getString(key),
    );

    final alerts = _loadAlerts();
    if (alerts.isEmpty) return true;

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    )..interceptors.add(RetryInterceptor());

    final cache = CacheService.instance;
    final currencyRepo = CurrencyRepository(dio, cache);
    final marketRepo = MarketRepository(dio, cache);

    List<CurrencyRate>? rates;
    List<MarketAsset>? crypto;
    List<MarketAsset>? stocks;

    try {
      rates = await currencyRepo.fetchRates(force: true);
    } catch (_) {
      try {
        rates = await currencyRepo.fetchRates(force: false);
      } catch (_) {}
    }

    try {
      crypto = await marketRepo.fetchCrypto(force: true);
    } catch (_) {
      try {
        crypto = await marketRepo.fetchCrypto(force: false);
      } catch (_) {}
    }

    try {
      stocks = await marketRepo.fetchStocks(force: true);
    } catch (_) {
      try {
        stocks = await marketRepo.fetchStocks(force: false);
      } catch (_) {}
    }

    final updated = await evaluateAlertsInBackground(
      alerts: alerts,
      rates: rates,
      crypto: crypto,
      stocks: stocks,
    );

    await CacheService.instance.putString(
      PriceAlertsNotifier.cacheKey,
      jsonEncode(updated.map((a) => a.toJson()).toList()),
    );

    await BackgroundAlertService.runBackgroundCheck(
      rates: rates,
      crypto: crypto,
    );

    return true;
  }

/// Метод [runBackgroundCheck] класса [BackgroundAlertService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static Future<void> runBackgroundCheck({
    List<CurrencyRate>? rates,
    List<MarketAsset>? crypto,
  }) async {
    final cache = CacheService.instance;
    final enabled = cache.getString(MorningDigestNotifier.enabledKey) == '1';
    if (!enabled) return;

    final hourRaw =
        int.tryParse(cache.getString(MorningDigestNotifier.hourKey) ?? '') ?? 8;
    final settings = MorningDigestSettings(
      enabled: true,
      hour: hourRaw.clamp(6, 11),
    );

    await MorningDigestService.instance.maybeSend(
      cache: cache,
      settings: settings,
      rates: rates,
      crypto: crypto,
    );
  }

/// Приватный метод [_loadAlerts] класса [BackgroundAlertService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  static List<PriceAlert> _loadAlerts() {
    final raw = CacheService.instance.getString(PriceAlertsNotifier.cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => PriceAlert.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

/// Функция [evaluateAlertsInBackground] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
Future<List<PriceAlert>> evaluateAlertsInBackground({
  required List<PriceAlert> alerts,
  required List<CurrencyRate>? rates,
  required List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
}) async {
  final quietRaw = CacheService.instance.getString(AlertQuietHoursNotifier.cacheKey);
  AlertQuietHoursSettings quiet = const AlertQuietHoursSettings();
  if (quietRaw != null && quietRaw.isNotEmpty) {
    try {
      quiet = AlertQuietHoursSettings.fromJson(
        jsonDecode(quietRaw) as Map<String, dynamic>,
      );
    } catch (_) {}
  }
  if (isInAlertQuietHours(quiet)) return alerts;

  var result = alerts;

  for (final alert in alerts.where((a) => a.enabled)) {
    if (isAlertInCooldown(alert)) continue;

    if (!isPriceAlertTriggered(alert, rates, crypto, stocks)) continue;

    final body = formatPriceAlertBody(
      alert,
      rates,
      crypto,
      stocks,
      isRu: true,
    );

    await NotificationService.instance.showPriceAlert(
      id: alert.id.hashCode,
      title: 'EcoPulse · ${alert.symbol.label}',
      body: body,
    );

    result = result
        .map(
          (a) => a.id == alert.id
              ? a.copyWith(lastNotifiedAt: DateTime.now())
              : a,
        )
        .toList();
  }

  return result;
}
