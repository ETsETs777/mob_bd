// =============================================================================
// EcoPulse · test/portfolio_export_test.dart
// Автор: Цымбал Е. В.
// Дата: 27.06.2026
// Unit/widget тест: portfolio_export_test.
// =============================================================================

import 'package:ecopulse/core/utils/portfolio_export.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
void main() {
  test('portfolioToCsv includes header and position row', () {
    final portfolio = PaperPortfolio(
      initialCapitalRub: 100000,
      cashRub: 90000,
      positions: [
        PortfolioPosition(
          assetKey: 'crypto:bitcoin',
          symbol: 'BTC',
          type: AssetType.crypto,
          quantity: 0.01,
          buyPrice: 60000,
          currency: 'USD',
          costRub: 54000,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    final snapshot = PortfolioSnapshot(
      portfolio: portfolio,
      totalValueRub: 100000,
      investedRub: 54000,
      pnlRub: 0,
      pnlPercent: 0,
      positions: [
        PositionSnapshot(
          position: portfolio.positions.first,
          currentPrice: 60000,
          valueRub: 54000,
          costRub: 54000,
          pnlRub: 0,
          pnlPercent: 0,
        ),
      ],
    );

    final csv = portfolioToCsv(snapshot);
    expect(csv, contains('symbol,type,quantity'));
    expect(csv, contains('BTC'));
    expect(csv, contains('CASH_RUB'));
  });
}
