import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/home_customization_resolver.dart';
import '../../core/motion/app_motion.dart';
import '../../core/services/home_widget_service.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/inflation_point.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/news_item.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/commodities_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../../providers/home_customization_provider.dart';
import '../../providers/home_layout_provider.dart';
import '../../providers/indices_provider.dart';
import '../../providers/news_provider.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/stock_market_provider.dart';
import '../../providers/widget_customization_provider.dart';
import '../../core/utils/chart_share.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../insights/macro_calendar_screen.dart';
import '../insights/macro_week_screen.dart';
import '../learn/course_home_card.dart';
import '../portfolio/portfolio_home_card.dart';
import 'economic_radar_card.dart';
import 'bond_home_card.dart';
import 'news_feed_card.dart';
import '../markets/watchlist_volatility_heatmap.dart';
import '../asset_detail/asset_detail_screen.dart';
import '../analytics/correlation_screen.dart';
import '../home/key_rate_detail_screen.dart';
import '../home/economic_brief.dart';
import '../shared/app_actions.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/glass_card.dart';
import '../shared/widgets/last_updated_banner.dart';
import '../shared/widgets/loading_skeleton.dart';
import '../shared/widgets/metric_card.dart';
import '../shared/widgets/motion_widgets.dart';
import '../shared/widgets/section_header.dart';

/// Класс [HomeScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
class HomeScreen extends ConsumerStatefulWidget {
/// Создаёт [HomeScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const HomeScreen({super.key});

/// Создаёт State для [HomeScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

/// Приватный класс [_HomeScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class _HomeScreenState extends ConsumerState<HomeScreen> {
/// Поле [_shareKey] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final _shareKey = GlobalKey();

/// Инициализация state [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(refreshTimeProvider(RefreshScope.global)) == null) {
        markRefreshed(ref, RefreshScope.global);
      }
      _refreshHomeWidget();
    });
  }

  void _refreshHomeWidget() {
    HomeWidgetService.update(
      rates: ref.read(currencyRatesProvider).valueOrNull,
      crypto: ref.read(cryptoProvider).valueOrNull?.assets,
      stocks: ref.read(stocksProvider).valueOrNull,
      commodities: ref.read(commoditiesProvider).valueOrNull,
      keyRate: ref.read(keyRateProvider).valueOrNull,
      portfolio: ref.read(portfolioSnapshotProvider),
      inflation: ref.read(inflationProvider).valueOrNull,
      config: ref.read(resolvedWidgetConfigProvider),
    );
  }

/// Отрисовывает UI [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyRatesProvider);
    final inflation = ref.watch(inflationProvider);
    final cryptoAsync = ref.watch(cryptoProvider);
    final stocks = ref.watch(stocksProvider);
    final keyRate = ref.watch(keyRateProvider);
    final commodities = ref.watch(commoditiesProvider);
    final fearGreed = ref.watch(fearGreedProvider);
    final marketNews = ref.watch(marketNewsProvider);
    final usIndices = ref.watch(usIndicesProvider);
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final homeLayout = ref.watch(resolvedHomeLayoutProvider);
    final compact = homeLayout.compactHome;
    final gap = compact ? 6.0 : 12.0;
    final pagePad = compact ? 8.0 : 16.0;

    ref.listen(resolvedWidgetConfigProvider, (prev, next) {
      if (prev == null || prev == next) return;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshHomeWidget());
    });

    final briefLines = buildEconomicBrief(
      rates: currency.valueOrNull,
      keyRate: keyRate.valueOrNull,
      crypto: cryptoAsync.valueOrNull?.assets,
      stocks: stocks.valueOrNull,
      commodities: commodities.valueOrNull,
      fearGreed: fearGreed.valueOrNull,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: l10n.homeShareDashboard,
            onPressed: () => shareWidgetAsPng(
              boundaryKey: _shareKey,
              fileName: 'ecopulse_dashboard.png',
              text: 'EcoPulse · ${l10n.homePulseTitle}',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                ref.read(navigationIndexProvider.notifier).state = 4,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => refreshAllData(ref),
          ),
        ],
      ),
      body: AppRefreshIndicator(
        onRefresh: () => refreshAllData(ref),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideLandscape = constraints.maxWidth >= 720 &&
                MediaQuery.orientationOf(context) == Orientation.landscape;
            final sections = _buildHomeSections(
              context: context,
              ref: ref,
              l10n: l10n,
              palette: palette,
              briefLines: briefLines,
              currency: currency,
              inflation: inflation,
              crypto: cryptoAsync.whenData((f) => f.assets),
              stocks: stocks,
              keyRate: keyRate,
              commodities: commodities,
              fearGreed: fearGreed,
              marketNews: marketNews,
              usIndices: usIndices,
              compact: compact,
              gap: gap,
              homeLayout: homeLayout,
            );

            if (isWideLandscape) {
              final split = (sections.length / 2).ceil();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(pagePad),
                      children: sections.sublist(0, split),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(pagePad),
                      children: sections.sublist(split),
                    ),
                  ),
                ],
              );
            }

            return ListView(
              padding: EdgeInsets.all(pagePad),
              children: sections,
            );
          },
        ),
      ),
    );
  }

