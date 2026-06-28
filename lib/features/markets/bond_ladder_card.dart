// =============================================================================
// EcoPulse · lib/features/markets/bond_ladder_card.dart
// Автор: Цымбал Е. В.
// Дата: 08.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: bond_ladder_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/bond_analytics.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_tokens.dart';
import '../shared/widgets/app_card.dart';
import 'bond_analytics_hero_title.dart';
import 'bond_ladder_screen.dart';

/// «Лестница» ОФЗ по годам погашения.
class BondLadderCard extends StatelessWidget {
/// Создаёт [BondLadderCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const BondLadderCard({super.key, required this.bonds});

/// Поле [bonds] класса [BondLadderCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final List<MarketAsset> bonds;

/// Отрисовывает UI [BondLadderCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final ladder = buildBondLadderByYear(bonds);

    if (ladder.isEmpty) return const SizedBox.shrink();

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return AppCard(
      onTap: () => openBondLadderScreen(context, bonds),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BondAnalyticsHeroTitle(
                  tag: BondAnalyticsHero.ladder,
                  text: l10n.bondLadderTitle,
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
          const Gap(4),
          Text(
            l10n.bondLadderTapHint,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const Gap(16),
          BondLadderContent(
            bonds: bonds,
            accordion: true,
            previewMaxYears: 2,
          ),
        ],
      ),
    );
  }
}
