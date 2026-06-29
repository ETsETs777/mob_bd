import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/portfolio_tax_report.dart';
import '../../data/models/paper_portfolio_account.dart';
import '../paper_portfolio_provider.dart';
import '../portfolio_income_provider.dart';
import '../portfolio_trade_journal_provider.dart';

/// Выбранный год для налогового отчёта.
final portfolioTaxYearProvider = StateProvider<int>(
  (ref) => DateTime.now().year,
);

/// Упрощённый налоговый отчёт активного счёта.
final portfolioTaxReportProvider = Provider<PortfolioTaxReport?>((ref) {
  final year = ref.watch(portfolioTaxYearProvider);
  final trades = ref.watch(activeAccountTradeJournalProvider);
  final snapshot = ref.watch(portfolioSnapshotProvider);
  final account = ref.watch(activePaperPortfolioAccountProvider);
  final income = ref.watch(portfolioIncomeProvider);

  final report = buildPortfolioTaxReport(
    year: year,
    trades: trades,
    snapshot: snapshot,
    accountKind: account.kind,
    incomePlan: income,
  );

  if (!report.hasData) return null;
  return report;
});

/// Доступные годы для выбора (из журнала + текущий).
final portfolioTaxAvailableYearsProvider = Provider<List<int>>((ref) {
  final trades = ref.watch(activeAccountTradeJournalProvider);
  final current = DateTime.now().year;
  final years = {current};
  for (final t in trades) {
    years.add(t.at.year);
  }
  final list = years.toList()..sort((a, b) => b.compareTo(a));
  return list;
});
