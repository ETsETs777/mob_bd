// =============================================================================
// EcoPulse · lib/core/utils/watchlist_volatility.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Волатильность активов watchlist по дневным доходностям sparkline.
// =============================================================================

import 'dart:math' as math;

import '../../data/models/market_asset.dart';
import 'correlation_utils.dart';

/// Ячейка heatmap волатильности.
class WatchlistVolatilityCell {
  const WatchlistVolatilityCell({
    required this.asset,
    required this.dailyVolPercent,
    required this.annualVolPercent,
    this.changePercent,
  });

  final MarketAsset asset;
  final double dailyVolPercent;
  final double annualVolPercent;
  final double? changePercent;
}

/// Снимок heatmap для списка активов.
class WatchlistVolatilitySnapshot {
  const WatchlistVolatilitySnapshot({
    required this.cells,
    required this.minAnnualVol,
    required this.maxAnnualVol,
  });

  final List<WatchlistVolatilityCell> cells;
  final double minAnnualVol;
  final double maxAnnualVol;

  bool get isEmpty => cells.isEmpty;
}

/// Стандартное отклонение выборки.
double? standardDeviation(List<double> values) {
  if (values.length < 2) return null;
  final mean = values.reduce((a, b) => a + b) / values.length;
  var sumSq = 0.0;
  for (final v in values) {
    final d = v - mean;
    sumSq += d * d;
  }
  return math.sqrt(sumSq / values.length);
}

/// Дневная волатильность (%): σ дневных доходностей × 100.
double? dailyVolatilityPercent(List<double> prices) {
  final returns = dailyReturns(prices);
  if (returns.length < 2) return null;
  final std = standardDeviation(returns);
  if (std == null || std <= 0) return null;
  return std * 100;
}

/// Годовая волатильность из дневной (252 торговых дня).
double annualizedVolatilityPercent(double dailyVolPercent) {
  return dailyVolPercent * math.sqrt(252);
}

/// Строит heatmap-снимок для [assets] (уже отфильтрованный watchlist).
WatchlistVolatilitySnapshot buildWatchlistVolatilityHeatmap(
  List<MarketAsset> assets,
) {
  final cells = <WatchlistVolatilityCell>[];

  for (final asset in assets) {
    final daily = dailyVolatilityPercent(asset.sparkline);
    if (daily == null) continue;
    final annual = annualizedVolatilityPercent(daily);
    cells.add(
      WatchlistVolatilityCell(
        asset: asset,
        dailyVolPercent: daily,
        annualVolPercent: annual,
        changePercent: asset.changePercent,
      ),
    );
  }

  cells.sort((a, b) => b.annualVolPercent.compareTo(a.annualVolPercent));

  if (cells.isEmpty) {
    return const WatchlistVolatilitySnapshot(
      cells: [],
      minAnnualVol: 0,
      maxAnnualVol: 0,
    );
  }

  var minV = cells.first.annualVolPercent;
  var maxV = cells.first.annualVolPercent;
  for (final c in cells) {
    if (c.annualVolPercent < minV) minV = c.annualVolPercent;
    if (c.annualVolPercent > maxV) maxV = c.annualVolPercent;
  }

  return WatchlistVolatilitySnapshot(
    cells: cells,
    minAnnualVol: minV,
    maxAnnualVol: maxV,
  );
}

/// Нормализованный коэффициент 0…1 для раскраски ячейки.
double volatilityHeatFactor(
  double annualVol,
  double minVol,
  double maxVol,
) {
  if (maxVol <= minVol) return 0.5;
  return ((annualVol - minVol) / (maxVol - minVol)).clamp(0.0, 1.0);
}
