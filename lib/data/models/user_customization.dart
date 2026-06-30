/// Единая модель пользовательской кастомизации EcoPulse.
///
/// Сериализуется в Hive как JSON (`customization_config`).
class UserCustomization {
  const UserCustomization({
    required this.charts,
    required this.appearance,
    required this.home,
    required this.navigation,
    required this.markets,
    required this.portfolio,
    required this.widgets,
    required this.dataDisplay,
    required this.assistant,
    required this.meta,
  });

  static const currentSchemaVersion = 1;

  final ChartCustomization charts;
  final AppearanceCustomization appearance;
  final HomeCustomization home;
  final NavigationCustomization navigation;
  final MarketsCustomization markets;
  final PortfolioCustomization portfolio;
  final WidgetCustomization widgets;
  final DataDisplayCustomization dataDisplay;
  final AssistantCustomization assistant;
  final CustomizationMeta meta;

  UserCustomization copyWith({
    ChartCustomization? charts,
    AppearanceCustomization? appearance,
    HomeCustomization? home,
    NavigationCustomization? navigation,
    MarketsCustomization? markets,
    PortfolioCustomization? portfolio,
    WidgetCustomization? widgets,
    DataDisplayCustomization? dataDisplay,
    AssistantCustomization? assistant,
    CustomizationMeta? meta,
  }) {
    return UserCustomization(
      charts: charts ?? this.charts,
      appearance: appearance ?? this.appearance,
      home: home ?? this.home,
      navigation: navigation ?? this.navigation,
      markets: markets ?? this.markets,
      portfolio: portfolio ?? this.portfolio,
      widgets: widgets ?? this.widgets,
      dataDisplay: dataDisplay ?? this.dataDisplay,
      assistant: assistant ?? this.assistant,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': meta.schemaVersion,
        'updatedAt': meta.updatedAt.toIso8601String(),
        'activePresetId': meta.activePresetId,
        'charts': charts.toJson(),
        'appearance': appearance.toJson(),
        'home': home.toJson(),
        'navigation': navigation.toJson(),
        'markets': markets.toJson(),
        'portfolio': portfolio.toJson(),
        'widgets': widgets.toJson(),
        'dataDisplay': dataDisplay.toJson(),
        'assistant': assistant.toJson(),
      };

  factory UserCustomization.fromJson(Map<String, dynamic> json) {
    final schema = json['schemaVersion'] as int? ?? 1;
    return UserCustomization(
      charts: ChartCustomization.fromJson(
        json['charts'] as Map<String, dynamic>? ?? {},
      ),
      appearance: AppearanceCustomization.fromJson(
        json['appearance'] as Map<String, dynamic>? ?? {},
      ),
      home: HomeCustomization.fromJson(
        json['home'] as Map<String, dynamic>? ?? {},
      ),
      navigation: NavigationCustomization.fromJson(
        json['navigation'] as Map<String, dynamic>? ?? {},
      ),
      markets: MarketsCustomization.fromJson(
        json['markets'] as Map<String, dynamic>? ?? {},
      ),
      portfolio: PortfolioCustomization.fromJson(
        json['portfolio'] as Map<String, dynamic>? ?? {},
      ),
      widgets: WidgetCustomization.fromJson(
        json['widgets'] as Map<String, dynamic>? ?? {},
      ),
      dataDisplay: DataDisplayCustomization.fromJson(
        json['dataDisplay'] as Map<String, dynamic>? ?? {},
      ),
      assistant: AssistantCustomization.fromJson(
        json['assistant'] as Map<String, dynamic>? ?? {},
      ),
      meta: CustomizationMeta(
        schemaVersion: schema,
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        activePresetId: json['activePresetId'] as String?,
      ),
    );
  }
}

class CustomizationMeta {
  const CustomizationMeta({
    required this.schemaVersion,
    required this.updatedAt,
    this.activePresetId,
  });

  final int schemaVersion;
  final DateTime updatedAt;
  final String? activePresetId;

