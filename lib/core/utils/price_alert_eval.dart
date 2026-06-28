// =============================================================================
// EcoPulse · lib/core/utils/price_alert_eval.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Оценка срабатывания price alerts: порог, % за день, тихие часы.
// =============================================================================

import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/price_alert.dart';

/// Настройки «тихих часов» — без push в заданном интервале.
class AlertQuietHoursSettings {
  const AlertQuietHoursSettings({
    this.enabled = false,
    this.startHour = 23,
    this.endHour = 8,
  });

  final bool enabled;
  final int startHour;
  final int endHour;

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'startHour': startHour,
        'endHour': endHour,
      };

  factory AlertQuietHoursSettings.fromJson(Map<String, dynamic> json) =>
      AlertQuietHoursSettings(
        enabled: json['enabled'] as bool? ?? false,
        startHour: (json['startHour'] as num?)?.toInt().clamp(0, 23) ?? 23,
        endHour: (json['endHour'] as num?)?.toInt().clamp(0, 23) ?? 8,
      );
}

/// Проверяет, попадает ли [now] в интервал тихих часов.
bool isInAlertQuietHours(AlertQuietHoursSettings settings, [DateTime? now]) {
  if (!settings.enabled) return false;
  final hour = (now ?? DateTime.now()).hour;
  final start = settings.startHour;
  final end = settings.endHour;
  if (start == end) return false;
  if (start < end) return hour >= start && hour < end;
  return hour >= start || hour < end;
}

double? resolveAlertPrice(
  PriceAlertSymbol symbol,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
) {
  switch (symbol) {
    case PriceAlertSymbol.usdRub:
      return rates?.where((r) => r.isRub && r.code == 'USD').firstOrNull?.rate;
    case PriceAlertSymbol.eurRub:
      return rates
          ?.where((r) => r.base == 'RUB' && r.code == 'EUR')
          .firstOrNull
          ?.rate;
    case PriceAlertSymbol.btc:
      return crypto?.where((a) => a.symbol == 'BTC').firstOrNull?.price;
    case PriceAlertSymbol.eth:
      return crypto?.where((a) => a.symbol == 'ETH').firstOrNull?.price;
    case PriceAlertSymbol.imoex:
      return stocks?.where((a) => a.symbol == 'IMOEX').firstOrNull?.price;
  }
}

double? resolveAlertChangePercent(
  PriceAlertSymbol symbol,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
) {
  switch (symbol) {
    case PriceAlertSymbol.usdRub:
      return rates?.where((r) => r.isRub && r.code == 'USD').firstOrNull?.changePercent;
    case PriceAlertSymbol.eurRub:
      return rates
          ?.where((r) => r.base == 'RUB' && r.code == 'EUR')
          .firstOrNull
          ?.changePercent;
    case PriceAlertSymbol.btc:
      return crypto?.where((a) => a.symbol == 'BTC').firstOrNull?.changePercent;
    case PriceAlertSymbol.eth:
      return crypto?.where((a) => a.symbol == 'ETH').firstOrNull?.changePercent;
    case PriceAlertSymbol.imoex:
      return stocks?.where((a) => a.symbol == 'IMOEX').firstOrNull?.changePercent;
  }
}

/// Срабатывает ли алерт по текущим котировкам.
bool isPriceAlertTriggered(
  PriceAlert alert,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
) {
  if (alert.isPercentChange) {
    return _percentTriggered(alert, rates, crypto, stocks);
  }
  return _thresholdTriggered(alert, rates, crypto, stocks);
}

bool _thresholdTriggered(
  PriceAlert alert,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
) {
  final price = resolveAlertPrice(alert.symbol, rates, crypto, stocks);
  if (price == null) return false;
  return alert.isAbove ? price >= alert.threshold : price <= alert.threshold;
}

bool _percentTriggered(
  PriceAlert alert,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
) {
  final change = resolveAlertChangePercent(alert.symbol, rates, crypto, stocks);
  if (change == null) return false;
  if (alert.isAbove) {
    return change >= alert.threshold;
  }
  return change <= -alert.threshold;
}

/// Текст уведомления (RU/EN через [isRu]).
String formatPriceAlertBody(
  PriceAlert alert,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks, {
  bool isRu = true,
}) {
  if (alert.isPercentChange) {
    final change =
        resolveAlertChangePercent(alert.symbol, rates, crypto, stocks);
    final delta = change?.toStringAsFixed(2) ?? '—';
    if (alert.isAbove) {
      return isRu
          ? 'Рост за день +$delta% (порог +${alert.threshold.toStringAsFixed(1)}%)'
          : 'Daily rise +$delta% (threshold +${alert.threshold.toStringAsFixed(1)}%)';
    }
    return isRu
        ? 'Падение за день $delta% (порог −${alert.threshold.toStringAsFixed(1)}%)'
        : 'Daily drop $delta% (threshold −${alert.threshold.toStringAsFixed(1)}%)';
  }
  final price = resolveAlertPrice(alert.symbol, rates, crypto, stocks);
  final cmp = alert.isAbove ? '≥' : '≤';
  return '${price?.toStringAsFixed(2) ?? '—'} $cmp ${alert.threshold.toStringAsFixed(2)}';
}

const alertCooldownHours = 6;

bool isAlertInCooldown(PriceAlert alert, {int cooldownHours = alertCooldownHours}) {
  final last = alert.lastNotifiedAt;
  if (last == null) return false;
  return DateTime.now().difference(last).inHours < cooldownHours;
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
