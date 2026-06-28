// =============================================================================
// EcoPulse · lib/core/utils/portfolio_income_calendar.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Календарь купонов, дивидendов и погашений по позициям портфеля.
// =============================================================================

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import 'bond_analytics.dart';
import 'portfolio_math.dart';

/// Тип денежного поступления по портфелю.
enum PortfolioIncomeEventType {
  bondCoupon,
  bondCouponEstimate,
  bondMaturity,
  stockDividendEstimate,
}

/// Событие поступления средств по позиции портфеля.
class PortfolioIncomeEvent {
  const PortfolioIncomeEvent({
    required this.date,
    required this.type,
    required this.symbol,
    required this.assetKey,
    required this.amountRub,
    required this.quantity,
    required this.isEstimate,
  });

  final DateTime date;
  final PortfolioIncomeEventType type;
  final String symbol;
  final String assetKey;
  final double amountRub;
  final double quantity;
  final bool isEstimate;
}

/// Сводка календаря дохода за горизонт.
class PortfolioIncomePlan {
  const PortfolioIncomePlan({
    required this.events,
    required this.totalNext30Days,
    required this.totalNext90Days,
    required this.byMonth,
  });

  final List<PortfolioIncomeEvent> events;
  final double totalNext30Days;
  final double totalNext90Days;
  final Map<String, double> byMonth;

  List<PortfolioIncomeEvent> get upcoming => events.take(12).toList();
}

/// Оценка годовой дивидendной доходности для эвристики.
double estimatedAnnualDividendYield(AssetType type) => switch (type) {
      AssetType.stockRu => 0.08,
      AssetType.stockUs => 0.015,
      _ => 0,
    };

/// Сумма поступления по событию облигации × количество в портфеле.
double bondIncomeAmountRub(BondCalendarEvent event, PortfolioPosition position) {
  final bond = event.bond;
  switch (event.type) {
    case BondCalendarEventType.maturity:
      final face = bond.faceValue ?? 1000;
      return face * position.quantity;
    case BondCalendarEventType.coupon:
    case BondCalendarEventType.couponEstimate:
      if (bond.couponValueRub != null) {
        return bond.couponValueRub! * position.quantity;
      }
      final face = bond.faceValue ?? 1000;
      final pct = bond.couponPercent ?? 0;
      if (pct <= 0) return 0;
      final periodDays = bond.couponPeriodDays ?? 182;
      return face * position.quantity * pct / 100 * (periodDays / 365.25);
  }
}

PortfolioIncomeEventType _mapBondEventType(BondCalendarEventType type) =>
    switch (type) {
      BondCalendarEventType.maturity => PortfolioIncomeEventType.bondMaturity,
      BondCalendarEventType.coupon => PortfolioIncomeEventType.bondCoupon,
      BondCalendarEventType.couponEstimate =>
        PortfolioIncomeEventType.bondCouponEstimate,
    };

/// Ближайшие квартальные даты выплат дивидendов (оценка).
List<DateTime> estimatedDividendDates({
  required DateTime from,
  required DateTime end,
}) {
  final dates = <DateTime>[];
  for (var year = from.year; year <= end.year + 1; year++) {
    for (final month in [3, 6, 9, 12]) {
      final d = DateTime(year, month, 25);
      if (d.isAfter(from) && d.isBefore(end)) dates.add(d);
    }
  }
  dates.sort();
  return dates;
}

/// Строит календарь дохода только по позициям [portfolio].
PortfolioIncomePlan buildPortfolioIncomePlan({
  required PaperPortfolio portfolio,
  required List<MarketAsset> allAssets,
  required double usdRubRate,
  DateTime? asOf,
  int horizonDays = 365,
}) {
  final now = asOf ?? DateTime.now();
  final end = now.add(Duration(days: horizonDays));

  if (portfolio.positions.isEmpty) {
    return const PortfolioIncomePlan(
      events: [],
      totalNext30Days: 0,
      totalNext90Days: 0,
      byMonth: {},
    );
  }

  final assetByKey = {
    for (final a in allAssets) '${a.type.name}:${a.id}': a,
  };
  final positionByKey = {
    for (final p in portfolio.positions) p.assetKey: p,
  };

  final events = <PortfolioIncomeEvent>[];

  final portfolioBonds = portfolio.positions
      .where((p) => p.type == AssetType.bondRu)
      .map((p) => assetByKey[p.assetKey])
      .whereType<MarketAsset>()
      .toList();

  for (final bondEvent in buildBondCalendarEvents(
    portfolioBonds,
    asOf: now,
    horizonDays: horizonDays,
  )) {
    final key = '${bondEvent.bond.type.name}:${bondEvent.bond.id}';
    final pos = positionByKey[key];
    if (pos == null) continue;
    final amount = bondIncomeAmountRub(bondEvent, pos);
    if (amount <= 0) continue;
    events.add(
      PortfolioIncomeEvent(
        date: bondEvent.date,
        type: _mapBondEventType(bondEvent.type),
        symbol: pos.symbol,
        assetKey: key,
        amountRub: amount,
        quantity: pos.quantity,
        isEstimate: bondEvent.type == BondCalendarEventType.couponEstimate,
      ),
    );
  }

  for (final pos in portfolio.positions) {
    if (pos.type != AssetType.stockRu && pos.type != AssetType.stockUs) continue;
    final live = assetByKey[pos.assetKey];
    final yield = estimatedAnnualDividendYield(pos.type);
    if (yield <= 0) continue;
    final valueRub = positionValueRub(pos, live, usdRubRate);
    if (valueRub <= 0) continue;
    final quarterly = valueRub * yield / 4;

    for (final date in estimatedDividendDates(from: now, end: end)) {
      events.add(
        PortfolioIncomeEvent(
          date: date,
          type: PortfolioIncomeEventType.stockDividendEstimate,
          symbol: pos.symbol,
          assetKey: pos.assetKey,
          amountRub: quarterly,
          quantity: pos.quantity,
          isEstimate: true,
        ),
      );
    }
  }

  events.sort((a, b) => a.date.compareTo(b.date));

  var total30 = 0.0;
  var total90 = 0.0;
  final byMonth = <String, double>{};

  for (final e in events) {
    final daysUntil = e.date.difference(now).inDays;
    if (daysUntil >= 0 && daysUntil <= 30) total30 += e.amountRub;
    if (daysUntil >= 0 && daysUntil <= 90) total90 += e.amountRub;
    final monthKey =
        '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
    byMonth[monthKey] = (byMonth[monthKey] ?? 0) + e.amountRub;
  }

  return PortfolioIncomePlan(
    events: events,
    totalNext30Days: total30,
    totalNext90Days: total90,
    byMonth: byMonth,
  );
}
