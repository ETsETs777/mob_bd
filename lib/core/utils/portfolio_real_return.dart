// =============================================================================
// EcoPulse · lib/core/utils/portfolio_real_return.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Сравнение номинальной и реальной доходности портфеля с бенчмарками.
// =============================================================================

import '../../data/models/inflation_point.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import 'correlation_utils.dart';
import 'portfolio_backtest.dart';

/// Горизонт сравнения доходности.
enum RealReturnHorizon { days30, allTime }

/// Строка сравнения с бенчмарком.
class RealReturnRow {
  const RealReturnRow({
    required this.key,
    required this.labelKey,
    required this.percent,
    this.highlight = false,
  });

  final String key;
  final String labelKey;
  final double percent;
  final bool highlight;
}

/// Результат сравнения реальной доходности.
class PortfolioRealReturnComparison {
  const PortfolioRealReturnComparison({
    required this.horizon,
    required this.days,
    required this.portfolioNominalPercent,
    required this.portfolioRealPercent,
    required this.inflationPercent,
    required this.rows,
    this.imoexPercent,
    this.depositPercent,
  });

  final RealReturnHorizon horizon;
  final int days;
  final double portfolioNominalPercent;
  final double portfolioRealPercent;
  final double inflationPercent;
  final double? imoexPercent;
  final double? depositPercent;
  final List<RealReturnRow> rows;

  double? get vsInflationPp =>
      inflationPercent == 0 ? null : portfolioRealPercent;

  double? get vsImoexPp => imoexPercent == null
      ? null
      : portfolioNominalPercent - imoexPercent!;

  bool get beatsInflation => portfolioRealPercent > 0;

  bool? get beatsImoex =>
      imoexPercent == null ? null : portfolioNominalPercent > imoexPercent!;

  bool? get beatsDeposit => depositPercent == null
      ? null
      : portfolioNominalPercent > depositPercent!;
}

/// Про-rata годовой инфляции на [days] дней.
double proRatedInflationPercent(double annualPercent, int days) {
  if (days <= 0) return 0;
  return annualPercent * days / 365.0;
}

/// Накопленная инфляция между датами по годовой истории CPI.
double accumulatedInflationPercent({
  required DateTime from,
  required DateTime to,
  required List<YearValue> history,
}) {
  if (history.isEmpty || !to.isAfter(from)) return 0;

  var factor = 1.0;
  final startYear = from.year;
  final endYear = to.year;

  for (var y = startYear; y <= endYear; y++) {
    YearValue? entry;
    for (final h in history) {
      if (h.year == y) {
        entry = h;
        break;
      }
    }
    if (entry == null) continue;

    final yearStart = DateTime(y);
    final yearEnd = DateTime(y, 12, 31, 23, 59, 59);
    final periodStart = y == startYear ? from : yearStart;
    final periodEnd = y == endYear ? to : yearEnd;
    if (!periodEnd.isAfter(periodStart)) continue;

    final daysInYear = _isLeapYear(y) ? 366.0 : 365.0;
    final daysUsed = periodEnd.difference(periodStart).inDays.toDouble();
    factor *= 1 + (entry.value / 100) * (daysUsed / daysInYear);
  }

  return (factor - 1) * 100;
}

bool _isLeapYear(int year) =>
    year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

InflationPoint? findRuInflation(List<InflationPoint>? points) {
  if (points == null) return null;
  for (final p in points) {
    if (p.countryCode == 'RU') return p;
  }
  return null;
}

DateTime earliestPortfolioDate(PaperPortfolio portfolio) {
  if (portfolio.positions.isEmpty) return DateTime.now();
  var earliest = portfolio.positions.first.boughtAt;
  for (final pos in portfolio.positions.skip(1)) {
    if (pos.boughtAt.isBefore(earliest)) earliest = pos.boughtAt;
  }
  return earliest;
}

MarketAsset? findImoexAsset(List<MarketAsset> stocks) {
  for (final s in stocks) {
    if (s.symbol == 'IMOEX') return s;
  }
  return null;
}

/// Строит сравнение номинальной / реальной доходности с бенчмарками.
PortfolioRealReturnComparison? buildPortfolioRealReturnComparison({
  required PortfolioSnapshot snapshot,
  required List<MarketAsset> assets,
  required double usdRubRate,
  required RealReturnHorizon horizon,
  List<InflationPoint>? inflation,
  double? keyRatePercent,
  DateTime? asOf,
}) {
  final now = asOf ?? DateTime.now();
  final ruInflation = findRuInflation(inflation);
  if (ruInflation == null) return null;

  final imoex = findImoexAsset(assets);
  final imoexChange = imoex != null ? changeFromSparkline(imoex.sparkline) : null;

  late double nominal;
  late int days;
  late double inflationPct;

  if (horizon == RealReturnHorizon.days30) {
    final backtest = backtestPortfolio30d(
      portfolio: snapshot.portfolio,
      assets: assets,
      usdRubRate: usdRubRate,
    );
    if (backtest == null) return null;
    nominal = backtest.changePercent;
    days = 30;
    inflationPct = proRatedInflationPercent(ruInflation.value, days);
  } else {
    nominal = snapshot.pnlPercent;
    final from = earliestPortfolioDate(snapshot.portfolio);
    days = now.difference(from).inDays.clamp(1, 3650);
    inflationPct = accumulatedInflationPercent(
      from: from,
      to: now,
      history: ruInflation.history,
    );
    if (inflationPct == 0 && ruInflation.history.isEmpty) {
      inflationPct = proRatedInflationPercent(ruInflation.value, days);
    }
  }

  final real = nominal - inflationPct;
  final depositPct = keyRatePercent == null
      ? null
      : proRatedInflationPercent(keyRatePercent, days);

  final rows = <RealReturnRow>[
    RealReturnRow(
      key: 'nominal',
      labelKey: 'nominal',
      percent: nominal,
      highlight: true,
    ),
    RealReturnRow(
      key: 'real',
      labelKey: 'real',
      percent: real,
      highlight: true,
    ),
    RealReturnRow(
      key: 'inflation',
      labelKey: 'inflation',
      percent: inflationPct,
    ),
    if (horizon == RealReturnHorizon.days30 && imoexChange != null)
      RealReturnRow(
        key: 'imoex',
        labelKey: 'imoex',
        percent: imoexChange,
      ),
    if (depositPct != null)
      RealReturnRow(
        key: 'deposit',
        labelKey: 'deposit',
        percent: depositPct,
      ),
  ];

  return PortfolioRealReturnComparison(
    horizon: horizon,
    days: days,
    portfolioNominalPercent: nominal,
    portfolioRealPercent: real,
    inflationPercent: inflationPct,
    imoexPercent:
        horizon == RealReturnHorizon.days30 ? imoexChange : null,
    depositPercent: depositPct,
    rows: rows,
  );
}
