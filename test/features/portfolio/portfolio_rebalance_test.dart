// =============================================================================
// EcoPulse · test/portfolio_rebalance_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: portfolio_rebalance.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_rebalance.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

void main() {
  test('PortfolioTargetAllocation presets sum to 100', () {
    for (final preset in RebalancePreset.values) {
      if (preset == RebalancePreset.custom) continue;
      final target = PortfolioTargetAllocation.forPreset(preset);
      final sum = portfolioAssetClasses.fold<double>(0, (s, k) => s + target[k]);
      expect(sum, closeTo(100, 0.01));
    }
  });

  test('computeRebalancePlan suggests buy and sell', () {
    final portfolio = PaperPortfolio(
      cashRub: 80000,
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
      ],
    );

    final snapshot = PortfolioSnapshot(
      portfolio: portfolio,
      totalValueRub: 530000,
      investedRub: 450000,
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
      ],
    );

    final plan = computeRebalancePlan(
      snapshot: snapshot,
      target: PortfolioTargetAllocation.forPreset(RebalancePreset.balanced),
    );

    expect(plan.needsRebalance, isTrue);
    final crypto = plan.suggestions.firstWhere((s) => s.assetClass == 'crypto');
    expect(crypto.action, RebalanceAction.sell);
    expect(crypto.deltaRub, lessThan(0));

    final cash = plan.suggestions.firstWhere((s) => s.assetClass == 'cash');
    expect(cash.action, RebalanceAction.sell);
    expect(cash.deltaRub, lessThan(0));

    final stocks = plan.suggestions.firstWhere((s) => s.assetClass == 'stocks');
    expect(stocks.action, RebalanceAction.buy);
  });

  test('computeRebalancePlan returns on-target when aligned', () {
    final portfolio = PaperPortfolio(
      cashRub: 10000,
      positions: [],
    );

    final snapshot = PortfolioSnapshot(
      portfolio: portfolio,
      totalValueRub: 10000,
      investedRub: 0,
      pnlRub: 0,
      pnlPercent: 0,
      positions: const [],
    );

    final plan = computeRebalancePlan(
      snapshot: snapshot,
      target: const PortfolioTargetAllocation({'cash': 100}),
    );

    expect(plan.needsRebalance, isFalse);
    expect(plan.suggestions.every((s) => s.action == RebalanceAction.hold), isTrue);
  });
}
