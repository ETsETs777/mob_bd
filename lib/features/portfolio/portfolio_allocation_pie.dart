// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_allocation_pie.dart
// Автор: Цымбал Е. В.
// Дата: 12.06.2026
// Бумажный портфель, аллокация, P&L. Файл: portfolio_allocation_pie.
// =============================================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/portfolio_math.dart';
import '../../l10n/app_localizations.dart';
import 'portfolio_allocation_card.dart';

/// Анимированная pie-диаграмма аллокации портфеля.
class PortfolioAllocationPie extends StatelessWidget {
/// Создаёт [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const PortfolioAllocationPie({
    super.key,
    required this.slices,
    this.size = 160,
    this.centerSpaceRadius = 36,
    this.sectionRadius = 52,
    this.showSectionLabels = true,
    this.labelThresholdPct = 8,
  });

/// Поле [slices] класса [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final List<PortfolioAllocationSlice> slices;
/// Поле [size] класса [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final double size;
/// Поле [centerSpaceRadius] класса [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  final double centerSpaceRadius;
/// Поле [sectionRadius] класса [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final double sectionRadius;
/// Поле [showSectionLabels] класса [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final bool showSectionLabels;
/// Поле [labelThresholdPct] класса [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final double labelThresholdPct;

/// Отрисовывает UI [PortfolioAllocationPie].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  Widget build(BuildContext context) {
    if (slices.length < 2) return const SizedBox.shrink();

    final palette = AppPalette.of(context);
    final total = slices.fold<double>(0, (s, e) => s + e.valueRub);
    final colors = PortfolioAllocationCard.colorsFor(palette);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.duration(context, AppMotion.slow),
      curve: AppMotion.emphasized,
      builder: (context, t, _) {
        return SizedBox(
          width: size,
          height: size,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: centerSpaceRadius,
              sections: slices.map((slice) {
                final pct =
                    total == 0 ? 0.0 : slice.valueRub / total * 100;
                return PieChartSectionData(
                  value: slice.valueRub * t,
                  color: colors[slice.key] ?? palette.accent,
                  radius: sectionRadius,
                  title: showSectionLabels && pct >= labelThresholdPct && t > 0.85
                      ? '${pct.toStringAsFixed(0)}%'
                      : '',
                  titleStyle: TextStyle(
                    fontSize: size < 80 ? 9 : 11,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                );
              }).toList(),
            ),
            duration: Duration.zero,
          ),
        );
      },
    );
  }
}

/// Легенда аллокации (точки + проценты).
class PortfolioAllocationLegend extends StatelessWidget {
/// Создаёт [PortfolioAllocationLegend].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  const PortfolioAllocationLegend({
    super.key,
    required this.slices,
    this.dense = false,
  });

/// Поле [slices] класса [PortfolioAllocationLegend].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final List<PortfolioAllocationSlice> slices;
/// Поле [dense] класса [PortfolioAllocationLegend].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final bool dense;

/// Отрисовывает UI [PortfolioAllocationLegend].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final total = slices.fold<double>(0, (s, e) => s + e.valueRub);
    final colors = PortfolioAllocationCard.colorsFor(palette);
    final fontSize = dense ? 11.0 : 12.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: slices.map((slice) {
        final pct = total == 0 ? 0.0 : slice.valueRub / total * 100;
        return Padding(
          padding: EdgeInsets.only(bottom: dense ? 4 : 6),
          child: Row(
            children: [
              Container(
                width: dense ? 8 : 10,
                height: dense ? 8 : 10,
                decoration: BoxDecoration(
                  color: colors[slice.key],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: dense ? 6 : 8),
              Expanded(
                child: Text(
                  PortfolioAllocationCard.labelFor(slice.key, l10n),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Text(
                '${pct.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
