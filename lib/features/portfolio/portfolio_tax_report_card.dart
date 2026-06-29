// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_tax_report_card.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_tax_report.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio/portfolio_tax_report_provider.dart';
import 'portfolio_tax_report_screen.dart';

/// Карточка упрощённого налогового отчёта.
class PortfolioTaxReportCard extends ConsumerWidget {
  const PortfolioTaxReportCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final report = ref.watch(portfolioTaxReportProvider);
    final years = ref.watch(portfolioTaxAvailableYearsProvider);
    final selectedYear = ref.watch(portfolioTaxYearProvider);

    if (report == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.receipt_2, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioTaxTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => openAppPage(
                    context,
                    const PortfolioTaxReportScreen(),
                  ),
                  child: Text(l10n.portfolioTaxOpenDetails),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.portfolioTaxSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              children: years.take(4).map((year) {
                return FilterChip(
                  label: Text(year.toString()),
                  selected: selectedYear == year,
                  onSelected: (_) =>
                      ref.read(portfolioTaxYearProvider.notifier).state = year,
                );
              }).toList(),
            ),
            const Gap(12),
            _TaxMetric(
              label: l10n.portfolioTaxNetRealized,
              value: Formatters.rub(report.netRealizedRub),
              palette: palette,
              valueColor: report.netRealizedRub >= 0
                  ? palette.positive
                  : palette.negative,
            ),
            const Gap(8),
            _TaxMetric(
              label: l10n.portfolioTaxEstimatedNdfl,
              value: Formatters.rub(report.totalEstimatedTaxRub),
              palette: palette,
              bold: true,
            ),
            if (report.estimatedPassiveIncomeRub > 0) ...[
              const Gap(8),
              _TaxMetric(
                label: l10n.portfolioTaxPassiveIncome,
                value: Formatters.rub(report.estimatedPassiveIncomeRub),
                palette: palette,
              ),
            ],
            if (report.isIisAccount) ...[
              const Gap(12),
              Text(
                l10n.portfolioTaxIisNote,
                style: TextStyle(fontSize: 11, color: palette.textSecondary),
              ),
            ],
            const Gap(12),
            Text(
              l10n.portfolioTaxDisclaimer,
              style: TextStyle(fontSize: 11, color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxMetric extends StatelessWidget {
  const _TaxMetric({
    required this.label,
    required this.value,
    required this.palette,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final AppPalette palette;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: palette.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? palette.textPrimary,
          ),
        ),
      ],
    );
  }
}
