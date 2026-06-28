// =============================================================================
// EcoPulse · lib/features/markets/ofz_yield_curve_card.dart
// Автор: Цымбал Е. В.
// Дата: 09.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: ofz_yield_curve_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/app_card.dart';
import '../shared/widgets/custom_chart_view.dart';
import 'bond_analytics_hero_title.dart';
import 'ofz_yield_curve_chart.dart';
import 'ofz_yield_curve_screen.dart';

/// Кривая доходности ОФЗ: YTM × срок до погашения.
class OfzYieldCurveCard extends ConsumerWidget {
/// Создаёт [OfzYieldCurveCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const OfzYieldCurveCard({super.key, required this.bonds});

/// Поле [bonds] класса [OfzYieldCurveCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final List<MarketAsset> bonds;

/// Отрисовывает UI [OfzYieldCurveCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return AppCard(
      onTap: () => openOfzYieldCurveScreen(context, bonds),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BondAnalyticsHeroTitle(
                  tag: BondAnalyticsHero.yieldCurve,
                  text: l10n.bondYieldCurveTitle,
                  style: titleStyle,
                ),
              ),
              Icon(
                Iconsax.maximize_4,
                size: 18,
                color: palette.textSecondary,
              ),
            ],
          ),
          const Gap(AppSpacing.xs),
          Text(
            l10n.bondYieldCurveTapHint,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const Gap(AppSpacing.md),
          CustomChartView(
            contextId: ChartContextId.bonds,
            height: 180,
            input: ChartRenderInput(
              customBuilder: (_, height) => OfzYieldCurveChart(
                bonds: bonds,
                height: height,
                interactive: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
