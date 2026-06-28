import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/chart_share.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import 'bond_analytics_hero_title.dart';
import 'bond_yield_curve_table.dart';
import 'ofz_yield_curve_chart.dart';

/// StatefulWidget [OfzYieldCurveScreen] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class OfzYieldCurveScreen extends StatefulWidget {
/// Создаёт [OfzYieldCurveScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  const OfzYieldCurveScreen({super.key, required this.bonds});

/// Поле [bonds] класса [OfzYieldCurveScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final List<MarketAsset> bonds;

/// Создаёт State для [OfzYieldCurveScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  @override
  State<OfzYieldCurveScreen> createState() => _OfzYieldCurveScreenState();
}

/// Приватный класс [_OfzYieldCurveScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class _OfzYieldCurveScreenState extends State<OfzYieldCurveScreen> {
/// Поле [_chartKey] класса [_OfzYieldCurveScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final _chartKey = GlobalKey();

/// Отрисовывает UI [_OfzYieldCurveScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final curve = buildOfzYieldCurve(widget.bonds);
    final avg = averageOfzYield(widget.bonds);
    final spread = ofzYieldSpread(widget.bonds);

    return Scaffold(
      appBar: AppBar(
        title: BondAnalyticsHeroTitle(
          tag: BondAnalyticsHero.yieldCurve,
          text: l10n.bondYieldCurveTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_3),
            tooltip: l10n.shareChart,
            onPressed: () => shareWidgetAsPng(
              boundaryKey: _chartKey,
              fileName: 'ofz_yield_curve.png',
              text: 'EcoPulse · ${l10n.bondYieldCurveTitle}',
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sideBySide =
              constraints.maxWidth >= AppBreakpoints.bondAnalyticsSideBySide;

          final header = _YieldCurveHeader(
            l10n: l10n,
            palette: palette,
            avg: avg,
            spread: spread,
          );

          final chart = ChartCaptureBoundary(
            captureKey: _chartKey,
            child: OfzYieldCurveChart(
              bonds: widget.bonds,
              height: sideBySide ? 360 : 320,
              enableZoom: true,
            ),
          );

          if (!sideBySide || curve.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.page),
              children: [
                header,
                const Gap(AppSpacing.md),
                chart,
                if (curve.isNotEmpty) ...[
                  const Gap(AppSpacing.lg),
                  BondYieldCurveTable(curve: curve),
                ],
              ],
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const Gap(AppSpacing.md),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 3, child: chart),
                      const Gap(AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: BondYieldCurveTable(curve: curve),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Приватный класс [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _YieldCurveHeader extends StatelessWidget {
/// Создаёт [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _YieldCurveHeader({
    required this.l10n,
    required this.palette,
    required this.avg,
    required this.spread,
  });

/// Поле [l10n] класса [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final AppLocalizations l10n;
/// Поле [palette] класса [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final AppPalette palette;
/// Поле [avg] класса [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final double? avg;
/// Поле [spread] класса [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final double? spread;

/// Отрисовывает UI [_YieldCurveHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avg != null || spread != null)
          Wrap(
            spacing: AppSpacing.sm + 4,
            runSpacing: AppSpacing.sm,
            children: [
              if (avg != null)
                _StatChip(
                  label: l10n.bondHomeAvgYield,
                  value: Formatters.bondYield(avg),
                  palette: palette,
                ),
              if (spread != null)
                _StatChip(
                  label: l10n.bondYieldSpreadLabel,
                  value: l10n.bondYieldSpreadValue(spread!.toStringAsFixed(2)),
                  palette: palette,
                ),
            ],
          ),
        if (avg != null || spread != null) const Gap(AppSpacing.md),
        Text(
          l10n.bondYieldCurveSubtitle,
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

/// Приватный класс [_StatChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class _StatChip extends StatelessWidget {
/// Создаёт [_StatChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const _StatChip({
    required this.label,
    required this.value,
    required this.palette,
  });

/// Поле [label] класса [_StatChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final String label;
/// Поле [value] класса [_StatChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final String value;
/// Поле [palette] класса [_StatChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_StatChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: palette.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Функция [openOfzYieldCurveScreen] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
void openOfzYieldCurveScreen(BuildContext context, List<MarketAsset> bonds) {
  openBondAnalyticsPage(context, OfzYieldCurveScreen(bonds: bonds));
}