/// Приватный метод [_buildHomeSections] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  List<Widget> _buildHomeSections({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations l10n,
    required AppPalette palette,
    required List<BriefLine> briefLines,
    required AsyncValue<List<CurrencyRate>> currency,
    required AsyncValue<List<InflationPoint>> inflation,
    required AsyncValue<List<MarketAsset>> crypto,
    required AsyncValue<List<MarketAsset>> stocks,
    required AsyncValue<KeyRateSnapshot> keyRate,
    required AsyncValue<List<CommodityQuote>> commodities,
    required AsyncValue<FearGreedIndex?> fearGreed,
    required AsyncValue<List<NewsItem>> marketNews,
    required AsyncValue<List<MarketAsset>> usIndices,
    required bool compact,
    required double gap,
    required ResolvedHomeLayout homeLayout,
  }) {
    final profile = ref.watch(userProfileProvider);

    return [
      LastUpdatedBanner(
        scope: RefreshScope.global,
        hasLoadError: _hasPartialError(currency, inflation, crypto, stocks),
      ),
      if (ref.watch(demoModeProvider))
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: Icon(Icons.science_outlined, size: 16, color: palette.accent),
              label: Text(
                l10n.demoModeBadge,
                style: TextStyle(fontSize: 12, color: palette.accent),
              ),
              backgroundColor: palette.accent.withValues(alpha: 0.12),
            ),
          ),
        ),
      RepaintBoundary(
        key: _shareKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.hasName
                        ? l10n.profileGreeting(profile.displayName)
                        : l10n.homePulseTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (profile.hasName) ...[
                    const SizedBox(height: 2),
                    Text(
                      l10n.homePulseTitle,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  GestureDetector(
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            Localizations.localeOf(context).languageCode == 'ru'
                                ? 'Разработчик · Цымбал Е. В.'
                                : 'Developer · Tsymbal E. V.',
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      l10n.homePulseSubtitle,
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            if (briefLines.isNotEmpty) ...[
              const SizedBox(height: 12),
              EconomicBriefCard(lines: briefLines),
            ],
          ],
        ),
      ).motionEntrance(context, index: 0),
      const SizedBox(height: 12),
      ...homeLayout.visibleInOrder.toList().asMap().entries.expand(
        (entry) {
          final sectionIndex = entry.key + 1;
          var widgetIndex = 0;
          return _widgetsForHomeSection(
            entry.value,
            context: context,
            ref: ref,
            l10n: l10n,
            currency: currency,
            inflation: inflation,
            crypto: crypto,
            stocks: stocks,
            keyRate: keyRate,
            commodities: commodities,
            fearGreed: fearGreed,
            marketNews: marketNews,
            usIndices: usIndices,
            compact: compact,
            gap: gap,
            showSparklines: homeLayout.showSparklines,
            newsCount: homeLayout.newsCount,
          ).map((w) => w.motionEntrance(
                context,
                index: sectionIndex + widgetIndex++,
              ));
        },
      ),
      const SizedBox(height: 24),
      const Center(
        child: DataSourceBadge(
          source: 'MOEX · Frankfurter · World Bank · CoinGecko · CBR',
        ),
      ),
    ];
  }

