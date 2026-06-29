import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/pro/pro_limits.dart';
import 'package:ecopulse/core/utils/live_crypto_utils.dart';
import 'package:ecopulse/data/models/market_asset.dart';

void main() {
  test('parseBinanceMiniTicker extracts BTC price', () {
    final tick = parseBinanceMiniTicker({
      'stream': 'btcusdt@miniTicker',
      'data': {
        'e': '24hrMiniTicker',
        's': 'BTCUSDT',
        'c': '65000.12',
        'P': '2.5',
      },
    });
    expect(tick, isNotNull);
    expect(tick!.symbol, 'BTC');
    expect(tick.price, 65000.12);
    expect(tick.changePercent24h, 2.5);
  });

  test('applyLiveCryptoPrices updates matching assets', () {
    const btc = MarketAsset(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 60000,
      changePercent: 1,
      type: AssetType.crypto,
    );
    const eth = MarketAsset(
      id: 'ethereum',
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3000,
      changePercent: -1,
      type: AssetType.crypto,
    );

    final updated = applyLiveCryptoPrices(
      const [btc, eth],
      {
        'BTC': LiveCryptoTick(
          symbol: 'BTC',
          price: 61000,
          changePercent24h: 3,
          updatedAt: DateTime.utc(2026, 6, 28),
        ),
      },
    );

    expect(updated[0].price, 61000);
    expect(updated[0].changePercent, 3);
    expect(updated[1].price, 3000);
  });

  test('ProLimits caps free alerts at 5', () {
    expect(ProLimits.canAddAlert(isPro: false, currentCount: 4), isTrue);
    expect(ProLimits.canAddAlert(isPro: false, currentCount: 5), isFalse);
    expect(ProLimits.canAddAlert(isPro: true, currentCount: 100), isTrue);
  });
}
