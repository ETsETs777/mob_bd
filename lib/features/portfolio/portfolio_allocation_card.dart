// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_allocation_card.dart
// Автор: Цымбал Е. В.
// Дата: 11.06.2026
// Бумажный портфель, аллокация, P&L. Файл: portfolio_allocation_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_math.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/portfolio_position.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/portfolio_customization_provider.dart';
import '../shared/widgets/custom_chart_view.dart';
import 'portfolio_allocation_pie.dart';

/// StatelessWidget [PortfolioAllocationCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class PortfolioAllocationCard extends ConsumerWidget {
/// Создаёт [PortfolioAllocationCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const PortfolioAllocationCard({
    super.key,
    required this.snapshot,
  });

/// Поле [snapshot] класса [PortfolioAllocationCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final PortfolioSnapshot snapshot;

/// Отрисовывает UI [PortfolioAllocationCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final portfolioConfig = ref.watch(resolvedPortfolioProvider);
    final slices = buildPortfolioAllocation(snapshot);
    if (slices.length < 2) return const SizedBox.shrink();

    final total = slices.fold<double>(0, (s, e) => s + e.valueRub);
    final labels = slices
        .map((s) => PortfolioAllocationCard.labelFor(s.key, l10n))
        .toList();
    final values = slices.map((s) => s.valueRub).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.portfolioAllocationTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: palette.accent,
              ),
            ),
            const Gap(4),
            Text(
              l10n.portfolioAllocationSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(16),
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: CustomChartView(
                        contextId: ChartContextId.portfolio,
                        height: 160,
                        overrideType: portfolioConfig.allocationChartType,
                        input: ChartRenderInput(
                          pieLabels: labels,
                          pieValues: values,
                          barLabels: labels,
                          barValues: values,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: PortfolioAllocationLegend(slices: slices),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Text(
              l10n.portfolioAllocationTotal(Formatters.rub(total)),
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

/// Метод [colorsFor] класса [PortfolioAllocationCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  static Map<String, Color> colorsFor(AppPalette palette) => {
        'cash': palette.textSecondary,
        'crypto': const Color(0xFFF7931A),
        'stocks': palette.accent,
        'bonds': palette.positive,
      };

/// Метод [labelFor] класса [PortfolioAllocationCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  static String labelFor(String key, AppLocalizations l10n) => switch (key) {
        'cash' => l10n.portfolioAllocationCash,
        'crypto' => l10n.portfolioAllocationCrypto,
        'stocks' => l10n.portfolioAllocationStocks,
        'bonds' => l10n.portfolioAllocationBonds,
        _ => key,
      };
}