/// Приватный метод [_widgetsForHomeSection] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  List<Widget> _widgetsForHomeSection(
    HomeSectionId sectionId, {
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations l10n,
    required AsyncValue<List<CurrencyRate>> currency,
    required AsyncValue<List<InflationPoint>> inflation,
    required AsyncValue<List<MarketAsset>> crypto,
    required AsyncValue<List<MarketAsset>> stocks,
    required AsyncValue<KeyRateSnapshot> keyRate,
    required AsyncValue<List<CommodityQuote>> commodities,
    required AsyncValue<FearGreedIndex?> fearGreed,
    required AsyncValue<List<NewsItem>> marketNews,
    required AsyncValue<List<MarketAsset>> usIndices,
    required bool compact,
    required double gap,
    required bool showSparklines,
    required int newsCount,
  }) {
    return switch (sectionId) {
      HomeSectionId.learn => [const CourseHomeCard()],
      HomeSectionId.portfolio => [const PortfolioHomeCard()],
      HomeSectionId.news => [
        NewsFeedCard(
          news: marketNews,
          maxItems: newsCount,
          onOpenMacroWeek: () => openAppPage(
            context,
            const MacroWeekScreen(),
          ),
          onOpenCalendar: () => openAppPage(
            context,
            const MacroCalendarScreen(),
          ),
        ),
        const SizedBox(height: 12),
      ],
      HomeSectionId.radar => [
        EconomicRadarCard(
          rates: currency.valueOrNull,
          keyRate: keyRate.valueOrNull,
          stocks: stocks.valueOrNull,
          inflation: inflation.valueOrNull,
          fearGreed: fearGreed.valueOrNull,
        ),
        const SizedBox(height: 12),
      ],
      HomeSectionId.indices => [
        ..._buildUsIndicesSection(
          context,
          usIndices,
          compact: compact,
          gap: gap,
          l10n: l10n,
          showSparklines: showSparklines,
        ),
        const SizedBox(height: 12),
      ],
      HomeSectionId.fearGreed => _buildFearGreedCard(fearGreed),
      HomeSectionId.currencies => [
        SectionHeader(
          title: l10n.sectionCurrencies,
          actionLabel: l10n.actionAll,
          onAction: () => ref.read(navigationIndexProvider.notifier).state = 1,
        ),
        ..._buildCurrencyCards(
          context,
          ref,
          currency,
          compact: compact,
          gap: gap,
          showSparklines: showSparklines,
        ),
      ],
      HomeSectionId.keyRate => [
        SectionHeader(
          title: l10n.sectionKeyRate,
          actionLabel: l10n.actionCalculators,
          onAction: () => ref.read(navigationIndexProvider.notifier).state = 2,
        ),
        ..._buildKeyRateCard(
          keyRate,
          compact: compact,
          l10n: l10n,
          context: context,
          showSparklines: showSparklines,
        ),
      ],
      HomeSectionId.inflation => [
        SectionHeader(
          title: l10n.sectionInflation,
          actionLabel: l10n.actionAll,
          onAction: () => ref.read(navigationIndexProvider.notifier).state = 2,
        ),
        ..._buildInflationCards(inflation, compact: compact, gap: gap, l10n: l10n),
      ],
      HomeSectionId.commodities => [
        SectionHeader(
          title: l10n.sectionCommodities,
          actionLabel: l10n.actionMarkets,
          onAction: () => ref.read(navigationIndexProvider.notifier).state = 3,
        ),
        ..._buildCommodityCards(
          commodities,
          compact: compact,
          gap: gap,
          l10n: l10n,
          showSparklines: showSparklines,
        ),
      ],
      HomeSectionId.markets => [
        SectionHeader(
          title: l10n.sectionMarkets,
          actionLabel: l10n.actionAll,
          onAction: () => ref.read(navigationIndexProvider.notifier).state = 3,
        ),
        ..._buildMarketCards(
          context,
          crypto,
          stocks,
          compact: compact,
          gap: gap,
          showSparklines: showSparklines,
        ),
      ],
      HomeSectionId.bonds => [
        SectionHeader(
          title: l10n.homeSectionBonds,
          actionLabel: l10n.actionAll,
          onAction: () {
            ref.read(marketsInitialTabProvider.notifier).state = 2;
            ref.read(navigationIndexProvider.notifier).state = 3;
          },
        ),
        const BondHomeCard(),
        const SizedBox(height: 12),
      ],
      HomeSectionId.watchlist => _buildWatchlistSection(
            context,
            ref,
            crypto,
            stocks,
            showSparklines: showSparklines,
          ),
      HomeSectionId.correlation => [
        const SizedBox(height: 12),
        const CorrelationPreviewCard(),
      ],
    };
  }

