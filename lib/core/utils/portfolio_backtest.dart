// =============================================================================
// EcoPulse · lib/core/utils/portfolio_backtest.dart
// Автор: Цымбал Е. В.
// Дата: 09.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: portfolio_backtest.
// =============================================================================

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import 'portfolio_math.dart';

/// Класс [PortfolioBacktestResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
class PortfolioBacktestResult {
/// Создаёт [PortfolioBacktestResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  const PortfolioBacktestResult({
    required this.daysAgo,
    required this.pastValueRub,
    required this.currentValueRub,
    required this.changePercent,
  });

/// Поле [daysAgo] класса [PortfolioBacktestResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  final int daysAgo;
/// Поле [pastValueRub] класса [PortfolioBacktestResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  final double pastValueRub;
/// Поле [currentValueRub] класса [PortfolioBacktestResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  final double currentValueRub;
/// Поле [changePercent] класса [PortfolioBacktestResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  final double changePercent;
}

/// Estimates portfolio value ~30d ago using sparkline start prices.
PortfolioBacktestResult? backtestPortfolio30d({
  required PaperPortfolio portfolio,
  required List<MarketAsset> assets,
  required double usdRubRate,
  int daysAgo = 30,
}) {
  if (portfolio.positions.isEmpty) return null;

  var pastHoldings = 0.0;
  var currentHoldings = 0.0;
  var priced = 0;

  for (final pos in portfolio.positions) {
    final live = findAssetForKey(pos.assetKey, assets);
    if (live == null || live.sparkline.length < 2) continue;

    final oldPrice = live.sparkline.first;
    if (oldPrice <= 0 || live.price <= 0) continue;

    final oldRub = pos.quantity * assetPriceInRub(live.withPrice(oldPrice), usdRubRate);
    final newRub = positionValueRub(pos, live, usdRubRate);
    pastHoldings += oldRub;
    currentHoldings += newRub;
    priced++;
  }

  if (priced == 0) return null;

  final pastTotal = portfolio.cashRub + pastHoldings;
  final currentTotal = portfolio.cashRub + currentHoldings;
  final change = pastTotal == 0 ? 0.0 : ((currentTotal - pastTotal) / pastTotal) * 100;

  return PortfolioBacktestResult(
    daysAgo: daysAgo,
    pastValueRub: pastTotal,
    currentValueRub: currentTotal,
    changePercent: change,
  );
}

/// Extension [_MarketAssetCopy].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
extension _MarketAssetCopy on MarketAsset {
  MarketAsset withPrice(double price) => MarketAsset(
        id: id,
        symbol: symbol,
        name: name,
        price: price,
        changePercent: changePercent,
        type: type,
        sparkline: sparkline,
        currency: currency,
        imageUrl: imageUrl,
      );
}
