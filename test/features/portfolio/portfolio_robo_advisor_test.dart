// =============================================================================
// EcoPulse · test/features/portfolio/portfolio_robo_advisor_test.dart
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_robo_advisor.dart';
import 'package:ecopulse/core/utils/portfolio_rebalance.dart';
import 'package:ecopulse/data/models/commodity_quote.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/paper_portfolio_account.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';
import 'package:ecopulse/data/models/savings_goal.dart';

PortfolioSnapshot _snapshot({
  required double cashRub,
  required List<PortfolioPosition> positions,
  required double holdingsValue,
}) {
  return PortfolioSnapshot(
    portfolio: PaperPortfolio(cashRub: cashRub, positions: positions),
    totalValueRub: cashRub + holdingsValue,
    investedRub: holdingsValue,
    pnlRub: 0,
    pnlPercent: 0,
    positions: positions
        .map(
          (p) => PositionSnapshot(
            position: p,
            currentPrice: p.buyPrice,
            valueRub: holdingsValue / positions.length,
            costRub: p.costRub,
            pnlRub: 0,
            pnlPercent: 0,
          ),
        )
        .toList(),
  );
}

void main() {
  test('IIS account recommends conservative preset', () {
    final preset = recommendRoboPreset(
      accountKind: PaperPortfolioKind.iis,
      goals: const [],
      activeAccountId: 'main',
      snapshot: _snapshot(
        cashRub: 20000,
        holdingsValue: 80000,
        positions: [
          PortfolioPosition(
            assetKey: 'stockRu:SBER',
            symbol: 'SBER',
            type: AssetType.stockRu,
            quantity: 10,
            buyPrice: 250,
            currency: 'RUB',
            costRub: 2500,
            boughtAt: DateTime(2026, 1, 1),
          ),
        ],
      ),
    );

    expect(preset, RebalancePreset.conservative);
  });

  test('short-term goal lowers risk score', () {
    final preset = recommendRoboPreset(
      accountKind: PaperPortfolioKind.main,
      goals: [
        SavingsGoal(
          id: '1',
          title: 'Car',
          targetRub: 500000,
          deadline: DateTime.now().add(const Duration(days: 180)),
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
      activeAccountId: 'main',
      snapshot: _snapshot(
        cashRub: 50000,
        holdingsValue: 50000,
        positions: [
          PortfolioPosition(
            assetKey: 'stockRu:GAZP',
            symbol: 'GAZP',
            type: AssetType.stockRu,
            quantity: 10,
            buyPrice: 150,
            currency: 'RUB',
            costRub: 1500,
            boughtAt: DateTime(2026, 1, 1),
          ),
        ],
      ),
    );

    expect(preset, RebalancePreset.conservative);
  });

  test('buildRoboAdvisorAdvice returns top rebalance actions', () {
    final advice = buildRoboAdvisorAdvice(
      accountKind: PaperPortfolioKind.crypto,
      goals: const [],
      activeAccountId: 'main',
      fearGreed: FearGreedIndex(
        value: 80,
        label: 'Greed',
        updatedAt: DateTime.utc(2026, 6, 28),
      ),
      snapshot: _snapshot(
        cashRub: 10000,
        holdingsValue: 90000,
        positions: [
          PortfolioPosition(
            assetKey: 'crypto:btc',
            symbol: 'BTC',
            type: AssetType.crypto,
            quantity: 1,
            buyPrice: 50000,
            currency: 'USD',
            costRub: 90000,
            boughtAt: DateTime(2026, 1, 1),
          ),
        ],
      ),
    );

    expect(advice.topActions, isNotEmpty);
    expect(advice.rationaleKeys, isNotEmpty);
  });
}
