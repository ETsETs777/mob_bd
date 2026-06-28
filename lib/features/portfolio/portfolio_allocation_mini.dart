// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_allocation_mini.dart
// Автор: Цымбал Е. В.
// Дата: 11.06.2026
// Бумажный портфель, аллокация, P&L. Файл: portfolio_allocation_mini.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/portfolio_math.dart';
import '../../data/models/portfolio_position.dart';
import '../../l10n/app_localizations.dart';
import 'portfolio_allocation_pie.dart';

/// Компактная аллокация для главной: mini pie + легенда.
class PortfolioAllocationMini extends StatelessWidget {
/// Создаёт [PortfolioAllocationMini].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  const PortfolioAllocationMini({
    super.key,
    required this.snapshot,
  });

/// Поле [snapshot] класса [PortfolioAllocationMini].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final PortfolioSnapshot snapshot;

/// Отрисовывает UI [PortfolioAllocationMini].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final slices = buildPortfolioAllocation(snapshot);
    if (slices.length < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Text(
          l10n.portfolioAllocationTitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: palette.textSecondary,
          ),
        ),
        const Gap(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PortfolioAllocationPie(
              slices: slices,
              size: 64,
              centerSpaceRadius: 18,
              sectionRadius: 22,
              showSectionLabels: false,
            ),
            const Gap(12),
            Expanded(
              child: PortfolioAllocationLegend(
                slices: slices,
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
