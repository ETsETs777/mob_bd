// =============================================================================
// EcoPulse · test/portfolio_allocation_test.dart
// Автор: Цымбал Е. В.
// Дата: 26.06.2026
// Unit/widget тест: portfolio_allocation_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_math.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 27.06.2026
void main() {
  test('buildPortfolioAllocation splits by asset class', () {
    final portfolio = PaperPortfolio(
      cashRub: 20000,
      positions: [
        PortfolioPosition(
          assetKey: 'crypto:btc',
          symbol: 'BTC',
          type: AssetType.crypto,
          quantity: 0.1,
          buyPrice: 50000,
          currency: 'USD',
          costRub: 450000,
          boughtAt: DateTime(2026, 1, 1),
        ),
        PortfolioPosition(
          assetKey: 'bondRu:SU26238',
          symbol: 'SU26238',
          type: AssetType.bondRu,
          quantity: 10,
          buyPrice: 95,
          currency: 'RUB',
          costRub: 9500,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    final snapshot = PortfolioSnapshot(
      portfolio: portfolio,
      totalValueRub: 500000,
      investedRub: 459500,
      pnlRub: 0,
      pnlPercent: 0,
      positions: [
        PositionSnapshot(
          position: portfolio.positions[0],
          currentPrice: 50000,
          valueRub: 450000,
          costRub: 450000,
          pnlRub: 0,
          pnlPercent: 0,
        ),
        PositionSnapshot(
          position: portfolio.positions[1],
          currentPrice: 95,
          valueRub: 9500,
          costRub: 9500,
          pnlRub: 0,
          pnlPercent: 0,
        ),
      ],
    );

    final slices = buildPortfolioAllocation(snapshot);
    expect(slices.length, 3);
    expect(slices.any((s) => s.key == 'cash' && s.valueRub == 20000), true);
    expect(slices.any((s) => s.key == 'crypto' && s.valueRub == 450000), true);
    expect(slices.any((s) => s.key == 'bonds' && s.valueRub == 9500), true);
  });
}