/// Приватный метод [_hasPartialError] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  bool _hasPartialError(
    AsyncValue<List<CurrencyRate>> currency,
    AsyncValue<List<InflationPoint>> inflation,
    AsyncValue<List<MarketAsset>> crypto,
    AsyncValue<List<MarketAsset>> stocks,
  ) {
    return currency.hasError ||
        inflation.hasError ||
        crypto.hasError ||
        stocks.hasError;
  }

/// Приватный метод [_buildUsIndicesSection] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  List<Widget> _buildUsIndicesSection(
    BuildContext context,
    AsyncValue<List<MarketAsset>> indices, {
    required bool compact,
    required double gap,
    required AppLocalizations l10n,
    required bool showSparklines,
  }) {
    return indices.when(
      data: (items) {
        if (items.isEmpty) return [];
        return [
          SectionHeader(title: l10n.indicesSectionTitle),
          if (compact && items.length > 1)
            _compactGrid(
              items
                  .map(
                    (a) => MetricCard(
                      compact: compact,
                      title: a.name,
                      value: Formatters.price(a.price),
                      changePercent: a.changePercent,
                      sparkline: homeSparklineData(
                        a.sparkline,
                        enabled: showSparklines,
                      ),
                      sourceBadge: 'Finnhub',
                    ),
                  )
                  .toList(),
              gap,
            )
          else
            ..._spaced(
              items
                  .map(
                    (a) => MetricCard(
                      compact: compact,
                      title: a.name,
                      value: Formatters.price(a.price),
                      changePercent: a.changePercent,
                      sparkline: homeSparklineData(
                        a.sparkline,
                        enabled: showSparklines,
                      ),
                      sourceBadge: 'Finnhub',
                    ),
                  )
                  .toList(),
              gap,
            ),
        ];
      },
      loading: () => [SectionHeader(title: l10n.indicesSectionTitle), const ShimmerCard()],
      error: (_, __) => [],
    );
  }

/// Приватный метод [_buildFearGreedCard] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  List<Widget> _buildFearGreedCard(AsyncValue<FearGreedIndex?> fng) {
    return fng.when(
      data: (data) {
        if (data == null) return [];
        final palette = AppPalette.of(context);
        final color = data.value <= 25
            ? palette.negative
            : data.value >= 75
                ? palette.positive
                : palette.accent;
        return [
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.psychology_outlined, color: color),
              title: Text(
                'Crypto Fear & Greed',
                style: TextStyle(color: palette.textPrimary, fontSize: 14),
              ),
              subtitle: Text(data.label, style: TextStyle(color: palette.textSecondary)),
              trailing: Text(
                '${data.value}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ];
      },
      loading: () => [const SizedBox(height: 12), const ShimmerCard()],
      error: (_, __) => [],
    );
  }

