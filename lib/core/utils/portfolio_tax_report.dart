// =============================================================================
// EcoPulse · lib/core/utils/portfolio_tax_report.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Упрощённый локальный расчёт НДФЛ по бумажному портфелю (не налоговая консультация).
// =============================================================================

import '../../data/models/paper_portfolio_account.dart';
import '../../data/models/portfolio_position.dart';
import '../../data/models/portfolio_trade.dart';
import 'portfolio_income_calendar.dart';

/// Стандартная ставка НДФЛ для упрощённой оценки (2026).
const defaultNdflRate = 0.13;

/// Строка продажи в налоговом отчёте.
class PortfolioTaxSellRow {
  const PortfolioTaxSellRow({
    required this.trade,
    required this.pnlRub,
    required this.taxRub,
  });

  final PortfolioTrade trade;
  final double pnlRub;
  final double taxRub;
}

/// Упрощённый налоговый отчёт за календарный год.
class PortfolioTaxReport {
  const PortfolioTaxReport({
    required this.year,
    required this.realizedGainRub,
    required this.realizedLossRub,
    required this.netRealizedRub,
    required this.taxableBaseRub,
    required this.estimatedNdflRub,
    required this.ndflRate,
    required this.estimatedPassiveIncomeRub,
    required this.estimatedPassiveTaxRub,
    required this.totalEstimatedTaxRub,
    required this.unrealizedGainRub,
    required this.unrealizedLossRub,
    required this.sellCount,
    required this.isIisAccount,
    required this.sells,
  });

  final int year;
  final double realizedGainRub;
  final double realizedLossRub;
  final double netRealizedRub;
  final double taxableBaseRub;
  final double estimatedNdflRub;
  final double ndflRate;
  final double estimatedPassiveIncomeRub;
  final double estimatedPassiveTaxRub;
  final double totalEstimatedTaxRub;
  final double unrealizedGainRub;
  final double unrealizedLossRub;
  final int sellCount;
  final bool isIisAccount;
  final List<PortfolioTaxSellRow> sells;

  bool get hasData =>
      sellCount > 0 ||
      estimatedPassiveIncomeRub > 0 ||
      unrealizedGainRub > 0 ||
      unrealizedLossRub > 0;
}

/// Считает упрощённый налоговый отчёт.
PortfolioTaxReport buildPortfolioTaxReport({
  required int year,
  required List<PortfolioTrade> trades,
  required PortfolioSnapshot? snapshot,
  required PaperPortfolioKind accountKind,
  PortfolioIncomePlan? incomePlan,
  double ndflRate = defaultNdflRate,
}) {
  final yearTrades = trades.where((t) => t.at.year == year).toList();
  final sells = yearTrades
      .where((t) => t.kind == PortfolioTradeKind.sell)
      .toList();

  var gain = 0.0;
  var loss = 0.0;
  final sellRows = <PortfolioTaxSellRow>[];

  for (final t in sells) {
    final pnl = t.pnlRub ?? 0;
    if (pnl >= 0) {
      gain += pnl;
    } else {
      loss += pnl.abs();
    }
    final rowTax = pnl > 0 ? pnl * ndflRate : 0.0;
    sellRows.add(PortfolioTaxSellRow(trade: t, pnlRub: pnl, taxRub: rowTax));
  }

  final netRealized = gain - loss;
  final taxableBase = netRealized > 0 ? netRealized : 0.0;

  var passiveIncome = 0.0;
  if (incomePlan != null) {
    for (final e in incomePlan.events) {
      if (e.date.year == year) passiveIncome += e.amountRub;
    }
  }

  var unrealizedGain = 0.0;
  var unrealizedLoss = 0.0;
  if (snapshot != null) {
    for (final ps in snapshot.positions) {
      if (ps.pnlRub >= 0) {
        unrealizedGain += ps.pnlRub;
      } else {
        unrealizedLoss += ps.pnlRub.abs();
      }
    }
  }

  final isIis = accountKind == PaperPortfolioKind.iis;
  final tradingTax = isIis ? 0.0 : taxableBase * ndflRate;
  final passiveTax = isIis ? 0.0 : passiveIncome * ndflRate;

  return PortfolioTaxReport(
    year: year,
    realizedGainRub: gain,
    realizedLossRub: loss,
    netRealizedRub: netRealized,
    taxableBaseRub: taxableBase,
    estimatedNdflRub: tradingTax,
    ndflRate: ndflRate,
    estimatedPassiveIncomeRub: passiveIncome,
    estimatedPassiveTaxRub: passiveTax,
    totalEstimatedTaxRub: tradingTax + passiveTax,
    unrealizedGainRub: unrealizedGain,
    unrealizedLossRub: unrealizedLoss,
    sellCount: sells.length,
    isIisAccount: isIis,
    sells: sellRows,
  );
}

/// Экспорт отчёта в CSV.
String portfolioTaxReportToCsv(PortfolioTaxReport report) {
  final buf = StringBuffer()
    ..writeln('year,${report.year}')
    ..writeln('realized_gain_rub,${report.realizedGainRub.toStringAsFixed(2)}')
    ..writeln('realized_loss_rub,${report.realizedLossRub.toStringAsFixed(2)}')
    ..writeln('net_realized_rub,${report.netRealizedRub.toStringAsFixed(2)}')
    ..writeln('taxable_base_rub,${report.taxableBaseRub.toStringAsFixed(2)}')
    ..writeln('ndfl_rate,${report.ndflRate}')
    ..writeln('estimated_ndfl_rub,${report.estimatedNdflRub.toStringAsFixed(2)}')
    ..writeln(
      'passive_income_rub,${report.estimatedPassiveIncomeRub.toStringAsFixed(2)}',
    )
    ..writeln(
      'passive_tax_rub,${report.estimatedPassiveTaxRub.toStringAsFixed(2)}',
    )
    ..writeln(
      'total_tax_rub,${report.totalEstimatedTaxRub.toStringAsFixed(2)}',
    )
    ..writeln()
    ..writeln('datetime,symbol,pnl_rub,tax_rub');

  for (final row in report.sells) {
    buf.writeln([
      row.trade.at.toIso8601String(),
      row.trade.symbol,
      row.pnlRub.toStringAsFixed(2),
      row.taxRub.toStringAsFixed(2),
    ].join(','));
  }

  return buf.toString();
}
