// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_tax_report_screen.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_tax_report.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio/portfolio_tax_report_provider.dart';

/// Полный экран налогового отчёта с экспортом CSV.
class PortfolioTaxReportScreen extends ConsumerWidget {
  const PortfolioTaxReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final report = ref.watch(portfolioTaxReportProvider);
    final years = ref.watch(portfolioTaxAvailableYearsProvider);
    final selectedYear = ref.watch(portfolioTaxYearProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.portfolioTaxTitle),
        actions: [
          if (report != null)
            IconButton(
              icon: const Icon(Iconsax.document_download),
              tooltip: l10n.portfolioTaxExport,
              onPressed: () {
                Share.share(
                  portfolioTaxReportToCsv(report),
                  subject: l10n.portfolioTaxTitle,
                );
              },
            ),
        ],
      ),
      body: report == null
          ? Center(
              child: Text(
                l10n.portfolioTaxEmpty,
                style: TextStyle(color: palette.textSecondary),
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  spacing: 8,
                  children: years.map((year) {
                    return FilterChip(
                      label: Text(year.toString()),
                      selected: selectedYear == year,
                      onSelected: (_) => ref
                          .read(portfolioTaxYearProvider.notifier)
                          .state = year,
                    );
                  }).toList(),
                ),
                const Gap(16),
                _Section(
                  title: l10n.portfolioTaxSectionTrading,
                  palette: palette,
                  children: [
                    _Row(l10n.portfolioTaxRealizedGain, report.realizedGainRub, palette: palette),
                    _Row(l10n.portfolioTaxRealizedLoss, report.realizedLossRub, palette: palette),
                    _Row(
                      l10n.portfolioTaxNetRealized,
                      report.netRealizedRub,
                      palette: palette,
                      highlight: true,
                    ),
                    _Row(l10n.portfolioTaxTaxableBase, report.taxableBaseRub, palette: palette),
                    _Row(
                      l10n.portfolioTaxEstimatedNdfl,
                      report.estimatedNdflRub,
                      palette: palette,
                      highlight: true,
                    ),
                    _Row(
                      l10n.portfolioTaxSellCount,
                      report.sellCount.toDouble(),
                      palette: palette,
                      asCount: true,
                    ),
                  ],
                ),
                const Gap(12),
                _Section(
                  title: l10n.portfolioTaxSectionPassive,
                  palette: palette,
                  children: [
                    _Row(
                      l10n.portfolioTaxPassiveIncome,
                      report.estimatedPassiveIncomeRub,
                      palette: palette,
                    ),
                    _Row(
                      l10n.portfolioTaxPassiveTax,
                      report.estimatedPassiveTaxRub,
                      palette: palette,
                    ),
                  ],
                ),
                const Gap(12),
                _Section(
                  title: l10n.portfolioTaxSectionUnrealized,
                  palette: palette,
                  children: [
                    _Row(
                      l10n.portfolioTaxUnrealizedGain,
                      report.unrealizedGainRub,
                      palette: palette,
                    ),
                    _Row(
                      l10n.portfolioTaxUnrealizedLoss,
                      report.unrealizedLossRub,
                      palette: palette,
                    ),
                  ],
                ),
                const Gap(12),
                Card(
                  color: palette.surfaceLight,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.portfolioTaxTotalLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          Formatters.rub(report.totalEstimatedTaxRub),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: palette.accent,
                          ),
                        ),
                        Text(
                          l10n.portfolioTaxRateLabel(
                            (report.ndflRate * 100).toStringAsFixed(0),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (report.isIisAccount) ...[
                  const Gap(12),
                  Text(
                    l10n.portfolioTaxIisNote,
                    style: TextStyle(fontSize: 12, color: palette.textSecondary),
                  ),
                ],
                const Gap(12),
                Text(
                  l10n.portfolioTaxDisclaimer,
                  style: TextStyle(fontSize: 11, color: palette.textSecondary),
                ),
                if (report.sells.isNotEmpty) ...[
                  const Gap(20),
                  Text(
                    l10n.portfolioTaxSellsHeader,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                  const Gap(8),
                  ...report.sells.map(
                    (row) => Card(
                      child: ListTile(
                        title: Text(
                          '${row.trade.symbol} · '
                          '${Formatters.formatJournalPreview(row.trade.at)}',
                        ),
                        subtitle: Text(
                          l10n.portfolioTaxSellPnl(Formatters.rub(row.pnlRub)),
                        ),
                        trailing: Text(
                          Formatters.rub(row.taxRub),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.palette,
    required this.children,
  });

  final String title;
  final AppPalette palette;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: palette.accent,
              ),
            ),
            const Gap(12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
    this.label,
    this.value, {
    required this.palette,
    this.highlight = false,
    this.asCount = false,
  });

  final String label;
  final double value;
  final AppPalette palette;
  final bool highlight;
  final bool asCount;

  @override
  Widget build(BuildContext context) {
    final text = asCount ? value.toInt().toString() : Formatters.rub(value);
    final color = !asCount && value != 0
        ? (value >= 0 ? palette.positive : palette.negative)
        : palette.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: palette.textSecondary,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
