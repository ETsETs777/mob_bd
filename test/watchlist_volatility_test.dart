// =============================================================================
// EcoPulse · test/watchlist_volatility_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: watchlist_volatility.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/watchlist_volatility.dart';
import 'package:ecopulse/data/models/market_asset.dart';

MarketAsset _asset({
  required String id,
  required List<double> sparkline,
}) {
  return MarketAsset(
    id: id,
    symbol: id,
    name: id,
    type: AssetType.stockRu,
    price: sparkline.last,
    currency: 'RUB',
    changePercent: 1,
    sparkline: sparkline,
  );
}

void main() {
  test('dailyVolatilityPercent returns null for flat prices', () {
    expect(dailyVolatilityPercent([100, 100, 100]), isNull);
  });

  test('annualized volatility exceeds daily', () {
    const daily = 1.5;
    expect(
      annualizedVolatilityPercent(daily),
      greaterThan(daily),
    );
  });

  test('buildWatchlistVolatilityHeatmap sorts by annual vol desc', () {
    final calm = _asset(id: 'CALM', sparkline: [100, 101, 100, 101, 100]);
    final wild = _asset(
      id: 'WILD',
      sparkline: [100, 110, 95, 115, 90, 120],
    );

    final snapshot = buildWatchlistVolatilityHeatmap([calm, wild]);

    expect(snapshot.cells.length, 2);
    expect(snapshot.cells.first.asset.symbol, 'WILD');
    expect(snapshot.maxAnnualVol, greaterThan(snapshot.minAnnualVol));
  });

  test('volatilityHeatFactor normalizes within range', () {
    expect(volatilityHeatFactor(5, 5, 15), 0);
    expect(volatilityHeatFactor(15, 5, 15), 1);
    expect(volatilityHeatFactor(10, 5, 15), closeTo(0.5, 0.01));
  });
}
