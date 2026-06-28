// =============================================================================
// EcoPulse · lib/features/markets/markets_screen.dart
// Автор: Цымбал Е. В.
// Дата: 09.06.2026
// Экран «Рынки»: акции, крипто, облигации, watchlist.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/constants/bond_analytics_deep_link.dart';
import '../../core/constants/market_catalog.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../core/utils/market_list_utils.dart';
import '../../core/utils/sector_labels.dart';
import '../../providers/markets_customization_provider.dart';
import '../../providers/stock_market_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../analytics/compare_assets_screen.dart';
import '../shared/app_actions.dart';
import '../shared/widgets/app_segmented_control.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/last_updated_banner.dart';
import '../shared/widgets/loading_skeleton.dart';
import 'market_asset_row.dart';
import 'asset_preview_sheet.dart';
import 'sector_heatmap.dart';
import 'watchlist_volatility_heatmap.dart';
import 'ofz_yield_curve_card.dart';
import 'ofz_yield_curve_screen.dart';
import 'bond_ladder_card.dart';
import 'bond_calendar_card.dart';
import 'bond_ladder_screen.dart';
import 'bond_calendar_screen.dart';

/// Класс [MarketsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class MarketsScreen extends ConsumerStatefulWidget {
/// Создаёт [MarketsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  const MarketsScreen({super.key});

/// Создаёт State для [MarketsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  ConsumerState<MarketsScreen> createState() => _MarketsScreenState();
}

/// Приватный класс [_MarketsScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _MarketsScreenState extends ConsumerState<MarketsScreen>
    with SingleTickerProviderStateMixin {
/// Поле [_tabController] класса [_MarketsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  late final TabController _tabController;
/// Поле [_searchController] класса [_MarketsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final _searchController = TextEditingController();

/// Инициализация state [_MarketsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncMarketsSessionFromConfig();
      final initialTab = ref.read(marketsInitialTabProvider);
      if (initialTab != null && initialTab >= 0 && initialTab < 3) {
        _tabController.animateTo(initialTab);
        ref.read(marketsInitialTabProvider.notifier).state = null;
      }
      if (ref.read(refreshTimeProvider(RefreshScope.markets)) == null) {
        markRefreshed(ref, RefreshScope.markets);
      }
      _maybeOpenBondDeepLink();
    });
  }

/// Приватный метод [_maybeOpenBondDeepLink] класса [_MarketsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  void _syncMarketsSessionFromConfig() {
    final resolved = ref.read(resolvedMarketsProvider);
    ref.read(stockMarketRegionProvider.notifier).state =
        resolved.defaultStockRegion;
    ref.read(stocksGroupedListProvider.notifier).state =
        resolved.groupStocksBySector;
  }

  void _maybeOpenBondDeepLink() {
    final link = ref.read(marketsBondDeepLinkProvider);
    if (link == null) return;
    final bondsAsync = ref.read(bondsProvider);
    if (!bondsAsync.hasValue) return;
    ref.read(marketsBondDeepLinkProvider.notifier).state = null;
    final bonds = bondsAsync.value!;
    if (bonds.isEmpty || !mounted) return;
    switch (link) {
      case BondAnalyticsDeepLink.yieldCurve:
        openOfzYieldCurveScreen(context, bonds);
      case BondAnalyticsDeepLink.ladder:
        openBondLadderScreen(context, bonds);
      case BondAnalyticsDeepLink.calendar:
        openBondCalendarScreen(context, bonds);
    }
  }

