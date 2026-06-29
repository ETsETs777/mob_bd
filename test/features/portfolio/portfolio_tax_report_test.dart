// =============================================================================
// EcoPulse · test/features/portfolio/portfolio_tax_report_test.dart
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/portfolio_tax_report.dart';
import 'package:ecopulse/data/models/paper_portfolio_account.dart';
import 'package:ecopulse/data/models/portfolio_trade.dart';

void main() {
  test('buildPortfolioTaxReport nets gains and losses', () {
    final trades = [
      PortfolioTrade(
        id: '1',
        kind: PortfolioTradeKind.sell,
        symbol: 'SBER',
        assetKey: 'stockRu:SBER',
        assetType: 'stockRu',
        quantity: 10,
        unitPrice: 300,
        currency: 'RUB',
        amountRub: 3000,
        at: DateTime(2026, 3, 1),
        pnlRub: 500,
      ),
      PortfolioTrade(
        id: '2',
        kind: PortfolioTradeKind.sell,
        symbol: 'GAZP',
        assetKey: 'stockRu:GAZP',
        assetType: 'stockRu',
        quantity: 5,
        unitPrice: 150,
        currency: 'RUB',
        amountRub: 750,
        at: DateTime(2026, 5, 1),
        pnlRub: -200,
      ),
    ];

    final report = buildPortfolioTaxReport(
      year: 2026,
      trades: trades,
      snapshot: null,
      accountKind: PaperPortfolioKind.main,
    );

    expect(report.realizedGainRub, 500);
    expect(report.realizedLossRub, 200);
    expect(report.netRealizedRub, 300);
    expect(report.taxableBaseRub, 300);
    expect(report.estimatedNdflRub, closeTo(39, 0.01));
    expect(report.sellCount, 2);
  });

  test('IIS account shows zero estimated tax', () {
    final report = buildPortfolioTaxReport(
      year: 2026,
      trades: [
        PortfolioTrade(
          id: '1',
          kind: PortfolioTradeKind.sell,
          symbol: 'SBER',
          assetKey: 'stockRu:SBER',
          assetType: 'stockRu',
          quantity: 1,
          unitPrice: 300,
          currency: 'RUB',
          amountRub: 300,
          at: DateTime(2026, 1, 1),
          pnlRub: 1000,
        ),
      ],
      snapshot: null,
      accountKind: PaperPortfolioKind.iis,
    );

    expect(report.isIisAccount, isTrue);
    expect(report.estimatedNdflRub, 0);
    expect(report.totalEstimatedTaxRub, 0);
  });

  test('portfolioTaxReportToCsv includes summary rows', () {
    final report = buildPortfolioTaxReport(
      year: 2026,
      trades: const [],
      snapshot: null,
      accountKind: PaperPortfolioKind.main,
    );

    final csv = portfolioTaxReportToCsv(report);
    expect(csv, contains('year,2026'));
    expect(csv, contains('estimated_ndfl_rub'));
  });
}