/// Приватный метод [_buildCommodityCards] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  List<Widget> _buildCommodityCards(
    AsyncValue<List<CommodityQuote>> commodities, {
    bool compact = false,
    double gap = 12,
    required AppLocalizations l10n,
    required bool showSparklines,
  }) {
    if (commodities.isLoading) {
      return const [ShimmerCard(), SizedBox(height: 12), ShimmerCard()];
    }

    return commodities.when(
      data: (items) {
        if (items.isEmpty) return [const SizedBox.shrink()];
        final cards = items
            .map(
              (c) => MetricCard(
                compact: compact,
                title: c.name,
                value: '${Formatters.rub(c.price)} ${c.unit}',
                numericValue: c.price,
                valueFormatter: Formatters.rub,
                changePercent: c.changePercent,
                sparkline: homeSparklineData(c.sparkline, enabled: showSparklines),
                sourceBadge: c.source,
              ),
            )
            .toList();
        if (compact && cards.length > 1) {
          return [_compactGrid(cards, gap)];
        }
        return _spaced(cards, gap);
      },
      loading: () => [const SizedBox.shrink()],
      error: (_, __) => [
        MetricCard(
          compact: compact,
          title: l10n.sectionCommodities,
          value: '—',
          subtitle: l10n.dataUnavailable,
        ),
      ],
    );
  }

/// Приватный метод [_buildKeyRateCard] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  List<Widget> _buildKeyRateCard(
    AsyncValue<KeyRateSnapshot> keyRate, {
    bool compact = false,
    required AppLocalizations l10n,
    required BuildContext context,
    required bool showSparklines,
  }) {
    if (keyRate.isLoading) {
      return const [ShimmerCard()];
    }

    return keyRate.when(
      data: (snapshot) => [
        MetricCard(
          compact: compact,
          title: l10n.sectionKeyRate,
          value: '${snapshot.current.toStringAsFixed(2)}%',
          numericValue: snapshot.current,
          valueFormatter: (v) => '${v.toStringAsFixed(2)}%',
          changePercent: snapshot.changePercent,
          sparkline: homeSparklineData(
            snapshot.history.map((p) => p.rate).toList(),
            enabled: showSparklines,
          ),
          sourceBadge: l10n.sourceCbr,
          subtitle: l10n.keyRateSince(
            snapshot.history.last.date.day,
            snapshot.history.last.date.month,
            snapshot.history.last.date.year,
          ),
          onTap: () => openAppPage(
            context,
            KeyRateDetailScreen(snapshot: snapshot),
          ),
        ),
      ],
      loading: () => [const SizedBox.shrink()],
      error: (_, __) => [
        MetricCard(
          title: l10n.sectionKeyRate,
          value: '—',
          subtitle: l10n.dataUnavailable,
        ),
      ],
    );
  }

/// Приватный метод [_buildCurrencyCards] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  List<Widget> _buildCurrencyCards(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<CurrencyRate>> currency, {
    bool compact = false,
    double gap = 12,
    required bool showSparklines,
  }) {
    if (currency.isLoading) {
      return const [
        ShimmerCard(),
        SizedBox(height: 12),
        ShimmerCard(),
      ];
    }

    return currency.when(
      data: (rates) {
        if (rates.isEmpty) return [const SizedBox.shrink()];
        final rubList = rates.where((CurrencyRate r) => r.isRub);
        final eurRubList =
            rates.where((CurrencyRate r) => r.base == 'RUB' && r.code == 'EUR');
        final eurList =
            rates.where((CurrencyRate r) => r.code == 'EUR' && r.base == 'USD');
        final rub = rubList.isEmpty ? null : rubList.first;
        final eurRub = eurRubList.isEmpty ? null : eurRubList.first;
        final eur = eurList.isEmpty ? null : eurList.first;

        final cards = <Widget>[
          if (rub != null)
            MetricCard(
              compact: compact,
              title: 'USD/RUB',
              value: Formatters.rub(rub.rate),
              numericValue: rub.rate,
              valueFormatter: Formatters.rub,
              changePercent: rub.changePercent,
              sparkline: homeSparklineData(
                rub.history.map((p) => p.value).toList(),
                enabled: showSparklines,
              ),
              sourceBadge: 'MOEX',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
            ),
          if (eurRub != null)
            MetricCard(
              compact: compact,
              title: 'EUR/RUB',
              value: Formatters.rub(eurRub.rate),
              numericValue: eurRub.rate,
              valueFormatter: Formatters.rub,
              changePercent: eurRub.changePercent,
              sparkline: homeSparklineData(
                eurRub.history.map((p) => p.value).toList(),
                enabled: showSparklines,
              ),
              sourceBadge: 'MOEX',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
            ),
          if (eur != null)
            MetricCard(
              compact: compact,
              title: 'USD/EUR',
              value: eur.rate.toStringAsFixed(4),
              changePercent: eur.changePercent,
              sparkline: homeSparklineData(
                eur.history.map((p) => p.value).toList(),
                enabled: showSparklines,
              ),
              sourceBadge: 'Frankfurter',
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
            ),
        ];
        if (compact && cards.length > 1) {
          return [_compactGrid(cards, gap)];
        }
        return _spaced(cards, gap);
      },
      loading: () => [const SizedBox.shrink()],
      error: (_, __) => [
        MetricCard(
          compact: compact,
          title: 'Валюты',
          value: '—',
          subtitle: 'Ошибка загрузки · нажмите обновить',
          onTap: () => ref.read(currencyRatesProvider.notifier).refresh(),
        ),
      ],
    );
  }

