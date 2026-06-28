// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_income_card.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Календарь купонов, дивидendов и погашений портфеля.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_income_calendar.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio_income_provider.dart';

/// Карточка календаря денежных поступлений по портфелю.
class PortfolioIncomeCard extends ConsumerWidget {
  const PortfolioIncomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final plan = ref.watch(portfolioIncomeProvider);
    final locale = Localizations.localeOf(context).languageCode;

    if (plan == null || plan.events.isEmpty) return const SizedBox.shrink();

    final monthEntries = plan.byMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.calendar_1, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.portfolioIncomeTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.portfolioIncomeSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _IncomeMetric(
                    label: l10n.portfolioIncomeNext30,
                    value: Formatters.rub(plan.totalNext30Days),
                    palette: palette,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _IncomeMetric(
                    label: l10n.portfolioIncomeNext90,
                    value: Formatters.rub(plan.totalNext90Days),
                    palette: palette,
                  ),
                ),
              ],
            ),
            if (monthEntries.isNotEmpty) ...[
              const Gap(12),
              Text(
                l10n.portfolioIncomeByMonth,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
              const Gap(6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: monthEntries.take(4).map((e) {
                  final parts = e.key.split('-');
                  final monthLabel = parts.length == 2
                      ? DateFormat.MMM(locale).format(
                          DateTime(int.parse(parts[0]), int.parse(parts[1])),
                        )
                      : e.key;
                  return Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      l10n.portfolioIncomeMonthChip(
                        monthLabel,
                        Formatters.compact(e.value),
                      ),
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                }).toList(),
              ),
            ],
            const Gap(12),
            Text(
              l10n.portfolioIncomeUpcoming,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
              ),
            ),
            const Gap(4),
            ...plan.upcoming.map(
              (e) => _IncomeEventTile(event: e, l10n: l10n),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeMetric extends StatelessWidget {
  const _IncomeMetric({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: palette.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeEventTile extends StatelessWidget {
  const _IncomeEventTile({required this.event, required this.l10n});

  final PortfolioIncomeEvent event;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final (IconData icon, Color color, String subtitle) = switch (event.type) {
      PortfolioIncomeEventType.bondMaturity => (
          Iconsax.flag,
          palette.negative,
          l10n.portfolioIncomeMaturity,
        ),
      PortfolioIncomeEventType.bondCoupon => (
          Iconsax.money_recive,
          palette.positive,
          l10n.portfolioIncomeCoupon,
        ),
      PortfolioIncomeEventType.bondCouponEstimate => (
          Iconsax.money_recive,
          palette.positive,
          l10n.portfolioIncomeCouponEstimate,
        ),
      PortfolioIncomeEventType.stockDividendEstimate => (
          Iconsax.wallet_3,
          palette.accent,
          l10n.portfolioIncomeDividendEstimate,
        ),
    };

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, size: 16, color: color),
      ),
      title: Text(
        event.symbol,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: palette.textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Formatters.rub(event.amountRub),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          Text(
            Formatters.date(event.date),
            style: TextStyle(fontSize: 10, color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
