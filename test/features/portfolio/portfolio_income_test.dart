// =============================================================================
// EcoPulse · test/portfolio_income_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: portfolio_income_calendar.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/bond_analytics.dart';
import 'package:ecopulse/core/utils/portfolio_income_calendar.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';

MarketAsset _bond({
  required String id,
  double? couponValueRub,
  DateTime? nextCoupon,
}) {
  return MarketAsset(
    id: id,
    symbol: id,
    name: id,
    type: AssetType.bondRu,
    price: 95,
    currency: 'RUB',
    changePercent: 0,
    couponPercent: 7.5,
    couponValueRub: couponValueRub,
    nextCouponDate: nextCoupon,
    couponPeriodDays: 182,
    faceValue: 1000,
    bondCategory: BondCategory.ofz,
    maturityDate: DateTime(2028, 6, 1),
  );
}

void main() {
  test('bondIncomeAmountRub multiplies coupon by quantity', () {
    final bond = _bond(id: 'SU26238', couponValueRub: 35.5);
    final pos = PortfolioPosition(
      assetKey: 'bondRu:SU26238',
      symbol: 'SU26238',
      type: AssetType.bondRu,
      quantity: 10,
      buyPrice: 95,
      currency: 'RUB',
      costRub: 9500,
      boughtAt: DateTime(2026, 1, 1),
    );
    final amount = bondIncomeAmountRub(
      BondCalendarEvent(
        date: DateTime(2026, 7, 1),
        type: BondCalendarEventType.coupon,
        bond: bond,
      ),
      pos,
    );
    expect(amount, closeTo(355, 0.01));
  });

  test('buildPortfolioIncomePlan includes bond coupons for portfolio', () {
    final now = DateTime(2026, 6, 1);
    final bond = _bond(
      id: 'SU26238',
      couponValueRub: 35.5,
      nextCoupon: DateTime(2026, 7, 15),
    );
    final portfolio = PaperPortfolio(
      positions: [
        PortfolioPosition(
          assetKey: 'bondRu:SU26238',
          symbol: 'SU26238',
          type: AssetType.bondRu,
          quantity: 10,
          buyPrice: 95,
          currency: 'RUB',
          costRub: 9500,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    final plan = buildPortfolioIncomePlan(
      portfolio: portfolio,
      allAssets: [bond],
      usdRubRate: 90,
      asOf: now,
      horizonDays: 365,
    );

    expect(plan.events, isNotEmpty);
    expect(
      plan.events.any((e) => e.type == PortfolioIncomeEventType.bondCoupon),
      isTrue,
    );
    expect(plan.totalNext90Days, greaterThan(0));
  });

  test('buildPortfolioIncomePlan estimates stock dividends', () {
    final now = DateTime(2026, 6, 1);
    final stock = MarketAsset(
      id: 'SBER',
      symbol: 'SBER',
      name: 'Sberbank',
      type: AssetType.stockRu,
      price: 300,
      currency: 'RUB',
      changePercent: 0,
    );
    final portfolio = PaperPortfolio(
      positions: [
        PortfolioPosition(
          assetKey: 'stockRu:SBER',
          symbol: 'SBER',
          type: AssetType.stockRu,
          quantity: 10,
          buyPrice: 280,
          currency: 'RUB',
          costRub: 2800,
          boughtAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    final plan = buildPortfolioIncomePlan(
      portfolio: portfolio,
      allAssets: [stock],
      usdRubRate: 90,
      asOf: now,
    );

    expect(
      plan.events.any(
        (e) => e.type == PortfolioIncomeEventType.stockDividendEstimate,
      ),
      isTrue,
    );
  });
}