  CustomizationMeta copyWith({
    int? schemaVersion,
    DateTime? updatedAt,
    String? activePresetId,
  }) {
    return CustomizationMeta(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      activePresetId: activePresetId ?? this.activePresetId,
    );
  }
}

/// Идентификаторы типов графиков (реестр, пункт 3).
enum ChartTypeId {
  line,
  area,
  bar,
  candlestick,
  stepLine,
  normalizedOverlay,
  pie,
  donut,
  heatmap,
  ladder,
  yieldCurve,
}

enum ChartContextId {
  assetDetail,
  inflation,
  currency,
  compare,
  portfolio,
  bonds,
  keyRate,
  homeSparkline,
}

enum ChartHeightPreset { compact, normal, tall }

enum ChartGridStyle { solid, dotted, none }

enum SeriesPalettePreset {
  defaultPreset,
  pastel,
  highContrast,
  colorblindSafe,
  custom,
}

enum UiDensity { comfortable, compact, spacious }

enum CardStyleId { flat, glass, bordered }

enum DecimalPlacesMode { auto, fixed0, fixed2, fixed4 }

enum LargeNumberFormatId { short, localized }

enum AllocationChartType { pie, donut, bar }

class ChartVisualOptions {
  const ChartVisualOptions({
    this.showGrid = true,
    this.gridStyle = ChartGridStyle.solid,
    this.showGradientFill = true,
    this.lineWidth = 2.0,
    this.showPointMarkers = false,
    this.showCrosshair = true,
    this.showEventMarkers = true,
    this.animateOnLoad = true,
    this.bullColorHex,
    this.bearColorHex,
    this.showVolume = true,
    this.enablePanZoom = true,
    this.priceAxisRight = true,
    this.showMa7 = false,
    this.showMa25 = false,
    this.showMa99 = false,
  });

  final bool showGrid;
  final ChartGridStyle gridStyle;
  final bool showGradientFill;
  final double lineWidth;
  final bool showPointMarkers;
  final bool showCrosshair;
  final bool showEventMarkers;
  final bool animateOnLoad;
  final String? bullColorHex;
  final String? bearColorHex;
  final bool showVolume;
  final bool enablePanZoom;
  final bool priceAxisRight;
  final bool showMa7;
  final bool showMa25;
  final bool showMa99;

  ChartVisualOptions copyWith({
    bool? showGrid,
    ChartGridStyle? gridStyle,
    bool? showGradientFill,
    double? lineWidth,
    bool? showPointMarkers,
    bool? showCrosshair,
    bool? showEventMarkers,
    bool? animateOnLoad,
    String? bullColorHex,
    String? bearColorHex,
    bool? showVolume,
    bool? enablePanZoom,
    bool? priceAxisRight,
    bool? showMa7,
    bool? showMa25,
    bool? showMa99,
  }) {
    return ChartVisualOptions(
      showGrid: showGrid ?? this.showGrid,
      gridStyle: gridStyle ?? this.gridStyle,
      showGradientFill: showGradientFill ?? this.showGradientFill,
      lineWidth: lineWidth ?? this.lineWidth,
      showPointMarkers: showPointMarkers ?? this.showPointMarkers,
      showCrosshair: showCrosshair ?? this.showCrosshair,
      showEventMarkers: showEventMarkers ?? this.showEventMarkers,
      animateOnLoad: animateOnLoad ?? this.animateOnLoad,
      bullColorHex: bullColorHex ?? this.bullColorHex,
      bearColorHex: bearColorHex ?? this.bearColorHex,
      showVolume: showVolume ?? this.showVolume,
      enablePanZoom: enablePanZoom ?? this.enablePanZoom,
      priceAxisRight: priceAxisRight ?? this.priceAxisRight,
      showMa7: showMa7 ?? this.showMa7,
      showMa25: showMa25 ?? this.showMa25,
      showMa99: showMa99 ?? this.showMa99,
    );
  }

