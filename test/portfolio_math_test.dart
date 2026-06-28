// =============================================================================
// EcoPulse · test/portfolio_math_test.dart
// Автор: Цымбал Е. В.
// Дата: 27.06.2026
// Unit/widget тест: portfolio_math_test.
// =============================================================================

import 'package:ecopulse/core/utils/portfolio_math.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
void main() {
  test('buildPortfolioSnapshot calculates PnL in RUB', () {
    final portfolio = PaperPortfolio(
      initialCapitalRub: 100000,
      cashRub: 90000,
      positions: [
        PortfolioPosition(
          assetKey: 'crypto:bitcoin',
          symbol: 'BTC',
          type: AssetType.crypto,
          quantity: 1,
          buyPrice: 10000,
          currency: 'USD',
          costRub: 10000,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    const btc = MarketAsset(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 11000,
      changePercent: 10,
      type: AssetType.crypto,
    );

    final snap = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: [btc],
      usdRubRate: 90,
    );

    expect(snap.totalValueRub, closeTo(90000 + 11000 * 90, 1));
    expect(snap.pnlRub, greaterThan(0));
  });
}
