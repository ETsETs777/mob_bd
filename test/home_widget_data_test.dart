// =============================================================================
// EcoPulse · test/home_widget_data_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: home widget slot resolution.
// =============================================================================

import 'package:ecopulse/core/utils/home_widget_data.dart';
import 'package:ecopulse/data/models/commodity_quote.dart';
import 'package:ecopulse/data/models/currency_rate.dart';
import 'package:ecopulse/data/models/inflation_point.dart';
import 'package:ecopulse/data/models/key_rate_point.dart';
import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';
import 'package:ecopulse/providers/widget_config_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolveHomeWidgetMetric formats USD/RUB', () {
    final slot = resolveHomeWidgetMetric(
      WidgetMetric.usdRub,
      rates: const [
        CurrencyRate(
          code: 'USD',
          base: 'RUB',
          rate: 90.5,
          changePercent: 0.4,
          history: [],
          isRub: true,
        ),
      ],
    );
    expect(slot.label, 'USD/RUB');
    expect(slot.value, contains('90'));
    expect(slot.change, contains('+'));
  });

  test('resolveHomeWidgetMetric formats IMOEX from stocks', () {
    final slot = resolveHomeWidgetMetric(
      WidgetMetric.imoex,
      stocks: const [
        MarketAsset(
          id: 'imoex',
          symbol: 'IMOEX',
          name: 'MOEX Index',
          type: AssetType.stockRu,
          price: 3200,
          changePercent: -1.2,
          currency: 'RUB',
        ),
      ],
    );
    expect(slot.value, '3200');
    expect(slot.change, contains('-'));
  });

  test('resolveHomeWidgetMetric formats portfolio total and pnl', () {
    final slot = resolveHomeWidgetMetric(
      WidgetMetric.portfolioPnl,
      portfolio: PortfolioSnapshot(
        portfolio: const PaperPortfolio(
          initialCapitalRub: 100000,
          cashRub: 50000,
          positions: [],
        ),
        totalValueRub: 105000,
        investedRub: 0,
        pnlRub: 5000,
        pnlPercent: 5,
        positions: [],
      ),
    );
    expect(slot.value, contains('105'));
    expect(slot.change, contains('+5'));
  });

  test('buildHomeWidgetSlots returns four slots for expanded config', () {
    const config = WidgetConfig(
      layout: WidgetLayout.expanded,
      slot1: WidgetMetric.usdRub,
      slot2: WidgetMetric.btc,
      slot3: WidgetMetric.keyRate,
      slot4: WidgetMetric.inflationRu,
    );

    final slots = buildHomeWidgetSlots(
      config: config,
      keyRate: KeyRateSnapshot(
        current: 21,
        history: const [],
        updatedAt: DateTime(2026, 6, 1),
      ),
      inflation: const [
        InflationPoint(
          countryCode: 'RU',
          countryName: 'Russia',
          year: 2024,
          value: 7.4,
        ),
      ],
    );

    expect(slots, hasLength(4));
    expect(slots[2].value, contains('21'));
    expect(slots[3].value, contains('7.4'));
  });

  test('resolveHomeWidgetMetric formats WTI commodity', () {
    final slot = resolveHomeWidgetMetric(
      WidgetMetric.wti,
      commodities: const [
        CommodityQuote(
          id: 'wti',
          name: 'WTI',
          price: 78.5,
          unit: 'USD/bbl',
          changePercent: 2.1,
        ),
      ],
    );
    expect(slot.label, 'WTI');
    expect(slot.value, '79');
    expect(slot.change, contains('+'));
  });
}
