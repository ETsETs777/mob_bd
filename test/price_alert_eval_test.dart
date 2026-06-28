// =============================================================================
// EcoPulse · test/price_alert_eval_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: price_alert_eval.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/price_alert_eval.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/price_alert.dart';

MarketAsset _crypto(String symbol, {required double change}) {
  return MarketAsset(
    id: symbol.toLowerCase(),
    symbol: symbol,
    name: symbol,
    type: AssetType.crypto,
    price: 100,
    currency: 'USD',
    changePercent: change,
  );
}

void main() {
  test('isInAlertQuietHours handles overnight window', () {
    const settings = AlertQuietHoursSettings(
      enabled: true,
      startHour: 23,
      endHour: 8,
    );
    expect(
      isInAlertQuietHours(settings, DateTime(2026, 6, 28, 2)),
      isTrue,
    );
    expect(
      isInAlertQuietHours(settings, DateTime(2026, 6, 28, 12)),
      isFalse,
    );
  });

  test('percent alert triggers on signed daily change', () {
    const riseAlert = PriceAlert(
      id: '1',
      symbol: PriceAlertSymbol.btc,
      condition: AlertCondition.above,
      threshold: 5,
      kind: AlertKind.percentChange,
    );
    const dropAlert = PriceAlert(
      id: '2',
      symbol: PriceAlertSymbol.btc,
      condition: AlertCondition.below,
      threshold: 5,
      kind: AlertKind.percentChange,
    );

    final crypto = [_crypto('BTC', change: 6)];

    expect(isPriceAlertTriggered(riseAlert, null, crypto, null), isTrue);
    expect(
      isPriceAlertTriggered(dropAlert, null, [_crypto('BTC', change: -6)], null),
      isTrue,
    );
    expect(
      isPriceAlertTriggered(dropAlert, null, [_crypto('BTC', change: 6)], null),
      isFalse,
    );
  });
}