/// Освобождает ресурсы [_MarketsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_MarketsScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final showFavorites = ref.watch(showWatchlistOnlyProvider);
    final l10n = AppLocalizations.of(context)!;
    final marketsConfig = ref.watch(resolvedMarketsProvider);

    ref.listen(resolvedMarketsProvider, (prev, next) {
      if (prev == null) return;
      if (prev.defaultStockRegion != next.defaultStockRegion) {
        ref.read(stockMarketRegionProvider.notifier).state =
            next.defaultStockRegion;
      }
      if (prev.groupStocksBySector != next.groupStocksBySector) {
        ref.read(stocksGroupedListProvider.notifier).state =
            next.groupStocksBySector;
      }
    });

    ref.listen<BondAnalyticsDeepLink?>(marketsBondDeepLinkProvider, (prev, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpenBondDeepLink());
      }
    });
    ref.listen(bondsProvider, (prev, next) {
      if (ref.read(marketsBondDeepLinkProvider) != null && next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpenBondDeepLink());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabMarkets),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SearchBar(
                  controller: _searchController,
                  hintText: l10n.marketsSearchHint,
                  leading: Icon(Iconsax.search_normal_1, color: palette.textSecondary),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Iconsax.close_circle),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(marketSearchQueryProvider.notifier).state = '';
                          setState(() {});
                        },
                      ),
                  ],
                  onChanged: (v) {
                    ref.read(marketSearchQueryProvider.notifier).state = v;
                    setState(() {});
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: palette.accent,
                indicatorAnimation: TabIndicatorAnimation.elastic,
                labelColor: palette.accent,
                unselectedLabelColor: palette.textSecondary,
                tabs: [
                  Tab(text: l10n.marketsTabCrypto),
                  Tab(text: l10n.marketsTabStocks),
                  Tab(text: l10n.marketsTabBonds),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.compareTitle,
            icon: Icon(Iconsax.chart_2, color: palette.accent),
            onPressed: () => openAppPage(
              context,
              const CompareAssetsScreen(),
            ),
          ),
          IconButton(
            tooltip: l10n.marketsFavorites,
            icon: Icon(
              showFavorites ? Iconsax.star_1 : Iconsax.star,
              color: showFavorites ? palette.accent : palette.textSecondary,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(showWatchlistOnlyProvider.notifier).state = !showFavorites;
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CryptoList(
            listRowCompact: marketsConfig.listRowCompact,
            onRefresh: () async {
              await ref.read(cryptoProvider.notifier).refresh();
              markRefreshed(ref, RefreshScope.markets);
            },
          ),
          _StocksList(
            showSectorHeatmap: marketsConfig.showSectorHeatmap,
            listRowCompact: marketsConfig.listRowCompact,
            onRefresh: () async {
              await ref.read(stocksProvider.notifier).refresh();
              markRefreshed(ref, RefreshScope.markets);
            },
          ),
          _BondsList(
            listRowCompact: marketsConfig.listRowCompact,
            onRefresh: () async {
              await ref.read(bondsProvider.notifier).refresh();
              markRefreshed(ref, RefreshScope.markets);
            },
          ),
        ],
      ),
    );
  }
}

/// Приватный класс [_CryptoList].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class _CryptoList extends ConsumerWidget {
/// Создаёт [_CryptoList].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  const _CryptoList({
    required this.onRefresh,
    this.listRowCompact = false,
  });

/// Поле [onRefresh] класса [_CryptoList].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final Future<void> Function() onRefresh;
  final bool listRowCompact;

/// Отрисовывает UI [_CryptoList].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoProvider);
    final l10n = AppLocalizations.of(context)!;

    return cryptoAsync.when(
      loading: () => const LoadingSkeleton(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (feed) => _AssetListView(
        assetsAsync: AsyncData(feed.assets),
        onRefresh: onRefresh,
        listRowCompact: listRowCompact,
        hasLoadError: cryptoAsync.hasError,
        listFooter: feed.hasMore || feed.loadingMore
            ? Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: feed.loadingMore
                    ? const Center(child: CircularProgressIndicator())
                    : OutlinedButton.icon(
                        onPressed: () =>
                            ref.read(cryptoProvider.notifier).loadMore(),
                        icon: const Icon(Iconsax.arrow_down),
                        label: Text(
                          l10n.cryptoLoadMore(
                            feed.assets.length,
                            MarketCatalogStats.cryptoCount,
                          ),
                        ),
                      ),
              )
            : null,
      ),
    );
  }
}

