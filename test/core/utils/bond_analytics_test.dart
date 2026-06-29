// =============================================================================
// EcoPulse · test/bond_analytics_test.dart
// Автор: Цымбал Е. В.
// Дата: 22.06.2026
// Unit/widget тест: bond_analytics_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/bond_analytics.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

/// Приватная функция [_ofz].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
MarketAsset _ofz({
  required String id,
  required DateTime maturity,
  required double ytm,
}) {
  return MarketAsset(
    id: id,
    symbol: id,
    name: 'ОФЗ $id',
    price: 95,
    changePercent: 0.1,
    type: AssetType.bondRu,
    currency: 'RUB',
    yieldPercent: ytm,
    couponPercent: 7,
    maturityDate: maturity,
    bondCategory: BondCategory.ofz,
    faceValue: 1000,
  );
}

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
void main() {
  final now = DateTime(2026, 6, 28);
  final bonds = [
    _ofz(id: 'A', maturity: DateTime(2027, 6, 1), ytm: 13),
    _ofz(id: 'B', maturity: DateTime(2029, 6, 1), ytm: 14),
    _ofz(id: 'C', maturity: DateTime(2031, 6, 1), ytm: 14.5),
    MarketAsset(
      id: 'CORP',
      symbol: 'CORP',
      name: 'Corp',
      price: 98,
      changePercent: 0,
      type: AssetType.bondRu,
      bondCategory: BondCategory.corporate,
      yieldPercent: 12,
      maturityDate: DateTime(2028, 1, 1),
    ),
  ];

  test('buildOfzYieldCurve sorts by maturity and skips non-OFZ', () {
    final curve = buildOfzYieldCurve(bonds, asOf: now);
    expect(curve.length, 3);
    expect(curve.first.bond.id, 'A');
    expect(curve.last.bond.id, 'C');
    expect(curve.first.yearsToMaturity, closeTo(0.92, 0.1));
  });

  test('buildBondLadderByYear groups OFZ', () {
    final ladder = buildBondLadderByYear(bonds);
    expect(ladder.keys, contains(2027));
    expect(ladder[2027]!.length, 1);
    expect(ladder.containsKey(2028), false);
  });

  test('buildBondCalendarEvents includes maturity and coupon estimates', () {
    final tracked = bonds.take(2).toList();
    final events = buildBondCalendarEvents(tracked, asOf: now, horizonDays: 800);
    expect(events.any((e) => e.type == BondCalendarEventType.maturity), true);
    expect(events.any((e) => e.type == BondCalendarEventType.couponEstimate), true);
  });

  test('buildBondCalendarEvents prefers MOEX next coupon date', () {
    final bond = MarketAsset(
      id: 'D',
      symbol: 'D',
      name: 'ОФЗ D',
      price: 95,
      changePercent: 0.1,
      type: AssetType.bondRu,
      currency: 'RUB',
      yieldPercent: 14,
      couponPercent: 7,
      maturityDate: DateTime(2028, 6, 1),
      bondCategory: BondCategory.ofz,
      faceValue: 1000,
      nextCouponDate: DateTime(2026, 9, 15),
      couponValueRub: 35.5,
      couponPeriodDays: 182,
    );
    final events = buildBondCalendarEvents([bond], asOf: now, horizonDays: 365);
    expect(events.any((e) => e.type == BondCalendarEventType.coupon), true);
    expect(events.any((e) => e.type == BondCalendarEventType.couponEstimate), false);
    expect(
      events.where((e) => e.type == BondCalendarEventType.coupon).length,
      greaterThan(1),
    );
  });

  test('ofzYieldSpread measures long minus short end', () {
    expect(ofzYieldSpread(bonds, asOf: now), closeTo(1.5, 0.1));
  });

  test('averageOfzYield and highestYieldOfz', () {
    expect(averageOfzYield(bonds), closeTo(13.83, 0.1));
    expect(highestYieldOfz(bonds)?.id, 'C');
  });

  test('portfolioCouponIncomeEstimate sums coupon events', () {
    final bond = MarketAsset(
      id: 'D',
      symbol: 'D',
      name: 'ОФЗ D',
      price: 95,
      changePercent: 0,
      type: AssetType.bondRu,
      currency: 'RUB',
      couponValueRub: 35.5,
      nextCouponDate: DateTime(2026, 9, 15),
      couponPeriodDays: 182,
    );
    final portfolio = PaperPortfolio(
      positions: [
        PortfolioPosition(
          assetKey: 'bondRu:D',
          symbol: 'D',
          type: AssetType.bondRu,
          quantity: 10,
          buyPrice: 95,
          currency: 'RUB',
          costRub: 9500,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final events = buildBondCalendarEvents([bond], asOf: now, horizonDays: 365);
    expect(portfolioCouponIncomeEstimate(events, portfolio), greaterThanOrEqualTo(355));
  });

  test('nearestBondYieldPointIndex snaps to closest maturity', () {
    final sample = _ofz(
      id: 'X',
      maturity: DateTime(2028, 1, 1),
      ytm: 12,
    );
    final curve = [
      BondYieldPoint(bond: sample, yearsToMaturity: 1, yieldPercent: 10),
      BondYieldPoint(bond: sample, yearsToMaturity: 3, yieldPercent: 11),
      BondYieldPoint(bond: sample, yearsToMaturity: 5, yieldPercent: 12),
    ];

    expect(nearestBondYieldPointIndex(curve, 2.1), 1);
    expect(nearestBondYieldPointIndex(curve, 0.5), 0);
    expect(nearestBondYieldPointIndex(curve, 4.8), 2);
  });

  test('upcomingBondEventsCount within horizon', () {
    final tracked = bonds.take(2).toList();
    expect(upcomingBondEventsCount(tracked, asOf: now, horizonDays: 800), greaterThan(0));
  });
}
