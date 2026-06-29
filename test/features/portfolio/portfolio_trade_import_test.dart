// =============================================================================
// EcoPulse · test/features/portfolio/portfolio_trade_import_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: portfolio_trade_import.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_trade_import.dart';
import 'package:ecopulse/data/models/portfolio_trade.dart';

void main() {
  test('parseTradeJournalCsv reads EcoPulse export format', () {
    const csv = '''
datetime,kind,symbol,type,quantity,unit_price,currency,amount_rub,pnl_rub
2026-06-01T12:00:00.000Z,buy,SBER,stockRu,10,250.0000,RUB,2500.00,
2026-06-10T15:30:00.000Z,sell,SBER,stockRu,10,260.0000,RUB,2600.00,100.00
''';

    final result = parseTradeJournalCsv(csv, accountId: 'main');

    expect(result.importedCount, 2);
    expect(result.trades.first.symbol, 'SBER');
    expect(result.trades.first.kind, PortfolioTradeKind.buy);
    expect(result.trades.last.pnlRub, 100);
    expect(result.trades.every((t) => t.accountId == 'main'), isTrue);
  });

  test('parseTradeJournalCsv reads generic broker headers', () {
    const csv = '''
Date,Ticker,Operation,Quantity,Price,Sum
01.06.2026,SBER,Покупка,5,250,1250
02.06.2026,GAZP,Продажа,3,150,450
''';

    final result = parseTradeJournalCsv(csv, accountId: 'acc1');

    expect(result.importedCount, 2);
    expect(result.trades.first.kind, PortfolioTradeKind.buy);
    expect(result.trades.last.kind, PortfolioTradeKind.sell);
    expect(result.trades.first.quantity, 5);
  });

  test('parseTradeJournalCsv skips dividend rows', () {
    const csv = '''
date,ticker,operation,quantity,price
01.06.2026,SBER,Дивиденды,0,0
02.06.2026,SBER,Покупка,1,250
''';

    final result = parseTradeJournalCsv(csv, accountId: 'main');

    expect(result.importedCount, 1);
    expect(result.skippedRows, 1);
  });
}
