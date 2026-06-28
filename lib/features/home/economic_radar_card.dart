// =============================================================================
// EcoPulse · lib/features/home/economic_radar_card.dart
// Автор: Цымбал Е. В.
// Дата: 04.06.2026
// Главный экран и виджеты секций. Файл: economic_radar_card.
// =============================================================================

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:gap/gap.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';



import '../../core/motion/app_motion.dart';

import '../../core/theme/app_palette.dart';

import '../../core/theme/app_tokens.dart';

import '../../core/theme/app_typography.dart';

import '../../core/utils/economic_radar.dart';
/// StatelessWidget [EconomicRadarCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026

/// Создаёт [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
import '../../data/models/commodity_quote.dart';

import '../../data/models/currency_rate.dart';

import '../../data/models/inflation_point.dart';

import '../../data/models/key_rate_point.dart';

import '../../data/models/market_asset.dart';
/// Поле [rates] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026

/// Поле [keyRate] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
import '../../l10n/app_localizations.dart';
/// Поле [stocks] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026

/// Поле [inflation] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
import '../insights/timeline_screen.dart';
/// Поле [fearGreed] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026

import '../shared/widgets/app_card.dart';
/// Отрисовывает UI [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026



class EconomicRadarCard extends StatelessWidget {

/// Создаёт [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const EconomicRadarCard({

    super.key,

    required this.rates,

    required this.keyRate,

    required this.stocks,

    required this.inflation,

    required this.fearGreed,

  });



/// Поле [rates] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final List<CurrencyRate>? rates;

/// Поле [keyRate] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final KeyRateSnapshot? keyRate;

/// Поле [stocks] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final List<MarketAsset>? stocks;

/// Поле [inflation] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final List<InflationPoint>? inflation;

/// Поле [fearGreed] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final FearGreedIndex? fearGreed;



/// Отрисовывает UI [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final palette = AppPalette.of(context);

    final snapshot = buildEconomicRadar(

      rates: rates,

      keyRate: keyRate,

      stocks: stocks,

      inflation: inflation,

      fearGreed: fearGreed,

    );



    if (snapshot.axes.isEmpty) return const SizedBox.shrink();



    final scoreColor = _scoreColor(palette, snapshot.overall);



    return AppCard(

      onTap: () => openAppPage(context, const TimelineScreen()),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
/// Приватный метод [_scoreColor] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026

          Row(

            children: [

              Icon(Iconsax.radar, size: 18, color: palette.accent),

/// Приватный класс [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
              const Gap(AppSpacing.sm),
/// Создаёт [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026

              Expanded(

                child: Text(

                  l10n.radarTitle,
/// Поле [label] класса [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026

/// Поле [score] класса [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
                  style: TextStyle(
/// Поле [palette] класса [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026

                    fontWeight: FontWeight.w600,
/// Отрисовывает UI [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026

                    color: palette.textPrimary,

                  ),

                ),

              ),

              Text(

                '${snapshot.overall.round()}',

                style: AppTypography.quote(

                  TextStyle(

                    fontSize: 28,

                    fontWeight: FontWeight.bold,

                    color: scoreColor,

                  ),

                ),

              ),

              const Gap(AppSpacing.xs),

              Icon(

                Iconsax.arrow_right_3,

                size: 16,

                color: palette.textSecondary,

              ),

            ],

          ),

          const Gap(AppSpacing.xs),

          Text(

            l10n.radarSubtitle,

            style: TextStyle(color: palette.textSecondary, fontSize: 12),

          ),

          const Gap(AppSpacing.sm + 4),

          ...snapshot.axes.map(

            (axis) => Padding(

              padding: const EdgeInsets.only(bottom: AppSpacing.sm),

              child: _AxisBar(

                label: axis.label,

                score: axis.score,

                palette: palette,

              ),

            ),

          ),

        ],

      ),

    )

        .animate()

        .fadeIn(duration: 350.ms)

        .slideY(begin: 0.04, end: 0);

  }



/// Приватный метод [_scoreColor] класса [EconomicRadarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  Color _scoreColor(AppPalette palette, double score) {

    if (score >= 65) return palette.positive;

    if (score <= 40) return palette.negative;

    return palette.accent;

  }

}



/// Приватный класс [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _AxisBar extends StatelessWidget {

/// Создаёт [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  const _AxisBar({

    required this.label,

    required this.score,

    required this.palette,

  });



/// Поле [label] класса [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String label;

/// Поле [score] класса [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final double score;

/// Поле [palette] класса [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final AppPalette palette;



/// Отрисовывает UI [_AxisBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override

  Widget build(BuildContext context) {

    final frac = (score / 100).clamp(0.0, 1.0);

    return Row(

      children: [

        SizedBox(

          width: 72,

          child: Text(

            label,

            style: TextStyle(fontSize: 12, color: palette.textSecondary),

          ),

        ),

        Expanded(

          child: ClipRRect(

            borderRadius: BorderRadius.circular(AppRadii.bar - 2),

            child: LinearProgressIndicator(

              value: frac,

              minHeight: 6,

              backgroundColor: palette.surfaceLight,

              color: frac >= 0.65

                  ? palette.positive

                  : frac <= 0.4

                      ? palette.negative

                      : palette.accent,

            ),

          ),

        ),

        const Gap(AppSpacing.sm),

        SizedBox(

          width: 28,

          child: Text(

            '${score.round()}',

            textAlign: TextAlign.end,

            style: AppTypography.quote(

              TextStyle(

                fontSize: 12,

                fontWeight: FontWeight.w600,

                color: palette.textPrimary,

              ),

            ),

          ),

        ),

      ],

    );

  }

}