  Map<String, dynamic> toJson() => {
        'showGrid': showGrid,
        'gridStyle': gridStyle.name,
        'showGradientFill': showGradientFill,
        'lineWidth': lineWidth,
        'showPointMarkers': showPointMarkers,
        'showCrosshair': showCrosshair,
        'showEventMarkers': showEventMarkers,
        'animateOnLoad': animateOnLoad,
        'bullColorHex': bullColorHex,
        'bearColorHex': bearColorHex,
        'showVolume': showVolume,
        'enablePanZoom': enablePanZoom,
        'priceAxisRight': priceAxisRight,
        'showMa7': showMa7,
        'showMa25': showMa25,
        'showMa99': showMa99,
      };

  factory ChartVisualOptions.fromJson(Map<String, dynamic> json) {
    return ChartVisualOptions(
      showGrid: json['showGrid'] as bool? ?? true,
      gridStyle: _enumByName(
        ChartGridStyle.values,
        json['gridStyle'] as String?,
        ChartGridStyle.solid,
      ),
      showGradientFill: json['showGradientFill'] as bool? ?? true,
      lineWidth: (json['lineWidth'] as num?)?.toDouble() ?? 2.0,
      showPointMarkers: json['showPointMarkers'] as bool? ?? false,
      showCrosshair: json['showCrosshair'] as bool? ?? true,
      showEventMarkers: json['showEventMarkers'] as bool? ?? true,
      animateOnLoad: json['animateOnLoad'] as bool? ?? true,
      bullColorHex: json['bullColorHex'] as String?,
      bearColorHex: json['bearColorHex'] as String?,
      showVolume: json['showVolume'] as bool? ?? true,
      enablePanZoom: json['enablePanZoom'] as bool? ?? true,
      priceAxisRight: json['priceAxisRight'] as bool? ?? true,
      showMa7: json['showMa7'] as bool? ?? false,
      showMa25: json['showMa25'] as bool? ?? false,
      showMa99: json['showMa99'] as bool? ?? false,
    );
  }
}

class ChartContextProfile {
  const ChartContextProfile({
    this.useGlobalDefaults = true,
    this.type,
    this.periodKey,
    this.visual,
  });

  final bool useGlobalDefaults;
  final ChartTypeId? type;
  final String? periodKey;
  final ChartVisualOptions? visual;

  ChartContextProfile copyWith({
    bool? useGlobalDefaults,
    ChartTypeId? type,
    String? periodKey,
    ChartVisualOptions? visual,
  }) {
    return ChartContextProfile(
      useGlobalDefaults: useGlobalDefaults ?? this.useGlobalDefaults,
      type: type ?? this.type,
      periodKey: periodKey ?? this.periodKey,
      visual: visual ?? this.visual,
    );
  }

  Map<String, dynamic> toJson() => {
        'useGlobalDefaults': useGlobalDefaults,
        'type': type?.name,
        'periodKey': periodKey,
        'visual': visual?.toJson(),
      };