/// Приватный класс [_StocksList].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _StocksList extends ConsumerWidget {
/// Создаёт [_StocksList].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const _StocksList({
    required this.onRefresh,
    this.showSectorHeatmap = true,
    this.listRowCompact = false,
  });

/// Поле [onRefresh] класса [_StocksList].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final Future<void> Function() onRefresh;
  final bool showSectorHeatmap;
  final bool listRowCompact;

/// Отрисовывает UI [_StocksList].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AssetListView(
      assetsAsync: ref.watch(stocksProvider),
      onRefresh: onRefresh,
      stockRegion: ref.watch(stockMarketRegionProvider),
      groupBySector: ref.watch(stocksGroupedListProvider),
      listRowCompact: listRowCompact,
      extraHeader: (assets) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StockRegionFilters(
            count: assets.length,
            moexCount: assets.where((a) => a.type == AssetType.stockRu).length,
            usCount: assets.where((a) => a.type == AssetType.stockUs).length,
          ),
          if (showSectorHeatmap) ...[
            const SizedBox(height: 12),
            SectorHeatmapCard(stocks: assets),
          ],
        ],
      ),
      hasLoadError: ref.watch(stocksProvider).hasError,
    );
  }
}

/// Приватный класс [_BondsList].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _BondsList extends ConsumerWidget {
/// Создаёт [_BondsList].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const _BondsList({
    required this.onRefresh,
    this.listRowCompact = false,
  });

/// Поле [onRefresh] класса [_BondsList].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final Future<void> Function() onRefresh;
  final bool listRowCompact;

/// Отрисовывает UI [_BondsList].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return _AssetListView(
      assetsAsync: ref.watch(bondsProvider),
      onRefresh: onRefresh,
      bondFilter: ref.watch(bondMarketFilterProvider),
      groupByBond: ref.watch(bondsGroupedListProvider),
      listRowCompact: listRowCompact,
      extraHeader: (assets) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BondFilters(
            count: assets.length,
            ofzCount:
                assets.where((a) => a.bondCategory == BondCategory.ofz).length,
            corpCount: assets
                .where((a) => a.bondCategory == BondCategory.corporate)
                .length,
          ),
          const SizedBox(height: 12),
          OfzYieldCurveCard(bonds: assets),
          const SizedBox(height: 12),
          BondLadderCard(bonds: assets),
          const SizedBox(height: 12),
          BondCalendarCard(allBonds: assets),
        ],
      ),
      hasLoadError: ref.watch(bondsProvider).hasError,
      bondLabels: (
        ofz: l10n.bondCategoryOfz,
        corporate: l10n.bondCategoryCorporate,
      ),
    );
  }
}

/// Приватный класс [_BondFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _BondFilters extends ConsumerWidget {
/// Создаёт [_BondFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _BondFilters({
    required this.count,
    required this.ofzCount,
    required this.corpCount,
  });

/// Поле [count] класса [_BondFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final int count;
/// Поле [ofzCount] класса [_BondFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final int ofzCount;
/// Поле [corpCount] класса [_BondFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final int corpCount;

