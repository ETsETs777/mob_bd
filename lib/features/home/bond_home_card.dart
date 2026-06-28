// =============================================================================
// EcoPulse · lib/features/home/bond_home_card.dart
// Автор: Цымбал Е. В.
// Дата: 04.06.2026
// Главный экран и виджеты секций. Файл: bond_home_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/stock_market_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../shared/widgets/app_card.dart';
import '../shared/widgets/motion_widgets.dart';
import '../markets/bond_calendar_screen.dart';
import '../markets/ofz_yield_curve_screen.dart';

/// Сводка по ОФЗ на главной: средняя YTM, спред и ближайшие события.
class BondHomeCard extends ConsumerWidget {
/// Создаёт [BondHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const BondHomeCard({super.key});

/// Отрисовывает UI [BondHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final bondsAsync = ref.watch(bondsProvider);
    final watchlist = ref.watch(watchlistProvider);
    final portfolio = ref.watch(paperPortfolioProvider);

    return bondsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (bonds) {
        final avg = averageOfzYield(bonds);
        final top = highestYieldOfz(bonds);
        final spread = ofzYieldSpread(bonds);
        if (avg == null && top == null) return const SizedBox.shrink();

        final trackedKeys = {
          ...watchlist,
          ...portfolio.positions.map((p) => p.assetKey),
        };
        final tracked =
            bonds.where((b) => trackedKeys.contains(watchlistKey(b))).toList();
        final upcoming = tracked.isEmpty
            ? 0
            : upcomingBondEventsCount(tracked, horizonDays: 30);

        return AppCard(
          onTap: () {
            ref.read(marketsInitialTabProvider.notifier).state = 2;
            ref.read(navigationIndexProvider.notifier).state = 3;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.chart_2, color: palette.accent, size: 20),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.bondHomeCardTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: palette.textSecondary,
                    size: 18,
                  ),
                ],
              ).motionEntrance(context, index: 0),
              const Gap(AppSpacing.xs),
              Text(
                l10n.bondHomeCardSubtitle,
                style: TextStyle(color: palette.textSecondary, fontSize: 12),
              ).motionEntrance(context, index: 1),
              if (upcoming > 0) ...[
                const Gap(6),
                Text(
                  l10n.bondHomeUpcomingEvents(upcoming),
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.positive,
                    fontWeight: FontWeight.w600,
                  ),
                ).motionEntrance(context, index: 2),
              ],
              const Gap(AppSpacing.md),
              Row(
                children: [
                  if (avg != null)
                    Expanded(
                      child: _MetricTile(
                        label: l10n.bondHomeAvgYield,
                        value: Formatters.bondYield(avg),
                        palette: palette,
                      ).motionEntrance(context, index: 3),
                    ),
                  if (spread != null) ...[
                    if (avg != null) const Gap(12),
                    Expanded(
                      child: _MetricTile(
                        label: l10n.bondYieldSpreadLabel,
                        value: l10n.bondYieldSpreadValue(
                          spread.toStringAsFixed(2),
                        ),
                        palette: palette,
                      ).motionEntrance(context, index: 4),
                    ),
                  ] else if (top != null) ...[
                    if (avg != null) const Gap(12),
                    Expanded(
                      child: _MetricTile(
                        label: l10n.bondHomeTopYield,
                        value: top.symbol,
                        subvalue: Formatters.bondYield(top.yieldPercent),
                        palette: palette,
                      ).motionEntrance(context, index: 4),
                    ),
                  ],
                ],
              ),
              const Gap(AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => openOfzYieldCurveScreen(context, bonds),
                    icon: Icon(Iconsax.chart_2, size: 16, color: palette.accent),
                    label: Text(l10n.bondYieldCurveOpen),
                  ),
                  TextButton.icon(
                    onPressed: () => openBondCalendarScreen(context, bonds),
                    icon: Icon(Iconsax.calendar_1, size: 16, color: palette.accent),
                    label: Text(l10n.bondCalendarOpen),
                  ),
                ],
              ).motionEntrance(context, index: 5),
            ],
          ),
        );
      },
    );
  }
}

/// Приватный класс [_MetricTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class _MetricTile extends StatelessWidget {
/// Создаёт [_MetricTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const _MetricTile({
    required this.label,
    required this.value,
    required this.palette,
    this.subvalue,
  });

/// Поле [label] класса [_MetricTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final String label;
/// Поле [value] класса [_MetricTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String value;
/// Поле [subvalue] класса [_MetricTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String? subvalue;
/// Поле [palette] класса [_MetricTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_MetricTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: palette.textSecondary),
        ),
        const Gap(2),
        Text(
          value,
          style: AppTypography.quote(
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
        ),
        if (subvalue != null) ...[
          const Gap(2),
          Text(
            subvalue!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.positive,
            ),
          ),
        ],
      ],
    );
  }
}
