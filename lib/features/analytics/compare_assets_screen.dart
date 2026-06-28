// =============================================================================
// EcoPulse · lib/features/analytics/compare_assets_screen.dart
// Автор: Цымбал Е. В.
// Дата: 12.06.2026
// Сравнение активов, корреляции. Файл: compare_assets_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/compare_assets_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/charts.dart';
import '../shared/widgets/custom_chart_view.dart';
import '../shared/widgets/loading_skeleton.dart';

/// Класс [CompareAssetsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class CompareAssetsScreen extends ConsumerStatefulWidget {
/// Создаёт [CompareAssetsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  const CompareAssetsScreen({super.key});

/// Создаёт State для [CompareAssetsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  ConsumerState<CompareAssetsScreen> createState() =>
      _CompareAssetsScreenState();
}

/// Приватный класс [_CompareAssetsScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
class _CompareAssetsScreenState extends ConsumerState<CompareAssetsScreen> {
/// Отрисовывает UI [_CompareAssetsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final selection = ref.watch(compareSelectionProvider);
    final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
    final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
    final bonds = ref.watch(bondsProvider).valueOrNull ?? const [];
    final all = [...crypto, ...stocks, ...bonds];
    final selected = selection
        .map((k) => assetFromKey(k, all))
        .whereType<MarketAsset>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.compareTitle),
        actions: [
          if (selection.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.trash),
              tooltip: l10n.compareClear,
              onPressed: () =>
                  ref.read(compareSelectionProvider.notifier).clear(),
            ),
        ],
      ),
      body: AppRefreshIndicator(
        onRefresh: () async {
          await ref.read(cryptoProvider.notifier).refresh();
          await ref.read(stocksProvider.notifier).refresh();
          await ref.read(bondsProvider.notifier).refresh();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.compareSubtitle(maxCompareAssets),
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: all.take(40).map((asset) {
                final key = watchlistKey(asset);
                final picked = selection.contains(key);
                return FilterChip(
                  label: Text(asset.symbol),
                  selected: picked,
                  onSelected: (_) =>
                      ref.read(compareSelectionProvider.notifier).toggle(key),
                );
              }).toList(),
            ),
            const Gap(20),
            if (selected.isEmpty)
              Text(
                l10n.compareEmpty,
                style: TextStyle(color: palette.textSecondary),
              )
            else
              _CompareChart(assets: selected, l10n: l10n),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_CompareChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _CompareChart extends ConsumerWidget {
/// Создаёт [_CompareChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  const _CompareChart({required this.assets, required this.l10n});

/// Поле [assets] класса [_CompareChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final List<MarketAsset> assets;
/// Поле [l10n] класса [_CompareChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_CompareChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final futures = assets
        .map(
          (a) => ref.watch(
            assetDetailProvider(
              AssetDetailParams(asset: a, days: 30),
            ),
          ),
        )
        .toList();

    if (futures.any((f) => f.isLoading)) {
      return const ShimmerCard();
    }
    if (futures.any((f) => f.hasError)) {
      return Text(
        l10n.compareLoadError,
        style: TextStyle(color: palette.negative),
      );
    }

    final series = <ChartLineSeries>[];
    for (var i = 0; i < assets.length; i++) {
      final detail = futures[i].valueOrNull;
      if (detail == null || detail.history.length < 2) continue;
      series.add(
        ChartLineSeries(
          label: assets[i].symbol,
          points: detail.history,
        ),
      );
    }

    if (series.isEmpty) {
      return Text(
        l10n.chartInsufficientData,
        style: TextStyle(color: palette.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.compareChartTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(12),
        CustomChartView(
          contextId: ChartContextId.compare,
          input: ChartRenderInput(series: series),
        ),
      ],
    );
  }
}
