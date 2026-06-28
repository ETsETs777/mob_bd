// =============================================================================
// EcoPulse · lib/features/markets/bond_calendar_card.dart
// Автор: Цымбал Е. В.
// Дата: 07.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: bond_calendar_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/bond_analytics.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../shared/widgets/app_card.dart';
import 'bond_analytics_hero_title.dart';
import 'bond_calendar_screen.dart';
import 'bond_event_list.dart';

/// Ближайшие погашения и купоны по избранным / портфелю.
class BondCalendarCard extends ConsumerWidget {
/// Создаёт [BondCalendarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const BondCalendarCard({super.key, required this.allBonds});

/// Поле [allBonds] класса [BondCalendarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final List<MarketAsset> allBonds;

/// Отрисовывает UI [BondCalendarCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final watchlist = ref.watch(watchlistProvider);
    final portfolio = ref.watch(paperPortfolioProvider);

    final trackedKeys = {
      ...watchlist,
      ...portfolio.positions.map((p) => p.assetKey),
    };

    final tracked = allBonds
        .where((b) => trackedKeys.contains(watchlistKey(b)))
        .toList();

    if (tracked.isEmpty) return const SizedBox.shrink();

    final allEvents = buildBondCalendarEvents(tracked);
    final events = allEvents.take(6).toList();
    if (events.isEmpty) return const SizedBox.shrink();

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return AppCard(
      onTap: () => openBondCalendarScreen(context, allBonds),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.calendar_1, size: 18, color: palette.accent),
              const Gap(AppSpacing.sm),
              Expanded(
                child: BondAnalyticsHeroTitle(
                  tag: BondAnalyticsHero.calendar,
                  text: l10n.bondCalendarTitle,
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
            l10n.bondCalendarTapHint,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const Gap(AppSpacing.sm + 4),
          BondEventList(events: events, showTimeline: true),
          if (allEvents.length > events.length) ...[
            const Gap(AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                l10n.bondCalendarMoreEvents(allEvents.length - events.length),
                style: TextStyle(fontSize: 12, color: palette.accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
