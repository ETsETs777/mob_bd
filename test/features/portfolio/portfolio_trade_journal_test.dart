// =============================================================================
// EcoPulse · test/portfolio_trade_journal_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: portfolio_trade_journal.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_trade_journal.dart';
import 'package:ecopulse/data/models/portfolio_trade.dart';

void main() {
  test('buildTradeJournalStats sums buys sells and realized pnl', () {
    final trades = [
      PortfolioTrade(
        id: '1',
        kind: PortfolioTradeKind.buy,
        symbol: 'SBER',
        assetKey: 'stockRu:SBER',
        assetType: 'stockRu',
        quantity: 10,
        unitPrice: 250,
        currency: 'RUB',
        amountRub: 2500,
        at: DateTime(2026, 6, 1),
      ),
      PortfolioTrade(
        id: '2',
        kind: PortfolioTradeKind.sell,
        symbol: 'SBER',
        assetKey: 'stockRu:SBER',
        assetType: 'stockRu',
        quantity: 10,
        unitPrice: 260,
        currency: 'RUB',
        amountRub: 2600,
        at: DateTime(2026, 6, 10),
        pnlRub: 100,
      ),
    ];

    final stats = buildTradeJournalStats(trades);

    expect(stats.totalTrades, 2);
    expect(stats.buyCount, 1);
    expect(stats.sellCount, 1);
    expect(stats.totalBuyRub, 2500);
    expect(stats.totalSellRub, 2600);
    expect(stats.realizedPnlRub, 100);
  });

  test('tradeJournalToCsv includes header and trade row', () {
    final csv = tradeJournalToCsv([
      PortfolioTrade(
        id: '1',
        kind: PortfolioTradeKind.buy,
        symbol: 'BTC',
        assetKey: 'crypto:btc',
        assetType: 'crypto',
        quantity: 0.1,
        unitPrice: 50000,
        currency: 'USD',
        amountRub: 450000,
        at: DateTime(2026, 6, 1, 12, 0),
      ),
    ]);

    expect(csv, contains('datetime,kind,symbol'));
    expect(csv, contains('BTC'));
    expect(csv, contains('buy'));
  });

  test('PortfolioTrade json roundtrip', () {
    final original = PortfolioTrade(
      id: 'x',
      kind: PortfolioTradeKind.sell,
      symbol: 'GAZP',
      assetKey: 'stockRu:GAZP',
      assetType: 'stockRu',
      quantity: 5,
      unitPrice: 150,
      currency: 'RUB',
      amountRub: 750,
      at: DateTime(2026, 6, 15),
      pnlRub: -20,
    );

    final restored = PortfolioTrade.fromJson(original.toJson());

    expect(restored.symbol, 'GAZP');
    expect(restored.kind, PortfolioTradeKind.sell);
    expect(restored.pnlRub, -20);
  });
}
