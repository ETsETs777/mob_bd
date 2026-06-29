// =============================================================================
// EcoPulse · test/portfolio_real_return_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: portfolio_real_return.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_real_return.dart';
import 'package:ecopulse/data/models/inflation_point.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';
import 'package:ecopulse/core/utils/portfolio_math.dart';

InflationPoint _ruInflation({double value = 8.0}) {
  return InflationPoint(
    countryCode: 'RU',
    countryName: 'Russia',
    year: 2025,
    value: value,
    history: const [
      YearValue(year: 2024, value: 7.0),
      YearValue(year: 2025, value: 8.0),
    ],
  );
}

MarketAsset _stock({
  required String id,
  required List<double> sparkline,
  double price = 100,
}) {
  return MarketAsset(
    id: id,
    symbol: id,
    name: id,
    type: AssetType.stockRu,
    price: price,
    currency: 'RUB',
    changePercent: 5,
    sparkline: sparkline,
  );
}

void main() {
  test('proRatedInflationPercent scales annual CPI to days', () {
    expect(proRatedInflationPercent(8, 30), closeTo(0.6575, 0.01));
  });

  test('accumulatedInflationPercent compounds yearly CPI', () {
    final from = DateTime(2024, 6, 1);
    final to = DateTime(2025, 6, 1);
    final pct = accumulatedInflationPercent(
      from: from,
      to: to,
      history: _ruInflation().history,
    );
    expect(pct, greaterThan(7));
    expect(pct, lessThan(16));
  });

  test('buildPortfolioRealReturnComparison subtracts inflation from nominal', () {
    final portfolio = PaperPortfolio(
      cashRub: 50000,
      initialCapitalRub: 100000,
      positions: [
        PortfolioPosition(
          assetKey: 'stockRu:SBER',
          symbol: 'SBER',
          type: AssetType.stockRu,
          quantity: 100,
          buyPrice: 250,
          currency: 'RUB',
          costRub: 25000,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final sber = _stock(
      id: 'SBER',
      sparkline: [240, 250, 260],
      price: 260,
    );
    final imoex = _stock(
      id: 'IMOEX',
      sparkline: [3000, 3100, 3050],
      price: 3050,
    );
    final snapshot = buildPortfolioSnapshot(
      portfolio: portfolio,
      allAssets: [sber, imoex],
      usdRubRate: 90,
    );

    final result = buildPortfolioRealReturnComparison(
      snapshot: snapshot,
      assets: [sber, imoex],
      usdRubRate: 90,
      horizon: RealReturnHorizon.days30,
      inflation: [_ruInflation()],
      keyRatePercent: 21,
      asOf: DateTime(2026, 6, 28),
    );

    expect(result, isNotNull);
    expect(
      result!.portfolioRealPercent,
      closeTo(result.portfolioNominalPercent - result.inflationPercent, 0.01),
    );
    expect(result.imoexPercent, isNotNull);
    expect(result.depositPercent, isNotNull);
    expect(result.rows.length, greaterThanOrEqualTo(4));
  });
}
