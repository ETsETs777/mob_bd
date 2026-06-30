import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/customization/appearance_resolver.dart';
import '../../core/customization/chart_registry.dart';
import '../../core/customization/home_customization_resolver.dart';
import '../../core/customization/navigation_customization_resolver.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/price_point.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app/home_layout_provider.dart';
import '../../providers/locale_provider.dart';
import '../shared/widgets/custom_chart_view.dart';

/// Live preview 2.0: carousel of chart, home, markets, portfolio, navigation.
class CustomizationPreview extends ConsumerStatefulWidget {
  const CustomizationPreview({
    super.key,
    required this.config,
    required this.palette,
  });

  final UserCustomization config;
  final AppPalette palette;

  @override
  ConsumerState<CustomizationPreview> createState() =>
      _CustomizationPreviewState();
}

class _CustomizationPreviewState extends ConsumerState<CustomizationPreview> {
  static const _slideCount = 5;

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static List<PricePoint> _samplePoints() {
    final now = DateTime.now();
    return List.generate(
      14,
      (i) => PricePoint(
        date: now.subtract(Duration(days: 13 - i)),
        value: 88 + i * 0.45 + (i % 4) * 0.15,
      ),
    );
  }

  double _chartHeight(ChartHeightPreset preset) => switch (preset) {
        ChartHeightPreset.compact => 100,
        ChartHeightPreset.normal => 130,
        ChartHeightPreset.tall => 160,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRu = ref.watch(localeProvider) == AppLocale.ru;
    final config = widget.config;
    final palette = widget.palette;
    final charts = config.charts;
    final appearance = config.appearance;
    final resolvedAppearance = AppearanceResolver.resolve(appearance);

    final slideTitles = [
      l10n.customizationPreviewSlideChart,
      l10n.customizationPreviewSlideHome,
      l10n.customizationPreviewSlideMarkets,
      l10n.customizationPreviewSlidePortfolio,
      l10n.customizationPreviewSlideNavigation,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customizationPreview,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            const Gap(4),
            Text(
              l10n.customizationPreviewCarouselHint,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
            const Gap(12),
            SizedBox(
              height: 200,
              child: PageView(
                controller: _pageController,
                children: [
                  _PreviewFrame(
                    palette: palette,
                    title: slideTitles[0],
                    child: CustomChartView(
                      contextId: ChartContextId.currency,
                      height: _chartHeight(charts.defaultHeight),
                      input: ChartRenderInput(
                        points: _samplePoints(),
                        currencySymbol: '₽',
                      ),
                    ),
                  ),
                  _PreviewFrame(
                    palette: palette,
                    title: slideTitles[1],
                    child: _HomePreview(config: config, palette: palette, l10n: l10n),
                  ),
                  _PreviewFrame(
                    palette: palette,
                    title: slideTitles[2],
                    child: _MarketsPreview(config: config, palette: palette),
                  ),
                  _PreviewFrame(
                    palette: palette,
                    title: slideTitles[3],
                    child: _PortfolioPreview(config: config, palette: palette, l10n: l10n),
                  ),
                  _PreviewFrame(
                    palette: palette,
                    title: slideTitles[4],
                    child: _NavigationPreview(config: config, palette: palette, l10n: l10n),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _slideCount,
                effect: WormEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: palette.accent,
                  dotColor: palette.border,
                ),
              ),
            ),
            const Gap(10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Chip(
                  label: l10n.customizationPreviewTheme(appearance.themeModeKey),
                  palette: palette,
                ),
                _Chip(
                  label: l10n.customizationPreviewAccent(appearance.accentKey),
                  palette: palette,
                ),
                _Chip(
                  label: ChartRegistry.describe(charts.defaultType).label(isRu: isRu),
                  palette: palette,
                ),
                _Chip(
                  label: isRu
                      ? switch (resolvedAppearance.uiDensity) {
                          UiDensity.compact => 'Компактно',
                          UiDensity.comfortable => 'Стандарт',
                          UiDensity.spacious => 'Просторно',
                        }
                      : switch (resolvedAppearance.uiDensity) {
                          UiDensity.compact => 'Compact',
                          UiDensity.comfortable => 'Comfortable',
                          UiDensity.spacious => 'Spacious',
                        },
                  palette: palette,
                ),
                _Chip(
                  label: resolvedAppearance.cardStyle.name,
                  palette: palette,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({
    required this.palette,
    required this.title,
    required this.child,
  });

  final AppPalette palette;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
        color: palette.surface.withValues(alpha: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
          const Gap(8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _HomePreview extends StatelessWidget {
  const _HomePreview({
    required this.config,
    required this.palette,
    required this.l10n,
  });

  final UserCustomization config;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final layout = HomeCustomizationResolver.resolve(config.home);
    final sections = layout.visibleInOrder.take(4).toList();

    return Column(
      children: [
        for (final section in sections)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: palette.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: palette.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: palette.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      _homeSectionLabel(section, l10n),
                      style: TextStyle(fontSize: 12, color: palette.textPrimary),
                    ),
                  ),
                  if (layout.compactHome)
                    Text(
                      l10n.customizationPreviewCompact,
                      style: TextStyle(fontSize: 10, color: palette.textSecondary),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _homeSectionLabel(HomeSectionId section, AppLocalizations l10n) =>
      switch (section) {
        HomeSectionId.learn => l10n.homeSectionLearn,
        HomeSectionId.featuredArticles => l10n.homeSectionFeaturedArticles,
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
}

class _MarketsPreview extends StatelessWidget {
  const _MarketsPreview({required this.config, required this.palette});

  final UserCustomization config;
  final AppPalette palette;

  static const _tickers = ['SBER', 'BTC', 'IMOEX'];

  @override
  Widget build(BuildContext context) {
    final markets = config.markets;
    final region = markets.defaultStockRegion;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            region,
            style: TextStyle(fontSize: 10, color: palette.textSecondary),
          ),
        ),
        const Gap(6),
        for (final ticker in _tickers)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  ticker,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: palette.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: palette.positive.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const Gap(8),
                Text(
                  '+1.2%',
                  style: TextStyle(fontSize: 11, color: palette.positive),
                ),
              ],
            ),
          ),
        if (markets.listRowCompact)
          Text(
            'Compact rows',
            style: TextStyle(fontSize: 10, color: palette.textSecondary),
          ),
      ],
    );
  }
}

class _PortfolioPreview extends StatelessWidget {
  const _PortfolioPreview({
    required this.config,
    required this.palette,
    required this.l10n,
  });

  final UserCustomization config;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final portfolio = config.portfolio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '₽ 128 450',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
          ),
        ),
        Text(
          '+4.2%',
          style: TextStyle(fontSize: 12, color: palette.positive),
        ),
        const Gap(10),
        _AllocationBar(label: 'Stocks', percent: 45, color: palette.accent, palette: palette),
        const Gap(4),
        _AllocationBar(label: 'Bonds', percent: 25, color: palette.positive, palette: palette),
        const Gap(4),
        _AllocationBar(label: 'Cash', percent: 20, color: palette.textSecondary, palette: palette),
        if (portfolio.showJournal)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.portfolioTradeJournalTitle,
              style: TextStyle(fontSize: 10, color: palette.textSecondary),
            ),
          ),
      ],
    );
  }
}