/// Приватный метод [_buildInflationCards] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  List<Widget> _buildInflationCards(
    AsyncValue<List<InflationPoint>> inflation, {
    bool compact = false,
    double gap = 12,
    required AppLocalizations l10n,
  }) {
    if (inflation.isLoading) {
      return const [
        ShimmerCard(),
        SizedBox(height: 12),
        ShimmerCard(),
      ];
    }

    return inflation.when(
      data: (points) {
        final ruList = points.where((InflationPoint p) => p.countryCode == 'RU');
        final usList = points.where((InflationPoint p) => p.countryCode == 'US');
        final ru = ruList.isEmpty ? null : ruList.first;
        final us = usList.isEmpty ? null : usList.first;

        final cards = <Widget>[
          if (ru != null)
            MetricCard(
              compact: compact,
              title: 'Инфляция ${ru.countryName} (${ru.year})',
              value: '${ru.value.toStringAsFixed(1)}%',
              subtitle: l10n.inflationYoy,
            ),
          if (us != null)
            MetricCard(
              compact: compact,
              title: 'Инфляция ${us.countryName} (${us.year})',
              value: '${us.value.toStringAsFixed(1)}%',
              subtitle: l10n.inflationYoy,
            ),
        ];
        if (compact && cards.length > 1) {
          return [_compactGrid(cards, gap)];
        }
        return _spaced(cards, gap);
      },
      loading: () => [const SizedBox.shrink()],
      error: (_, __) => [
        MetricCard(
          compact: compact,
          title: l10n.sectionInflation,
          value: '—',
          subtitle: l10n.dataUnavailable,
        ),
      ],
    );
  }

