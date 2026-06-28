// =============================================================================
// EcoPulse · lib/core/utils/portfolio_math.dart
// Автор: Цымбал Е. В.
// Дата: 10.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: portfolio_math.
// =============================================================================

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';

/// Класс [PortfolioAllocationSlice].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
class PortfolioAllocationSlice {
/// Создаёт [PortfolioAllocationSlice].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  const PortfolioAllocationSlice({
    required this.key,
    required this.valueRub,
  });

  /// cash | crypto | stocks | bonds
  final String key;
/// Поле [valueRub] класса [PortfolioAllocationSlice].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  final double valueRub;
}

/// Функция [buildPortfolioAllocation] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
List<PortfolioAllocationSlice> buildPortfolioAllocation(
  PortfolioSnapshot snapshot,
) {
  var crypto = 0.0;
  var stocks = 0.0;
  var bonds = 0.0;

  for (final ps in snapshot.positions) {
    switch (ps.position.type) {
      case AssetType.crypto:
        crypto += ps.valueRub;
      case AssetType.stockRu:
      case AssetType.stockUs:
        stocks += ps.valueRub;
      case AssetType.bondRu:
        bonds += ps.valueRub;
    }
  }

  return [
    PortfolioAllocationSlice(key: 'cash', valueRub: snapshot.portfolio.cashRub),
    PortfolioAllocationSlice(key: 'crypto', valueRub: crypto),
    PortfolioAllocationSlice(key: 'stocks', valueRub: stocks),
    PortfolioAllocationSlice(key: 'bonds', valueRub: bonds),
  ].where((s) => s.valueRub > 0).toList();
}

/// Функция [assetPriceInRub] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
double assetPriceInRub(MarketAsset asset, double usdRubRate) {
  if (asset.type == AssetType.bondRu) {
    final face = asset.faceValue ?? 1000;
    return face * asset.price / 100;
  }
  if (asset.currency == 'RUB') return asset.price;
  return asset.price * usdRubRate;
}

/// Функция [positionCostRub] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
double positionCostRub(PortfolioPosition position, double usdRubRate) {
  return position.costRub;
}

/// Функция [positionValueRub] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
double positionValueRub(
  PortfolioPosition position,
  MarketAsset? live,
  double usdRubRate,
) {
  if (live == null) return positionCostRub(position, usdRubRate);
  return position.quantity * assetPriceInRub(live, usdRubRate);
}

/// Функция [buildPortfolioSnapshot] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
PortfolioSnapshot buildPortfolioSnapshot({
  required PaperPortfolio portfolio,
  required List<MarketAsset> allAssets,
  required double usdRubRate,
}) {
  final assetByKey = {
    for (final a in allAssets) '${a.type.name}:${a.id}': a,
  };

  final positionSnapshots = <PositionSnapshot>[];
  var holdingsValue = 0.0;
  var invested = 0.0;

  for (final pos in portfolio.positions) {
    final live = assetByKey[pos.assetKey];
    final costRub = positionCostRub(pos, usdRubRate);
    final valueRub = positionValueRub(pos, live, usdRubRate);
    invested += costRub;
    holdingsValue += valueRub;
    final pnl = valueRub - costRub;
    positionSnapshots.add(
      PositionSnapshot(
        position: pos,
        currentPrice: live?.price ?? pos.buyPrice,
        valueRub: valueRub,
        costRub: costRub,
        pnlRub: pnl,
        pnlPercent: costRub == 0 ? 0 : (pnl / costRub) * 100,
        liveAsset: live,
      ),
    );
  }

  final total = portfolio.cashRub + holdingsValue;
  final pnl = total - portfolio.initialCapitalRub;
  final pnlPct = portfolio.initialCapitalRub == 0
      ? 0.0
      : (pnl / portfolio.initialCapitalRub) * 100;

  return PortfolioSnapshot(
    portfolio: portfolio,
    totalValueRub: total,
    investedRub: invested,
    pnlRub: pnl,
    pnlPercent: pnlPct,
    positions: positionSnapshots,
  );
}

/// Функция [findAssetForKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
MarketAsset? findAssetForKey(String key, List<MarketAsset> assets) {
  for (final a in assets) {
    if ('${a.type.name}:${a.id}' == key) return a;
  }
  return null;
}

/// Функция [portfolioAssetKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
String portfolioAssetKey(MarketAsset asset) => '${asset.type.name}:${asset.id}';