/// Отрисовывает UI [_BondFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(bondMarketFilterProvider);
    final grouped = ref.watch(bondsGroupedListProvider);
    final palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AppSegmentedControl<BondMarketFilter>(
            segments: [
              ButtonSegment(
                value: BondMarketFilter.all,
                label: Text('${l10n.marketsFilterAll} ($count)'),
              ),
              ButtonSegment(
                value: BondMarketFilter.ofz,
                label: Text('${l10n.marketsFilterOfz} ($ofzCount)'),
              ),
              ButtonSegment(
                value: BondMarketFilter.corporate,
                label: Text('${l10n.marketsFilterCorporateBonds} ($corpCount)'),
              ),
            ],
            selected: {filter},
            onSelectionChanged: (selected) {
              if (selected.isEmpty) return;
              ref.read(bondMarketFilterProvider.notifier).state = selected.first;
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilterChip(
          label: Text(l10n.marketsGroupBySector),
          selected: grouped,
          onSelected: (v) =>
              ref.read(bondsGroupedListProvider.notifier).state = v,
          selectedColor: palette.accent.withValues(alpha: 0.18),
          checkmarkColor: palette.accent,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.marketsBondCatalogCounts(MarketCatalogStats.bondCount),
          style: TextStyle(color: palette.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

/// Приватный класс [_StockRegionFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _StockRegionFilters extends ConsumerWidget {
/// Создаёт [_StockRegionFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const _StockRegionFilters({
    required this.count,
    required this.moexCount,
    required this.usCount,
  });

/// Поле [count] класса [_StockRegionFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final int count;
/// Поле [moexCount] класса [_StockRegionFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final int moexCount;
/// Поле [usCount] класса [_StockRegionFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final int usCount;

/// Отрисовывает UI [_StockRegionFilters].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final region = ref.watch(stockMarketRegionProvider);
    final grouped = ref.watch(stocksGroupedListProvider);
    final palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Text('${l10n.marketsFilterAll} ($count)'),
              selected: region == StockMarketRegion.all,
              onSelected: (_) => ref.read(stockMarketRegionProvider.notifier).state =
                  StockMarketRegion.all,
            ),
            FilterChip(
              label: Text('${l10n.marketsFilterMoex} ($moexCount)'),
              selected: region == StockMarketRegion.moex,
              onSelected: (_) => ref.read(stockMarketRegionProvider.notifier).state =
                  StockMarketRegion.moex,
            ),
            FilterChip(
              label: Text('${l10n.marketsFilterUs} ($usCount)'),
              selected: region == StockMarketRegion.us,
              onSelected: (_) => ref.read(stockMarketRegionProvider.notifier).state =
                  StockMarketRegion.us,
            ),
            FilterChip(
              label: Text(l10n.marketsGroupBySector),
              selected: grouped,
              onSelected: (v) =>
                  ref.read(stocksGroupedListProvider.notifier).state = v,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.marketsCatalogCounts(
            MarketCatalogStats.moexCount,
            MarketCatalogStats.usCount,
            MarketCatalogStats.cryptoCount,
          ),
          style: TextStyle(color: palette.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

/// Приватный класс [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _AssetListView extends ConsumerWidget {
/// Создаёт [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const _AssetListView({
    required this.assetsAsync,
    required this.onRefresh,
    this.extraHeader,
    this.hasLoadError = false,
    this.stockRegion,
    this.groupBySector = false,
    this.bondFilter,
    this.groupByBond = false,
    this.bondLabels,
    this.listFooter,
    this.listRowCompact = false,
  });

/// Поле [assetsAsync] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final AsyncValue<List<MarketAsset>> assetsAsync;
/// Поле [onRefresh] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final Future<void> Function() onRefresh;
/// Поле [extraHeader] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final Widget Function(List<MarketAsset> assets)? extraHeader;
/// Поле [hasLoadError] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final bool hasLoadError;
/// Поле [stockRegion] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final StockMarketRegion? stockRegion;
/// Поле [groupBySector] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final bool groupBySector;
/// Поле [bondFilter] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final BondMarketFilter? bondFilter;
/// Поле [groupByBond] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final bool groupByBond;
/// Поле [bondLabels] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final ({String ofz, String corporate})? bondLabels;
/// Поле [listFooter] класса [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final Widget? listFooter;
  final bool listRowCompact;

/// Отрисовывает UI [_AssetListView].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(marketSearchQueryProvider);
    final showFavorites = ref.watch(showWatchlistOnlyProvider);
    final watchlist = ref.watch(watchlistProvider);
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return assetsAsync.when(
      loading: () => const LoadingSkeleton(),
      error: (e, _) => Center(
        child: Text(
          l10n.errorGeneric(e.toString()),
          style: TextStyle(color: palette.negative),
        ),
      ),
      data: (assets) {
        var filtered = filterAssets(assets, query);
        if (stockRegion != null) {
          filtered = filterByStockRegion(filtered, stockRegion!);
        }
        if (bondFilter != null) {
          filtered = filterByBondCategory(filtered, bondFilter!);
        }
        if (showFavorites) {
          filtered = filtered
              .where((a) => watchlist.contains(watchlistKey(a)))
              .toList();
        }

        if (filtered.isEmpty) {
          return EmptyState(
            icon: showFavorites ? Iconsax.star : Iconsax.search_normal_1,
            title: showFavorites
                ? l10n.marketsEmptyFavoritesTitle
                : l10n.marketsEmptySearchTitle,
            subtitle: showFavorites
                ? l10n.marketsEmptyFavoritesSubtitle
                : l10n.marketsEmptySearchSubtitle,
            actionLabel: showFavorites ? l10n.marketsAllAssets : null,
            onAction: showFavorites
                ? () =>
                    ref.read(showWatchlistOnlyProvider.notifier).state = false
                : null,
          );
        }

        final showWatchlistHeatmap = showFavorites && watchlist.isNotEmpty;
        var headerCount = 1;
        if (showWatchlistHeatmap) headerCount++;
        if (extraHeader != null) headerCount++;
        final useStockGroups =
            groupBySector && query.trim().isEmpty && stockRegion != null;
        final useBondGroups = groupByBond &&
            query.trim().isEmpty &&
            bondFilter != null &&
            bondLabels != null;
        final rows = useBondGroups
            ? buildGroupedBondRows(
                filtered,
                ofzLabel: bondLabels!.ofz,
                corporateLabel: bondLabels!.corporate,
              )
            : useStockGroups
                ? buildGroupedStockRows(
                    filtered,
                    sectorLabel: (k) => sectorLabelForKey(k, l10n),
                  )
                : filtered.map(MarketListRow.item).toList();

        final footerCount = listFooter == null ? 0 : 1;

        return AppRefreshIndicator(
          onRefresh: () async {
            await onRefresh();
          },
          child: AnimationLimiter(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rows.length + headerCount + footerCount,
              separatorBuilder: (_, index) =>
                  index < headerCount - 1
                      ? const SizedBox(height: 8)
                      : const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (listFooter != null &&
                    index == rows.length + headerCount) {
                  return listFooter!;
                }
                if (index == 0) {
                  return LastUpdatedBanner(
                    scope: RefreshScope.markets,
                    hasLoadError: hasLoadError,
                  );
                }
                var headerIndex = 1;
                if (showWatchlistHeatmap) {
                  if (index == headerIndex) {
                    return const WatchlistVolatilityHeatmap();
                  }
                  headerIndex++;
                }
                if (extraHeader != null) {
                  if (index == headerIndex) {
                    return extraHeader!(assets);
                  }
                  headerIndex++;
                }
                final row = rows[index - headerCount];
                if (row.isHeader) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 2),
                    child: Text(
                      row.title!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: palette.accent,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                final asset = row.asset!;
                final isFav = watchlist.contains(watchlistKey(asset));
                final tile = MarketAssetRow(
                  asset: asset,
                  isFavorite: isFav,
                  compact: listRowCompact,
                  onToggleFavorite: () {
                    final key = watchlistKey(asset);
                    final wasFavorite = isFav;
                    ref.read(watchlistProvider.notifier).toggle(asset);
                    if (wasFavorite) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.marketsRemovedFromWatchlist(asset.symbol),
                          ),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: l10n.undo,
                            onPressed: () => ref
                                .read(watchlistProvider.notifier)
                                .restoreKey(key),
                          ),
                        ),
                      );
                    }
                  },
                  onTap: () => showAssetPreviewSheet(context, ref, asset),
                );
                return AnimationConfiguration.staggeredList(
                  position: index - headerCount,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 40,
                    child: FadeInAnimation(child: tile),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
