// =============================================================================
// EcoPulse · lib/data/demo/demo_fixtures.dart
// Автор: Цымбал Е. В.
// Дата: 14.05.2026
// Mock-данные для демо-режима без сети. Файл: demo_fixtures.
// =============================================================================

import '../models/commodity_quote.dart';
import '../models/crypto_feed.dart';
import '../models/currency_rate.dart';
import '../models/inflation_point.dart';
import '../models/key_rate_point.dart';
import '../models/market_asset.dart';
import '../models/news_item.dart';
import '../models/macro_event.dart';
import '../models/price_point.dart';

/// Приватная функция [_spark].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
List<double> _spark(double base, {int n = 7, double drift = 0.008}) =>
    List.generate(n, (i) => base * (1 + drift * i));

/// Приватная функция [_history].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
List<PricePoint> _history(double base, {int days = 30}) => List.generate(
      days,
      (i) => PricePoint(
        date: DateTime.now().subtract(Duration(days: days - i)),
        value: base * (1 + 0.002 * i),
      ),
    );

/// Класс [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
class DemoFixtures {
/// Создаёт [DemoFixtures] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  DemoFixtures._();

/// Getter [currencyRates] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static List<CurrencyRate> get currencyRates => [
        CurrencyRate(
          code: 'RUB',
          base: 'USD',
          rate: 89.45,
          changePercent: -0.32,
          isRub: true,
          history: _history(89.45),
        ),
        CurrencyRate(
          code: 'EUR',
          base: 'RUB',
          rate: 97.20,
          changePercent: 0.15,
          history: _history(97.20),
        ),
        CurrencyRate(
          code: 'EUR',
          base: 'USD',
          rate: 1.087,
          changePercent: 0.12,
          history: _history(1.087),
        ),
      ];

/// Getter [keyRate] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static KeyRateSnapshot get keyRate {
    final now = DateTime.now();
    return KeyRateSnapshot(
      current: 21,
      updatedAt: now,
      history: [
        KeyRatePoint(date: now.subtract(const Duration(days: 180)), rate: 18),
        KeyRatePoint(date: now.subtract(const Duration(days: 90)), rate: 19),
        KeyRatePoint(date: now.subtract(const Duration(days: 30)), rate: 21),
        KeyRatePoint(date: now, rate: 21),
      ],
    );
  }

/// Getter [inflation] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static List<InflationPoint> get inflation => [
        const InflationPoint(
          countryCode: 'RU',
          countryName: 'Россия',
          year: 2025,
          value: 7.4,
          history: [
            YearValue(year: 2022, value: 11.9),
            YearValue(year: 2023, value: 7.4),
            YearValue(year: 2024, value: 6.8),
            YearValue(year: 2025, value: 7.4),
          ],
        ),
        const InflationPoint(
          countryCode: 'US',
          countryName: 'USA',
          year: 2025,
          value: 3.2,
          history: [
            YearValue(year: 2022, value: 8.0),
            YearValue(year: 2023, value: 3.4),
            YearValue(year: 2024, value: 2.9),
            YearValue(year: 2025, value: 3.2),
          ],
        ),
      ];

/// Getter [cryptoFeed] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static CryptoFeed get cryptoFeed => CryptoFeed(
        assets: [
          MarketAsset(
            id: 'bitcoin',
            symbol: 'BTC',
            name: 'Bitcoin',
            price: 67200,
            changePercent: 2.4,
            type: AssetType.crypto,
            sparkline: _spark(65000),
          ),
          MarketAsset(
            id: 'ethereum',
            symbol: 'ETH',
            name: 'Ethereum',
            price: 3450,
            changePercent: 1.8,
            type: AssetType.crypto,
            sparkline: _spark(3300),
          ),
        ],
        loadedPages: 1,
      );

/// Getter [stocks] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static List<MarketAsset> get stocks => [
        MarketAsset(
          id: 'IMOEX',
          symbol: 'IMOEX',
          name: 'IMOEX',
          price: 3185,
          changePercent: 0.85,
          type: AssetType.stockRu,
          currency: 'RUB',
          sparkline: _spark(3100),
        ),
        MarketAsset(
          id: 'SBER',
          symbol: 'SBER',
          name: 'Sberbank',
          price: 285,
          changePercent: 1.2,
          type: AssetType.stockRu,
          currency: 'RUB',
          sparkline: _spark(280),
        ),
      ];

/// Getter [bonds] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static List<MarketAsset> get bonds => [
        MarketAsset(
          id: 'SU26238',
          symbol: 'SU26238',
          name: 'ОФЗ 26238',
          price: 92.45,
          changePercent: 0.12,
          type: AssetType.bondRu,
          currency: 'RUB',
          yieldPercent: 14.2,
          couponPercent: 7.5,
          maturityDate: DateTime(2028, 3, 15),
          bondCategory: BondCategory.ofz,
          faceValue: 1000,
          sparkline: _spark(91.5, drift: 0.001),
        ),
        MarketAsset(
          id: 'RU000A108397',
          symbol: 'RU000A108397',
          name: 'Сбербанк БО',
          price: 98.1,
          changePercent: -0.05,
          type: AssetType.bondRu,
          currency: 'RUB',
          yieldPercent: 12.8,
          couponPercent: 8.0,
          maturityDate: DateTime(2027, 11, 24),
          bondCategory: BondCategory.corporate,
          faceValue: 1000,
          sparkline: _spark(97.8, drift: 0.0008),
        ),
      ];

/// Getter [usIndices] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static List<MarketAsset> get usIndices => [
        MarketAsset(
          id: 'SPY',
          symbol: 'SPY',
          name: 'S&P 500',
          price: 542.30,
          changePercent: 0.55,
          type: AssetType.stockUs,
          sparkline: _spark(535),
        ),
        MarketAsset(
          id: 'QQQ',
          symbol: 'QQQ',
          name: 'NASDAQ 100',
          price: 478.10,
          changePercent: 0.72,
          type: AssetType.stockUs,
          sparkline: _spark(470),
        ),
      ];

/// Getter [commodities] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static List<CommodityQuote> get commodities => [
        CommodityQuote(
          id: 'brent',
          name: 'Brent',
          price: 82.5,
          unit: 'USD/bbl',
          changePercent: -0.4,
        ),
        CommodityQuote(
          id: 'gold',
          name: 'Gold',
          price: 8450,
          unit: '₽/g',
          changePercent: 0.6,
        ),
        CommodityQuote(
          id: 'wti',
          name: 'WTI',
          price: 78.2,
          unit: 'USD/bbl',
          changePercent: 0.3,
        ),
      ];

/// Getter [fearGreed] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static FearGreedIndex get fearGreed => FearGreedIndex(
        value: 62,
        label: 'Greed',
        updatedAt: DateTime.now(),
      );

/// Getter [news] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static List<NewsItem> get news => [
        NewsItem(
          id: 1,
          headline: 'Demo: рынки растут на фоне смягчения ожиданий',
          summary: 'Демо-режим EcoPulse — данные для скриншотов.',
          source: 'Demo',
          url: 'https://example.com',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

/// Getter [macroEvents] класса [DemoFixtures].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static List<MacroEvent> get macroEvents => [
        MacroEvent(
          event: 'Demo: решение по ставке ФРС',
          country: 'US',
          date: DateTime.now().add(const Duration(days: 2)),
          time: '21:00',
          impact: 'high',
        ),
      ];
}
