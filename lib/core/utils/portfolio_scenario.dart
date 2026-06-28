// =============================================================================
// EcoPulse · lib/core/utils/portfolio_scenario.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Сценарный стресс-тест бумажного портфеля («что если»).
// =============================================================================

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import 'portfolio_math.dart';

/// Пресеты макро-сценариев для портфеля.
enum PortfolioScenarioPreset {
  usdRubUp10,
  btcDown30,
  imoexDown15,
  keyRateUp2,
}

/// Шоки цен / курса в процентах (+10 = рост на 10%).
class PortfolioScenarioShocks {
  const PortfolioScenarioShocks({
    this.usdRubPercent = 0,
    this.cryptoPercent = 0,
    this.stockRuPercent = 0,
    this.stockUsPercent = 0,
    this.bondRuPercent = 0,
  });

  final double usdRubPercent;
  final double cryptoPercent;
  final double stockRuPercent;
  final double stockUsPercent;
  final double bondRuPercent;

  static PortfolioScenarioShocks forPreset(PortfolioScenarioPreset preset) =>
      switch (preset) {
        PortfolioScenarioPreset.usdRubUp10 =>
          const PortfolioScenarioShocks(usdRubPercent: 10),
        PortfolioScenarioPreset.btcDown30 =>
          const PortfolioScenarioShocks(cryptoPercent: -30),
        PortfolioScenarioPreset.imoexDown15 =>
          const PortfolioScenarioShocks(stockRuPercent: -15),
        PortfolioScenarioPreset.keyRateUp2 =>
          const PortfolioScenarioShocks(bondRuPercent: -8),
      };
}

/// Результат сценарного пересчёта портфеля.
class PortfolioScenarioResult {
  const PortfolioScenarioResult({
    required this.baseTotalRub,
    required this.scenarioTotalRub,
    required this.deltaRub,
    required this.deltaPercent,
    required this.classDeltaRub,
    required this.shocks,
  });

  final double baseTotalRub;
  final double scenarioTotalRub;
  final double deltaRub;
  final double deltaPercent;
  final Map<String, double> classDeltaRub;
  final PortfolioScenarioShocks shocks;
}

/// Применяет процентный шок к цене актива по классу.
MarketAsset applyAssetShock(MarketAsset asset, PortfolioScenarioShocks shocks) {
  final pct = switch (asset.type) {
    AssetType.crypto => shocks.cryptoPercent,
    AssetType.stockUs => shocks.stockUsPercent,
    AssetType.stockRu => shocks.stockRuPercent,
    AssetType.bondRu => shocks.bondRuPercent,
  };
  if (pct == 0) return asset;
  return MarketAsset(
    id: asset.id,
    symbol: asset.symbol,
    name: asset.name,
    price: asset.price * (1 + pct / 100),
    changePercent: asset.changePercent,
    type: asset.type,
    sparkline: asset.sparkline,
    currency: asset.currency,
    imageUrl: asset.imageUrl,
    yieldPercent: asset.yieldPercent,
    couponPercent: asset.couponPercent,
    maturityDate: asset.maturityDate,
    bondCategory: asset.bondCategory,
    faceValue: asset.faceValue,
    nextCouponDate: asset.nextCouponDate,
    couponValueRub: asset.couponValueRub,
    couponPeriodDays: asset.couponPeriodDays,
  );
}

/// Пересчитывает стоимость портфеля при заданных шоках.
PortfolioScenarioResult simulatePortfolioScenario({
  required PortfolioSnapshot baseSnapshot,
  required List<MarketAsset> allAssets,
  required double usdRubRate,
  required PortfolioScenarioShocks shocks,
}) {
  final shockedAssets =
      allAssets.map((a) => applyAssetShock(a, shocks)).toList();
  final scenarioUsdRub = usdRubRate * (1 + shocks.usdRubPercent / 100);

  final scenarioSnapshot = buildPortfolioSnapshot(
    portfolio: baseSnapshot.portfolio,
    allAssets: shockedAssets,
    usdRubRate: scenarioUsdRub,
  );

  final baseSlices = {
    for (final s in buildPortfolioAllocation(baseSnapshot)) s.key: s.valueRub,
  };
  final scenarioSlices = {
    for (final s in buildPortfolioAllocation(scenarioSnapshot))
      s.key: s.valueRub,
  };

  const classes = ['cash', 'crypto', 'stocks', 'bonds'];
  final classDelta = <String, double>{};
  for (final key in classes) {
    classDelta[key] =
        (scenarioSlices[key] ?? 0) - (baseSlices[key] ?? 0);
  }

  final baseTotal = baseSnapshot.totalValueRub;
  final scenarioTotal = scenarioSnapshot.totalValueRub;
  final delta = scenarioTotal - baseTotal;

  return PortfolioScenarioResult(
    baseTotalRub: baseTotal,
    scenarioTotalRub: scenarioTotal,
    deltaRub: delta,
    deltaPercent: baseTotal == 0 ? 0 : (delta / baseTotal) * 100,
    classDeltaRub: classDelta,
    shocks: shocks,
  );
}
