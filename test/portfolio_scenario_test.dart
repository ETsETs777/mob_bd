// =============================================================================
// EcoPulse · test/portfolio_scenario_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: portfolio_scenario.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_math.dart';
import 'package:ecopulse/core/utils/portfolio_scenario.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

PortfolioSnapshot _snapshot({
  required PaperPortfolio portfolio,
  required double total,
}) {
  return PortfolioSnapshot(
    portfolio: portfolio,
    totalValueRub: total,
    investedRub: total,
    pnlRub: 0,
    pnlPercent: 0,
    positions: portfolio.positions
        .map(
          (p) => PositionSnapshot(
            position: p,
            currentPrice: p.buyPrice,
            valueRub: p.costRub,
            costRub: p.costRub,
            pnlRub: 0,
            pnlPercent: 0,
          ),
        )
        .toList(),
  );
}

void main() {
  test('usdRub shock increases USD-denominated holdings in RUB', () {
    const usdRub = 100.0;
    final btc = MarketAsset(
      id: 'btc',
      symbol: 'BTC',
      name: 'Bitcoin',
      type: AssetType.crypto,
      price: 50000,
      currency: 'USD',
      changePercent: 0,
    );
    final portfolio = PaperPortfolio(
      cashRub: 0,
      positions: [
        PortfolioPosition(
          assetKey: 'crypto:btc',
          symbol: 'BTC',
          type: AssetType.crypto,
          quantity: 0.1,
          buyPrice: 50000,
          currency: 'USD',
          costRub: 5000,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final base = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: [btc],
      usdRubRate: usdRub,
    );

    final result = simulatePortfolioScenario(
      baseSnapshot: base,
      allAssets: [btc],
      usdRubRate: usdRub,
      shocks: PortfolioScenarioShocks.forPreset(
        PortfolioScenarioPreset.usdRubUp10,
      ),
    );

    expect(result.scenarioTotalRub, closeTo(base.totalValueRub * 1.10, 0.01));
    expect(result.deltaRub, closeTo(base.totalValueRub * 0.10, 0.01));
  });

  test('btc shock reduces crypto value', () {
    final btc = MarketAsset(
      id: 'btc',
      symbol: 'BTC',
      name: 'Bitcoin',
      type: AssetType.crypto,
      price: 50000,
      currency: 'USD',
      changePercent: 0,
    );
    final portfolio = PaperPortfolio(
      cashRub: 50000,
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
    final base = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: [btc],
      usdRubRate: 90,
    );

    final result = simulatePortfolioScenario(
      baseSnapshot: base,
      allAssets: [btc],
      usdRubRate: 90,
      shocks: PortfolioScenarioShocks.forPreset(
        PortfolioScenarioPreset.btcDown30,
      ),
    );

    expect(result.scenarioTotalRub, lessThan(result.baseTotalRub));
    expect(result.classDeltaRub['crypto'], lessThan(0));
  });

  test('imoex shock hits RU stocks only', () {
    final sber = MarketAsset(
      id: 'SBER',
      symbol: 'SBER',
      name: 'Sberbank',
      type: AssetType.stockRu,
      price: 300,
      currency: 'RUB',
      changePercent: 0,
    );
    final portfolio = PaperPortfolio(
      cashRub: 70000,
      positions: [
        PortfolioPosition(
          assetKey: 'stockRu:SBER',
          symbol: 'SBER',
          type: AssetType.stockRu,
          quantity: 100,
          buyPrice: 300,
          currency: 'RUB',
          costRub: 30000,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final base = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: [sber],
      usdRubRate: 90,
    );

    final result = simulatePortfolioScenario(
      baseSnapshot: base,
      allAssets: [sber],
      usdRubRate: 90,
      shocks: PortfolioScenarioShocks.forPreset(
        PortfolioScenarioPreset.imoexDown15,
      ),
    );

    expect(result.classDeltaRub['stocks'], closeTo(-4500, 1));
    expect(result.classDeltaRub['cash'], 0);
  });
}
