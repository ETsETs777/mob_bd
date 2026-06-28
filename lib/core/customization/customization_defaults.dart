import '../../data/models/user_customization.dart';

/// Заводские значения кастомизации (совпадают с текущим поведением v1.0.44).
class CustomizationDefaults {
  CustomizationDefaults._();

  static const homeSectionIds = [
    'learn',
    'portfolio',
    'news',
    'radar',
    'indices',
    'fearGreed',
    'currencies',
    'keyRate',
    'inflation',
    'commodities',
    'markets',
    'bonds',
    'watchlist',
    'correlation',
  ];

  static UserCustomization create({DateTime? updatedAt}) {
    final now = updatedAt ?? DateTime.now().toUtc();
    return UserCustomization(
      charts: ChartCustomization(
        defaultType: ChartTypeId.line,
        defaultPeriodKey: 'd30',
        defaultHeight: ChartHeightPreset.normal,
        preferCandlesWhenAvailable: true,
        normalizedCompare: true,
        showLegend: true,
        seriesPalette: SeriesPalettePreset.defaultPreset,
        customSeriesColorsHex: const [],
        visual: const ChartVisualOptions(),
        contextProfiles: {
          for (final ctx in ChartContextId.values)
            ctx: ChartContextProfile(
              useGlobalDefaults: ctx != ChartContextId.inflation &&
                  ctx != ChartContextId.compare,
              type: switch (ctx) {
                ChartContextId.inflation => ChartTypeId.bar,
                ChartContextId.compare => ChartTypeId.normalizedOverlay,
                ChartContextId.portfolio => ChartTypeId.pie,
                ChartContextId.bonds => ChartTypeId.yieldCurve,
                _ => null,
              },
            ),
        },
      ),
      appearance: const AppearanceCustomization(
        themeModeKey: 'dark',
        accentKey: 'blue',
        backgroundKey: 'classic',
        uiDensity: UiDensity.comfortable,
        fontScale: 1.0,
        cardStyle: CardStyleId.glass,
        motionReduced: false,
        amoledPureBlack: false,
      ),
      home: HomeCustomization(
        compactHome: false,
        sectionVisibility: {
          for (final id in homeSectionIds) id: true,
        },
        sectionOrder: List<String>.from(homeSectionIds),
        newsCount: 5,
        showSparklines: true,
      ),
      navigation: const NavigationCustomization(
        defaultTabIndex: 0,
        visibleTabIndices: [0, 1, 2, 3, 4, 5],
        tabOrder: [0, 1, 2, 3, 4, 5],
        showAssistantFab: true,
        hideNavLabels: false,
      ),
      markets: const MarketsCustomization(
        groupStocksBySector: false,
        showSectorHeatmap: true,
        defaultStockRegion: 'RU',
        listRowCompact: false,
      ),
      portfolio: const PortfolioCustomization(
        allocationChartType: AllocationChartType.pie,
        showRealizedPnl: true,
        showJournal: true,
      ),
      widgets: const WidgetCustomization(
        layout: 'auto',
        slots: ['usdRub', 'btc', 'keyRate', 'imoex'],
      ),
      dataDisplay: const DataDisplayCustomization(
        baseCurrency: 'usd',
        localeCode: 'ru',
        decimalPlaces: DecimalPlacesMode.auto,
        largeNumberFormat: LargeNumberFormatId.localized,
        showCurrencyCode: false,
        use24HourTime: true,
      ),
      assistant: const AssistantCustomization(
        preferCloud: false,
        showQuickChips: true,
        voiceInputEnabled: true,
      ),
      meta: CustomizationMeta(
        schemaVersion: UserCustomization.currentSchemaVersion,
        updatedAt: now,
      ),
    );
  }
}
