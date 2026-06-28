// =============================================================================
// EcoPulse · lib/core/utils/portfolio_export.dart
// Автор: Цымбал Е. В.
// Дата: 09.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: portfolio_export.
// =============================================================================

import '../../data/models/portfolio_position.dart';

/// Функция [portfolioToCsv] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
String portfolioToCsv(PortfolioSnapshot snapshot) {
  final buf = StringBuffer()
    ..writeln('symbol,type,quantity,buy_price,currency,cost_rub,value_rub,pnl_rub,pnl_percent');

  for (final ps in snapshot.positions) {
    final p = ps.position;
    buf.writeln([
      _csvCell(p.symbol),
      _csvCell(p.type.name),
      p.quantity.toStringAsFixed(4),
      p.buyPrice.toStringAsFixed(4),
      _csvCell(p.currency),
      ps.costRub.toStringAsFixed(2),
      ps.valueRub.toStringAsFixed(2),
      ps.pnlRub.toStringAsFixed(2),
      ps.pnlPercent.toStringAsFixed(2),
    ].join(','));
  }

  buf.writeln();
  buf.writeln('summary,,,,,,,,');
  buf.writeln([
    'TOTAL',
    '',
    '',
    '',
    '',
    snapshot.investedRub.toStringAsFixed(2),
    (snapshot.totalValueRub - snapshot.portfolio.cashRub).toStringAsFixed(2),
    snapshot.pnlRub.toStringAsFixed(2),
    snapshot.pnlPercent.toStringAsFixed(2),
  ].join(','));
  buf.writeln([
    'CASH_RUB',
    '',
    '',
    '',
    '',
    snapshot.portfolio.cashRub.toStringAsFixed(2),
    '',
    '',
    '',
  ].join(','));

  return buf.toString();
}

/// Приватная функция [_csvCell].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
String _csvCell(String value) {
  if (value.contains(',') || value.contains('"')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