/// Приватный метод [_buildMarketCards] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  List<Widget> _buildMarketCards(
    BuildContext context,
    AsyncValue<List<MarketAsset>> crypto,
    AsyncValue<List<MarketAsset>> stocks, {
    bool compact = false,
    double gap = 12,
    required bool showSparklines,
  }) {
    final widgets = <Widget>[];

    if (crypto.isLoading && stocks.isLoading) {
      return const [
        ShimmerCard(),
        SizedBox(height: 12),
        ShimmerCard(),
      ];
    }

    crypto.when(
      data: (assets) {
        final btcList = assets.where((MarketAsset a) => a.symbol == 'BTC');
        final btc = btcList.isEmpty ? null : btcList.first;
        if (btc != null) {
          widgets.add(
            MetricCard(
              compact: compact,
              title: 'Bitcoin',
              heroWatchlistKey: watchlistKey(btc),
              value: Formatters.price(btc.price),
              numericValue: btc.price,
              valueFormatter: (v) => Formatters.price(v),
              changePercent: btc.changePercent,
              sparkline: homeSparklineData(btc.sparkline, enabled: showSparklines),
              sourceBadge: 'CoinGecko',
              onTap: () => openAppPage(
                context,
                AssetDetailScreen(asset: btc),
              ),
            ),
          );
        }
      },
      loading: () {},
      error: (_, __) {
        widgets.add(
          const MetricCard(
            title: 'Крипто',
            value: '—',
            subtitle: 'CoinGecko недоступен',
          ),
        );
      },
    );

    stocks.when(
      data: (assets) {
        final imoexList = assets.where((MarketAsset a) => a.symbol == 'IMOEX');
        final imoex = imoexList.isEmpty ? null : imoexList.first;
        if (imoex != null) {
          widgets.add(
            MetricCard(
              compact: compact,
              title: 'IMOEX',
              heroWatchlistKey: watchlistKey(imoex),
              value: Formatters.rub(imoex.price),
              numericValue: imoex.price,
              valueFormatter: Formatters.rub,
              changePercent: imoex.changePercent,
              sparkline: homeSparklineData(imoex.sparkline, enabled: showSparklines),
              sourceBadge: 'MOEX',
              onTap: () => openAppPage(
                context,
                AssetDetailScreen(asset: imoex),
              ),
            ),
          );
        }
      },
      loading: () {},
      error: (_, __) {},
    );

    if (compact && widgets.length > 1) {
      return [_compactGrid(widgets, gap)];
    }
    return _spaced(widgets, gap);
  }

/// Приватный метод [_spaced] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  List<Widget> _spaced(List<Widget> cards, double gap) {
    if (cards.isEmpty) return [];
    final result = <Widget>[cards.first];
    for (var i = 1; i < cards.length; i++) {
      result.add(SizedBox(height: gap));
      result.add(cards[i]);
    }
    return result;
  }

/// Приватный метод [_compactGrid] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  Widget _compactGrid(List<Widget> cards, double gap) {
    final rows = <Widget>[];
    for (var i = 0; i < cards.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards[i]),
            if (i + 1 < cards.length) ...[
              SizedBox(width: gap),
              Expanded(child: cards[i + 1]),
            ],
          ],
        ),
      );
      if (i + 2 < cards.length) rows.add(SizedBox(height: gap));
    }
    return Column(children: rows);
  }

/// Приватный метод [_buildWatchlistSection] класса [_HomeScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  List<Widget> _buildWatchlistSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<MarketAsset>> crypto,
    AsyncValue<List<MarketAsset>> stocks, {
    required bool showSparklines,
  }) {
    final keys = ref.watch(watchlistProvider);
    if (keys.isEmpty) return [];

    final allAssets = <MarketAsset>[];
    crypto.whenData((list) => allAssets.addAll(list));
    stocks.whenData((list) => allAssets.addAll(list));
    ref.watch(bondsProvider).whenData(allAssets.addAll);

    if (allAssets.isEmpty) return [];

    final favorites = keys
        .map((k) => assetFromKey(k, allAssets))
        .whereType<MarketAsset>()
        .toList();

    if (favorites.isEmpty) return [];
    final l10n = AppLocalizations.of(context)!;

    return [
      SectionHeader(
        title: l10n.sectionWatchlist,
        actionLabel: l10n.actionMarkets,
        onAction: () => ref.read(navigationIndexProvider.notifier).state = 3,
      ),
      const WatchlistVolatilityHeatmap(),
      const SizedBox(height: 12),
      ...favorites.map(
        (asset) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MetricCard(
            title: '${asset.symbol} · ${asset.name}',
            heroWatchlistKey: watchlistKey(asset),
            value: asset.currency == 'RUB'
                ? Formatters.rub(asset.price)
                : Formatters.price(asset.price),
            changePercent: asset.changePercent,
            sparkline: homeSparklineData(asset.sparkline, enabled: showSparklines),
            sourceBadge: sourceLabelForAsset(asset),
            onTap: () => openAppPage(
              context,
              AssetDetailScreen(asset: asset),
            ),
          ),
        ),
      ),
    ];
  }
}