class _AllocationBar extends StatelessWidget {
  const _AllocationBar({
    required this.label,
    required this.percent,
    required this.color,
    required this.palette,
  });

  final String label;
  final int percent;
  final Color color;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(label, style: TextStyle(fontSize: 10, color: palette.textSecondary)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: palette.border,
              color: color,
            ),
          ),
        ),
        const Gap(6),
        Text('$percent%', style: TextStyle(fontSize: 10, color: palette.textPrimary)),
      ],
    );
  }
}

class _NavigationPreview extends StatelessWidget {
  const _NavigationPreview({
    required this.config,
    required this.palette,
    required this.l10n,
  });

  final UserCustomization config;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final nav = NavigationCustomizationResolver.resolve(config.navigation);
    final defaultIdx = nav.effectiveDefaultIndex;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Center(
            child: Text(
              _tabLabel(defaultIdx, l10n),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: palette.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final idx in nav.orderedVisibleIndices)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: idx == defaultIdx ? palette.accent : palette.textSecondary,
                    ),
                    if (!nav.hideNavLabels) ...[
                      const Gap(2),
                      Text(
                        _tabLabel(idx, l10n),
                        style: TextStyle(
                          fontSize: 9,
                          color: idx == defaultIdx
                              ? palette.accent
                              : palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              if (nav.showAssistantFab)
                Icon(Icons.add_circle, size: 16, color: palette.accent),
            ],
          ),
        ),
      ],
    );
  }

  String _tabLabel(int index, AppLocalizations l10n) => switch (index) {
        0 => l10n.tabHome,
        1 => l10n.tabCurrency,
        2 => l10n.tabInflation,
        3 => l10n.tabMarkets,
        4 => l10n.tabProfile,
        5 => l10n.tabCommunity,
        _ => l10n.tabHome,
      };
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.palette});

  final String label;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: palette.textSecondary),
      ),
    );
  }
}
