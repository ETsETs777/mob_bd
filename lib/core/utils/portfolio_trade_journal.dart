// =============================================================================
// EcoPulse · lib/core/utils/portfolio_trade_journal.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Сводка и экспорт журнала сделок.
// =============================================================================

import '../../data/models/portfolio_trade.dart';

/// Сводка по журналу сделок.
class PortfolioTradeJournalStats {
  const PortfolioTradeJournalStats({
    required this.totalTrades,
    required this.buyCount,
    required this.sellCount,
    required this.realizedPnlRub,
    required this.totalBuyRub,
    required this.totalSellRub,
  });

  final int totalTrades;
  final int buyCount;
  final int sellCount;
  final double realizedPnlRub;
  final double totalBuyRub;
  final double totalSellRub;
}

/// Считает сводку по списку сделок.
PortfolioTradeJournalStats buildTradeJournalStats(List<PortfolioTrade> trades) {
  var buys = 0;
  var sells = 0;
  var realized = 0.0;
  var buyRub = 0.0;
  var sellRub = 0.0;

  for (final t in trades) {
    switch (t.kind) {
      case PortfolioTradeKind.buy:
        buys++;
        buyRub += t.amountRub;
      case PortfolioTradeKind.sell:
        sells++;
        sellRub += t.amountRub;
        realized += t.pnlRub ?? 0;
    }
  }

  return PortfolioTradeJournalStats(
    totalTrades: trades.length,
    buyCount: buys,
    sellCount: sells,
    realizedPnlRub: realized,
    totalBuyRub: buyRub,
    totalSellRub: sellRub,
  );
}

/// Экспорт журнала в CSV.
String tradeJournalToCsv(List<PortfolioTrade> trades) {
  final buf = StringBuffer()
    ..writeln(
      'datetime,kind,symbol,type,quantity,unit_price,currency,amount_rub,pnl_rub',
    );

  for (final t in trades) {
    buf.writeln([
      t.at.toIso8601String(),
      t.kind.name,
      _csv(t.symbol),
      _csv(t.assetType),
      t.quantity.toStringAsFixed(4),
      t.unitPrice.toStringAsFixed(4),
      _csv(t.currency),
      t.amountRub.toStringAsFixed(2),
      t.pnlRub?.toStringAsFixed(2) ?? '',
    ].join(','));
  }

  return buf.toString();
}

String _csv(String value) {
  if (value.contains(',') || value.contains('"')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