  factory ChartContextProfile.fromJson(Map<String, dynamic> json) {
    return ChartContextProfile(
      useGlobalDefaults: json['useGlobalDefaults'] as bool? ?? true,
      type: _enumByNameNullable<ChartTypeId>(
        ChartTypeId.values,
        json['type'] as String?,
      ),
      periodKey: json['periodKey'] as String?,
      visual: json['visual'] is Map<String, dynamic>
          ? ChartVisualOptions.fromJson(json['visual'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChartCustomization {
  const ChartCustomization({
    required this.defaultType,
    required this.defaultPeriodKey,
    required this.defaultHeight,
    required this.preferCandlesWhenAvailable,
    required this.normalizedCompare,
    required this.showLegend,
    required this.seriesPalette,
    required this.customSeriesColorsHex,
    required this.visual,
    required this.contextProfiles,
  });

  final ChartTypeId defaultType;
  final String defaultPeriodKey;
  final ChartHeightPreset defaultHeight;
  final bool preferCandlesWhenAvailable;
  final bool normalizedCompare;
  final bool showLegend;
  final SeriesPalettePreset seriesPalette;
  final List<String> customSeriesColorsHex;
  final ChartVisualOptions visual;
  final Map<ChartContextId, ChartContextProfile> contextProfiles;

  ChartCustomization copyWith({
    ChartTypeId? defaultType,
    String? defaultPeriodKey,
    ChartHeightPreset? defaultHeight,
    bool? preferCandlesWhenAvailable,
    bool? normalizedCompare,
    bool? showLegend,
    SeriesPalettePreset? seriesPalette,
    List<String>? customSeriesColorsHex,
    ChartVisualOptions? visual,
    Map<ChartContextId, ChartContextProfile>? contextProfiles,
  }) {
    return ChartCustomization(
      defaultType: defaultType ?? this.defaultType,
      defaultPeriodKey: defaultPeriodKey ?? this.defaultPeriodKey,
      defaultHeight: defaultHeight ?? this.defaultHeight,
      preferCandlesWhenAvailable:
          preferCandlesWhenAvailable ?? this.preferCandlesWhenAvailable,
      normalizedCompare: normalizedCompare ?? this.normalizedCompare,
      showLegend: showLegend ?? this.showLegend,
      seriesPalette: seriesPalette ?? this.seriesPalette,
      customSeriesColorsHex:
          customSeriesColorsHex ?? this.customSeriesColorsHex,
      visual: visual ?? this.visual,
      contextProfiles: contextProfiles ?? this.contextProfiles,
    );
  }

  ChartContextProfile profileFor(ChartContextId context) {
    return contextProfiles[context] ?? const ChartContextProfile();
  }

  Map<String, dynamic> toJson() => {
        'defaultType': defaultType.name,
        'defaultPeriodKey': defaultPeriodKey,
        'defaultHeight': defaultHeight.name,
        'preferCandlesWhenAvailable': preferCandlesWhenAvailable,
        'normalizedCompare': normalizedCompare,
        'showLegend': showLegend,
        'seriesPalette': seriesPalette.name,
        'customSeriesColorsHex': customSeriesColorsHex,
        'visual': visual.toJson(),
        'contextProfiles': contextProfiles.map(
          (k, v) => MapEntry(k.name, v.toJson()),
        ),
      };

  factory ChartCustomization.fromJson(Map<String, dynamic> json) {
    final profilesRaw =
        json['contextProfiles'] as Map<String, dynamic>? ?? {};
    final profiles = <ChartContextId, ChartContextProfile>{};
    for (final entry in profilesRaw.entries) {
      final id = _enumByNameNullable<ChartContextId>(
        ChartContextId.values,
        entry.key,
      );
      if (id == null) continue;
      profiles[id] = ChartContextProfile.fromJson(
        Map<String, dynamic>.from(entry.value as Map),
      );
    }

    return ChartCustomization(
      defaultType: _enumByName(
        ChartTypeId.values,
        json['defaultType'] as String?,
        ChartTypeId.line,
      ),
      defaultPeriodKey: json['defaultPeriodKey'] as String? ?? 'd30',
      defaultHeight: _enumByName(
        ChartHeightPreset.values,
        json['defaultHeight'] as String?,
        ChartHeightPreset.normal,
      ),
      preferCandlesWhenAvailable:
          json['preferCandlesWhenAvailable'] as bool? ?? true,
      normalizedCompare: json['normalizedCompare'] as bool? ?? true,
      showLegend: json['showLegend'] as bool? ?? true,
      seriesPalette: _enumByName(
        SeriesPalettePreset.values,
        json['seriesPalette'] as String?,
        SeriesPalettePreset.defaultPreset,
      ),
      customSeriesColorsHex: (json['customSeriesColorsHex'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      visual: ChartVisualOptions.fromJson(
        json['visual'] as Map<String, dynamic>? ?? {},
      ),
      contextProfiles: profiles,
    );
  }
}

class AppearanceCustomization {
  const AppearanceCustomization({
    required this.themeModeKey,
    required this.accentKey,
    required this.backgroundKey,
    required this.uiDensity,
    required this.fontScale,
    required this.cardStyle,
    required this.motionReduced,
    required this.amoledPureBlack,
    this.perTabThemesEnabled = false,
    this.marketsThemeModeKey = 'dark',
    this.profileThemeModeKey = 'light',
  });

  final String themeModeKey;
  final String accentKey;
  final String backgroundKey;
  final UiDensity uiDensity;
  final double fontScale;
  final CardStyleId cardStyle;
  final bool motionReduced;
  final bool amoledPureBlack;
  /// Независимые пресеты темы для вкладок Markets и Profile.
  final bool perTabThemesEnabled;
  final String marketsThemeModeKey;
  final String profileThemeModeKey;

  AppearanceCustomization copyWith({
    String? themeModeKey,
    String? accentKey,
    String? backgroundKey,
    UiDensity? uiDensity,
    double? fontScale,
    CardStyleId? cardStyle,
    bool? motionReduced,
    bool? amoledPureBlack,
    bool? perTabThemesEnabled,
    String? marketsThemeModeKey,
    String? profileThemeModeKey,
  }) {
    return AppearanceCustomization(
      themeModeKey: themeModeKey ?? this.themeModeKey,
      accentKey: accentKey ?? this.accentKey,
      backgroundKey: backgroundKey ?? this.backgroundKey,
      uiDensity: uiDensity ?? this.uiDensity,
      fontScale: fontScale ?? this.fontScale,
      cardStyle: cardStyle ?? this.cardStyle,
      motionReduced: motionReduced ?? this.motionReduced,
      amoledPureBlack: amoledPureBlack ?? this.amoledPureBlack,
      perTabThemesEnabled:
          perTabThemesEnabled ?? this.perTabThemesEnabled,
      marketsThemeModeKey:
          marketsThemeModeKey ?? this.marketsThemeModeKey,
      profileThemeModeKey:
          profileThemeModeKey ?? this.profileThemeModeKey,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeModeKey': themeModeKey,
        'accentKey': accentKey,
        'backgroundKey': backgroundKey,
        'uiDensity': uiDensity.name,
        'fontScale': fontScale,
        'cardStyle': cardStyle.name,
        'motionReduced': motionReduced,
        'amoledPureBlack': amoledPureBlack,
        'perTabThemesEnabled': perTabThemesEnabled,
        'marketsThemeModeKey': marketsThemeModeKey,
        'profileThemeModeKey': profileThemeModeKey,
      };

  factory AppearanceCustomization.fromJson(Map<String, dynamic> json) {
    return AppearanceCustomization(
      themeModeKey: json['themeModeKey'] as String? ?? 'dark',
      accentKey: json['accentKey'] as String? ?? 'blue',
      backgroundKey: json['backgroundKey'] as String? ?? 'classic',
      uiDensity: _enumByName(
        UiDensity.values,
        json['uiDensity'] as String?,
        UiDensity.comfortable,
      ),
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      cardStyle: _enumByName(
        CardStyleId.values,
        json['cardStyle'] as String?,
        CardStyleId.glass,
      ),
      motionReduced: json['motionReduced'] as bool? ?? false,
      amoledPureBlack: json['amoledPureBlack'] as bool? ?? false,
      perTabThemesEnabled: json['perTabThemesEnabled'] as bool? ?? false,
      marketsThemeModeKey:
          json['marketsThemeModeKey'] as String? ?? 'dark',
      profileThemeModeKey:
          json['profileThemeModeKey'] as String? ?? 'light',
    );
  }
}

class HomeCustomization {
  const HomeCustomization({
    required this.compactHome,
    required this.sectionVisibility,
    required this.sectionOrder,
    required this.newsCount,
    required this.showSparklines,
  });

  final bool compactHome;
  final Map<String, bool> sectionVisibility;
  final List<String> sectionOrder;
  final int newsCount;
  final bool showSparklines;

  HomeCustomization copyWith({
    bool? compactHome,
    Map<String, bool>? sectionVisibility,
    List<String>? sectionOrder,
    int? newsCount,
    bool? showSparklines,
  }) {
    return HomeCustomization(
      compactHome: compactHome ?? this.compactHome,
      sectionVisibility: sectionVisibility ?? this.sectionVisibility,
      sectionOrder: sectionOrder ?? this.sectionOrder,
      newsCount: newsCount ?? this.newsCount,
      showSparklines: showSparklines ?? this.showSparklines,
    );
  }

  Map<String, dynamic> toJson() => {
        'compactHome': compactHome,
        'sectionVisibility': sectionVisibility,
        'sectionOrder': sectionOrder,
        'newsCount': newsCount,
        'showSparklines': showSparklines,
      };

  factory HomeCustomization.fromJson(Map<String, dynamic> json) {
    return HomeCustomization(
      compactHome: json['compactHome'] as bool? ?? false,
      sectionVisibility: (json['sectionVisibility'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v == true)) ??
          {},
      sectionOrder: (json['sectionOrder'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      newsCount: json['newsCount'] as int? ?? 5,
      showSparklines: json['showSparklines'] as bool? ?? true,
    );
  }
}

class NavigationCustomization {
  const NavigationCustomization({
    required this.defaultTabIndex,
    required this.visibleTabIndices,
    required this.tabOrder,
    required this.showAssistantFab,
    required this.hideNavLabels,
  });

  final int defaultTabIndex;
  final List<int> visibleTabIndices;
  final List<int> tabOrder;
  final bool showAssistantFab;
  final bool hideNavLabels;

  NavigationCustomization copyWith({
    int? defaultTabIndex,
    List<int>? visibleTabIndices,
    List<int>? tabOrder,
    bool? showAssistantFab,
    bool? hideNavLabels,
  }) {
    return NavigationCustomization(
      defaultTabIndex: defaultTabIndex ?? this.defaultTabIndex,
      visibleTabIndices: visibleTabIndices ?? this.visibleTabIndices,
      tabOrder: tabOrder ?? this.tabOrder,
      showAssistantFab: showAssistantFab ?? this.showAssistantFab,
      hideNavLabels: hideNavLabels ?? this.hideNavLabels,
    );
  }

  Map<String, dynamic> toJson() => {
        'defaultTabIndex': defaultTabIndex,
        'visibleTabIndices': visibleTabIndices,
        'tabOrder': tabOrder,
        'showAssistantFab': showAssistantFab,
        'hideNavLabels': hideNavLabels,
      };

  factory NavigationCustomization.fromJson(Map<String, dynamic> json) {
    const defaultTabs = [0, 1, 2, 3, 4, 5];
    return _migrateLegacyTabIndices(
      NavigationCustomization(
        defaultTabIndex: json['defaultTabIndex'] as int? ?? 0,
        visibleTabIndices: (json['visibleTabIndices'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            defaultTabs,
        tabOrder: (json['tabOrder'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            defaultTabs,
        showAssistantFab: json['showAssistantFab'] as bool? ?? true,
        hideNavLabels: json['hideNavLabels'] as bool? ?? false,
      ),
    );
  }

  /// Старые индексы 5 (чаты) и 6 (статьи) → 5 (сообщество).
  static NavigationCustomization _migrateLegacyTabIndices(
    NavigationCustomization navigation,
  ) {
    const validTabs = [0, 1, 2, 3, 4, 5];
    int mapIndex(int index) => index == 6 ? 5 : index;

    List<int> dedupeOrdered(Iterable<int> raw) {
      final seen = <int>{};
      final result = <int>[];
      for (final item in raw) {
        final mapped = mapIndex(item);
        if (validTabs.contains(mapped) && seen.add(mapped)) {
          result.add(mapped);
        }
      }
      return result;
    }

    final visible = dedupeOrdered(navigation.visibleTabIndices)..sort();
    final order = dedupeOrdered(
      navigation.tabOrder.isEmpty ? validTabs : navigation.tabOrder,
    );
    for (final index in validTabs) {
      if (!order.contains(index)) order.add(index);
    }

    var defaultTab = mapIndex(navigation.defaultTabIndex);
    if (!visible.contains(defaultTab)) {
      defaultTab = visible.isEmpty ? 0 : visible.first;
    }

    return navigation.copyWith(
      defaultTabIndex: defaultTab,
      visibleTabIndices: visible.isEmpty ? [0] : visible,
      tabOrder: order,
    );
  }
}

class MarketsCustomization {
  const MarketsCustomization({
    required this.groupStocksBySector,
    required this.showSectorHeatmap,
    required this.defaultStockRegion,
    required this.listRowCompact,
  });

  final bool groupStocksBySector;
  final bool showSectorHeatmap;
  final String defaultStockRegion;
  final bool listRowCompact;

  MarketsCustomization copyWith({
    bool? groupStocksBySector,
    bool? showSectorHeatmap,
    String? defaultStockRegion,
    bool? listRowCompact,
  }) {
    return MarketsCustomization(
      groupStocksBySector: groupStocksBySector ?? this.groupStocksBySector,
      showSectorHeatmap: showSectorHeatmap ?? this.showSectorHeatmap,
      defaultStockRegion: defaultStockRegion ?? this.defaultStockRegion,
      listRowCompact: listRowCompact ?? this.listRowCompact,
    );
  }

  Map<String, dynamic> toJson() => {
        'groupStocksBySector': groupStocksBySector,
        'showSectorHeatmap': showSectorHeatmap,
        'defaultStockRegion': defaultStockRegion,
        'listRowCompact': listRowCompact,
      };

  factory MarketsCustomization.fromJson(Map<String, dynamic> json) {
    return MarketsCustomization(
      groupStocksBySector: json['groupStocksBySector'] as bool? ?? false,
      showSectorHeatmap: json['showSectorHeatmap'] as bool? ?? true,
      defaultStockRegion: json['defaultStockRegion'] as String? ?? 'RU',
      listRowCompact: json['listRowCompact'] as bool? ?? false,
    );
  }
}

class PortfolioCustomization {
  const PortfolioCustomization({
    required this.allocationChartType,
    required this.showRealizedPnl,
    required this.showJournal,
  });

  final AllocationChartType allocationChartType;
  final bool showRealizedPnl;
  final bool showJournal;

  PortfolioCustomization copyWith({
    AllocationChartType? allocationChartType,
    bool? showRealizedPnl,
    bool? showJournal,
  }) {
    return PortfolioCustomization(
      allocationChartType: allocationChartType ?? this.allocationChartType,
      showRealizedPnl: showRealizedPnl ?? this.showRealizedPnl,
      showJournal: showJournal ?? this.showJournal,
    );
  }

  Map<String, dynamic> toJson() => {
        'allocationChartType': allocationChartType.name,
        'showRealizedPnl': showRealizedPnl,
        'showJournal': showJournal,
      };

  factory PortfolioCustomization.fromJson(Map<String, dynamic> json) {
    return PortfolioCustomization(
      allocationChartType: _enumByName(
        AllocationChartType.values,
        json['allocationChartType'] as String?,
        AllocationChartType.pie,
      ),
      showRealizedPnl: json['showRealizedPnl'] as bool? ?? true,
      showJournal: json['showJournal'] as bool? ?? true,
    );
  }
}

class WidgetCustomization {
  const WidgetCustomization({
    required this.layout,
    required this.slots,
  });

  final String layout;
  final List<String> slots;

  WidgetCustomization copyWith({
    String? layout,
    List<String>? slots,
  }) {
    return WidgetCustomization(
      layout: layout ?? this.layout,
      slots: slots ?? this.slots,
    );
  }

  Map<String, dynamic> toJson() => {
        'layout': layout,
        'slots': slots,
      };

  factory WidgetCustomization.fromJson(Map<String, dynamic> json) {
    return WidgetCustomization(
      layout: json['layout'] as String? ?? 'auto',
      slots: (json['slots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['usdRub', 'btc', 'keyRate', 'imoex'],
    );
  }
}

class DataDisplayCustomization {
  const DataDisplayCustomization({
    required this.baseCurrency,
    required this.localeCode,
    required this.decimalPlaces,
    required this.largeNumberFormat,
    required this.showCurrencyCode,
    required this.use24HourTime,
  });

  final String baseCurrency;
  final String localeCode;
  final DecimalPlacesMode decimalPlaces;
  final LargeNumberFormatId largeNumberFormat;
  final bool showCurrencyCode;
  final bool use24HourTime;

  DataDisplayCustomization copyWith({
    String? baseCurrency,
    String? localeCode,
    DecimalPlacesMode? decimalPlaces,
    LargeNumberFormatId? largeNumberFormat,
    bool? showCurrencyCode,
    bool? use24HourTime,
  }) {
    return DataDisplayCustomization(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      localeCode: localeCode ?? this.localeCode,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      largeNumberFormat: largeNumberFormat ?? this.largeNumberFormat,
      showCurrencyCode: showCurrencyCode ?? this.showCurrencyCode,
      use24HourTime: use24HourTime ?? this.use24HourTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'baseCurrency': baseCurrency,
        'localeCode': localeCode,
        'decimalPlaces': decimalPlaces.name,
        'largeNumberFormat': largeNumberFormat.name,
        'showCurrencyCode': showCurrencyCode,
        'use24HourTime': use24HourTime,
      };

  factory DataDisplayCustomization.fromJson(Map<String, dynamic> json) {
    return DataDisplayCustomization(
      baseCurrency: json['baseCurrency'] as String? ?? 'usd',
      localeCode: json['localeCode'] as String? ?? 'ru',
      decimalPlaces: _enumByName(
        DecimalPlacesMode.values,
        json['decimalPlaces'] as String?,
        DecimalPlacesMode.auto,
      ),
      largeNumberFormat: _enumByName(
        LargeNumberFormatId.values,
        json['largeNumberFormat'] as String?,
        LargeNumberFormatId.localized,
      ),
      showCurrencyCode: json['showCurrencyCode'] as bool? ?? false,
      use24HourTime: json['use24HourTime'] as bool? ?? true,
    );
  }
}

class AssistantCustomization {
  const AssistantCustomization({
    required this.preferCloud,
    required this.showQuickChips,
    required this.voiceInputEnabled,
  });

  final bool preferCloud;
  final bool showQuickChips;
  final bool voiceInputEnabled;

  AssistantCustomization copyWith({
    bool? preferCloud,
    bool? showQuickChips,
    bool? voiceInputEnabled,
  }) {
    return AssistantCustomization(
      preferCloud: preferCloud ?? this.preferCloud,
      showQuickChips: showQuickChips ?? this.showQuickChips,
      voiceInputEnabled: voiceInputEnabled ?? this.voiceInputEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'preferCloud': preferCloud,
        'showQuickChips': showQuickChips,
        'voiceInputEnabled': voiceInputEnabled,
      };

  factory AssistantCustomization.fromJson(Map<String, dynamic> json) {
    return AssistantCustomization(
      preferCloud: json['preferCloud'] as bool? ?? false,
      showQuickChips: json['showQuickChips'] as bool? ?? true,
      voiceInputEnabled: json['voiceInputEnabled'] as bool? ?? true,
    );
  }
}

T _enumByName<T extends Enum>(
  List<T> values,
  String? raw,
  T fallback,
) {
  if (raw == null) return fallback;
  for (final v in values) {
    if (v.name == raw) return v;
  }
  return fallback;
}

T? _enumByNameNullable<T extends Enum>(
  List<T> values,
  String? raw,
) {
  if (raw == null) return null;
  for (final v in values) {
    if (v.name == raw) return v;
  }
  return null;
}
