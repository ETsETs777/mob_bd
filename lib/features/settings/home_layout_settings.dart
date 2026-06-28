// =============================================================================
// EcoPulse · lib/features/settings/home_layout_settings.dart
// Автор: Цымбал Е. В.
// Дата: 18.06.2026
// Настройки, профиль, backup, layout. Файл: home_layout_settings.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/customization/customization_sync.dart';
import '../../core/customization/home_customization_resolver.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_provider.dart';
import '../../providers/home_layout_provider.dart';

/// Класс [HomeLayoutSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class HomeLayoutSettings extends ConsumerWidget {
/// Создаёт [HomeLayoutSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  const HomeLayoutSettings({super.key});

/// Отрисовывает UI [HomeLayoutSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final home = ref.watch(customizationProvider.select((c) => c.home));
    final layout = HomeCustomizationResolver.resolve(home);

    Future<void> commit(HomeCustomization next) => CustomizationSync.commit(
          ref,
          ref.read(customizationProvider).copyWith(home: next),
        );

    String label(HomeSectionId id) => switch (id) {
          HomeSectionId.learn => l10n.homeSectionLearn,
          HomeSectionId.portfolio => l10n.homeSectionPortfolio,
          HomeSectionId.news => l10n.homeSectionNews,
          HomeSectionId.radar => l10n.homeSectionRadar,
          HomeSectionId.indices => l10n.homeSectionIndices,
          HomeSectionId.fearGreed => l10n.homeSectionFearGreed,
          HomeSectionId.currencies => l10n.homeSectionCurrencies,
          HomeSectionId.keyRate => l10n.homeSectionKeyRate,
          HomeSectionId.inflation => l10n.homeSectionInflation,
          HomeSectionId.commodities => l10n.homeSectionCommodities,
          HomeSectionId.markets => l10n.homeSectionMarkets,
          HomeSectionId.bonds => l10n.homeSectionBonds,
          HomeSectionId.watchlist => l10n.homeSectionWatchlist,
          HomeSectionId.correlation => l10n.homeSectionCorrelation,
        };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeLayoutReorderHint,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(8),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) => commit(
                HomeCustomizationResolver.reorderSections(home, oldIndex, newIndex),
              ),
              children: [
                for (var i = 0; i < layout.order.length; i++)
                  ReorderableDragStartListener(
                    key: ValueKey(layout.order[i]),
                    index: i,
                    child: SwitchListTile(
                      secondary: Icon(Iconsax.menu, color: palette.textSecondary, size: 18),
                      title: Text(
                        label(layout.order[i]),
                        style: TextStyle(fontSize: 14, color: palette.textPrimary),
                      ),
                      value: layout.isVisible(layout.order[i]),
                      onChanged: (v) => commit(
                        HomeCustomizationResolver.updateSectionVisible(
                          home,
                          layout.order[i],
                          v,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
