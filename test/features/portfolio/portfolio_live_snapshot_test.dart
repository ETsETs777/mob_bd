// =============================================================================
// EcoPulse · test/features/portfolio/portfolio_live_snapshot_test.dart
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/live_crypto_utils.dart';
import 'package:ecopulse/core/utils/portfolio_math.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

MarketAsset _btc({required double price}) => MarketAsset(
      id: 'btc',
      symbol: 'BTC',
      name: 'Bitcoin',
      type: AssetType.crypto,
      price: price,
      changePercent: 0,
      currency: 'USD',
    );

void main() {
  test('live crypto tick increases portfolio total value', () {
    final portfolio = PaperPortfolio(
      initialCapitalRub: 1_000_000,
      cashRub: 100_000,
      positions: [
        PortfolioPosition(
          assetKey: 'crypto:btc',
          symbol: 'BTC',
          type: AssetType.crypto,
          quantity: 1,
          buyPrice: 50000,
          currency: 'USD',
          costRub: 4_500_000,
          boughtAt: DateTime(2026, 6, 1),
        ),
      ],
    );

    const usdRub = 90.0;
    final baseAssets = [_btc(price: 50000)];
    final liveAssets = applyLiveCryptoPrices(
      baseAssets,
      {
        'BTC': LiveCryptoTick(
          symbol: 'BTC',
          price: 52000,
          changePercent24h: 4,
          updatedAt: DateTime.utc(2026, 6, 28, 12),
        ),
      },
    );

    final before = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: baseAssets,
      usdRubRate: usdRub,
    );
    final after = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: liveAssets,
      usdRubRate: usdRub,
    );

    expect(after.totalValueRub, greaterThan(before.totalValueRub));
    expect(after.positions.first.currentPrice, 52000);
  });
}
