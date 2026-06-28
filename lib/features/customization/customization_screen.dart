import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/customization/chart_registry.dart';
import '../../core/customization/chart_series_palette.dart';
import '../../core/customization/customization_sync.dart';
import '../../core/theme/app_accent.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/chart_period.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/base_currency_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/home_layout_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/widget_config_provider.dart';
import 'customization_preview.dart';

class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({super.key});

  static const _tabIndices = [0, 1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final config = ref.watch(customizationProvider);
    final isRu = ref.watch(localeProvider) == AppLocale.ru;

    Future<void> commit(UserCustomization next) =>
        ref.read(customizationProvider.notifier).commitWithLegacy(ref, next);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customizationTitle),
        actions: [
          TextButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.customizationResetAll),
                  content: Text(l10n.customizationResetAllConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.customizationResetAll),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await CustomizationSync.resetAll(ref);
              }
            },
            child: Text(l10n.customizationResetAll),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.customizationSubtitle,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
          ),
          const Gap(16),
          CustomizationPreview(config: config, palette: palette),
          const Gap(16),
          _SectionCard(
            title: l10n.customizationSectionCharts,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.charts,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _ChartsSection(
              charts: config.charts,
              l10n: l10n,
              palette: palette,
              isRu: isRu,
              onChanged: (charts) => commit(config.copyWith(charts: charts)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionAppearance,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.appearance,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _AppearanceSection(
              appearance: config.appearance,
              l10n: l10n,
              palette: palette,
              isRu: isRu,
              onChanged: (appearance) =>
                  commit(config.copyWith(appearance: appearance)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionHome,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.home,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _HomeSection(
              home: config.home,
              l10n: l10n,
              palette: palette,
              onChanged: (home) => commit(config.copyWith(home: home)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionNavigation,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.navigation,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _NavigationSection(
              navigation: config.navigation,
              l10n: l10n,
              palette: palette,
              onChanged: (navigation) =>
                  commit(config.copyWith(navigation: navigation)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionMarkets,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.markets,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _MarketsSection(
              markets: config.markets,
              l10n: l10n,
              palette: palette,
              onChanged: (markets) => commit(config.copyWith(markets: markets)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionPortfolio,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.portfolio,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _PortfolioSection(
              portfolio: config.portfolio,
              l10n: l10n,
              palette: palette,
              onChanged: (portfolio) =>
                  commit(config.copyWith(portfolio: portfolio)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionWidgets,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.widgets,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _WidgetsSection(
              widgets: config.widgets,
              l10n: l10n,
              palette: palette,
              onChanged: (widgets) => commit(config.copyWith(widgets: widgets)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionDataDisplay,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.dataDisplay,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _DataDisplaySection(
              dataDisplay: config.dataDisplay,
              l10n: l10n,
              palette: palette,
              onChanged: (dataDisplay) =>
                  commit(config.copyWith(dataDisplay: dataDisplay)),
            ),
          ),
          _SectionCard(
            title: l10n.customizationSectionAssistant,
            palette: palette,
            onReset: () => CustomizationSync.resetSection(
              ref,
              CustomizationSection.assistant,
            ),
            resetLabel: l10n.customizationResetSection,
            child: _AssistantSection(
              assistant: config.assistant,
              l10n: l10n,
              palette: palette,
              onChanged: (assistant) =>
                  commit(config.copyWith(assistant: assistant)),
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.palette,
    required this.child,
    required this.onReset,
    required this.resetLabel,
  });

  final String title;
  final AppPalette palette;
  final Widget child;
  final VoidCallback onReset;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: child,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onReset,
                  child: Text(resetLabel),
                ),
              ),
              const Gap(4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({
    required this.charts,
    required this.l10n,
    required this.palette,
    required this.isRu,
    required this.onChanged,
  });

  final ChartCustomization charts;
  final AppLocalizations l10n;
  final AppPalette palette;
  final bool isRu;
  final ValueChanged<ChartCustomization> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(l10n.customizationChartDefaultType, palette),
        const Gap(8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: ChartTypeId.values.map((type) {
            final descriptor = ChartRegistry.describe(type);
            return FilterChip(
              selected: charts.defaultType == type,
              label: Text(
                descriptor.label(isRu: isRu),
                style: const TextStyle(fontSize: 12),
              ),
              onSelected: (_) => onChanged(charts.copyWith(defaultType: type)),
            );
          }).toList(),
        ),
        const Gap(12),
        _Label(l10n.customizationChartPeriod, palette),
        const Gap(8),
        Wrap(
          spacing: 6,
          children: ChartPeriod.values.map((period) {
            return FilterChip(
              selected: charts.defaultPeriodKey == period.name,
              label: Text(period.label),
              onSelected: (_) =>
                  onChanged(charts.copyWith(defaultPeriodKey: period.name)),
            );
          }).toList(),
        ),
        const Gap(12),
        _Label(l10n.customizationChartHeight, palette),
        const Gap(8),
        SegmentedButton<ChartHeightPreset>(
          segments: ChartHeightPreset.values
              .map((h) => ButtonSegment(value: h, label: Text(h.name)))
              .toList(),
          selected: {charts.defaultHeight},
          onSelectionChanged: (s) =>
              onChanged(charts.copyWith(defaultHeight: s.first)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartShowLegend),
          value: charts.showLegend,
          onChanged: (v) => onChanged(charts.copyWith(showLegend: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartPreferCandles),
          value: charts.preferCandlesWhenAvailable,
          onChanged: (v) =>
              onChanged(charts.copyWith(preferCandlesWhenAvailable: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartNormalizedCompare),
          value: charts.normalizedCompare,
          onChanged: (v) => onChanged(charts.copyWith(normalizedCompare: v)),
        ),
        const Gap(12),
        _Label(l10n.customizationChartVisualTitle, palette),
        const Gap(8),
        _Label(l10n.customizationChartSeriesPalette, palette),
        const Gap(6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: SeriesPalettePreset.values.map((preset) {
            return FilterChip(
              selected: charts.seriesPalette == preset,
              label: Text(ChartSeriesPalette.label(preset, isRu: isRu)),
              onSelected: (_) =>
                  onChanged(charts.copyWith(seriesPalette: preset)),
            );
          }).toList(),
        ),
        const Gap(10),
        _Label(l10n.customizationChartGridStyle, palette),
        const Gap(6),
        SegmentedButton<ChartGridStyle>(
          segments: ChartGridStyle.values
              .map((s) => ButtonSegment(value: s, label: Text(s.name)))
              .toList(),
          selected: {charts.visual.gridStyle},
          onSelectionChanged: (s) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(gridStyle: s.first)),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '${l10n.customizationChartLineWidth}: ${charts.visual.lineWidth.toStringAsFixed(1)}',
              ),
            ),
          ],
        ),
        Slider(
          value: charts.visual.lineWidth.clamp(1, 5),
          min: 1,
          max: 5,
          divisions: 8,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(lineWidth: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartShowGrid),
          value: charts.visual.showGrid,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(showGrid: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartShowGradientFill),
          value: charts.visual.showGradientFill,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(showGradientFill: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartShowCrosshair),
          value: charts.visual.showCrosshair,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(showCrosshair: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartShowEventMarkers),
          value: charts.visual.showEventMarkers,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(showEventMarkers: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartShowPointMarkers),
          value: charts.visual.showPointMarkers,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(showPointMarkers: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationChartAnimateOnLoad),
          value: charts.visual.animateOnLoad,
          onChanged: (v) => onChanged(
            charts.copyWith(visual: charts.visual.copyWith(animateOnLoad: v)),
          ),
        ),
      ],
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({
    required this.appearance,
    required this.l10n,
    required this.palette,
    required this.isRu,
    required this.onChanged,
  });

  final AppearanceCustomization appearance;
  final AppLocalizations l10n;
  final AppPalette palette;
  final bool isRu;
  final ValueChanged<AppearanceCustomization> onChanged;

  String _themeLabel(AppThemeMode mode) => switch (mode) {
        AppThemeMode.dark => l10n.settingsThemeDark,
        AppThemeMode.light => l10n.settingsThemeLight,
        AppThemeMode.system => l10n.settingsThemeAuto,
        AppThemeMode.oled => l10n.settingsThemeOled,
        AppThemeMode.dim => l10n.settingsThemeDim,
        AppThemeMode.sepia => l10n.settingsThemeSepia,
        AppThemeMode.contrast => l10n.settingsThemeContrast,
      };

  @override
  Widget build(BuildContext context) {
    final themeMode = AppThemeModeX.fromString(appearance.themeModeKey);
    final accent = AppAccentColor.fromKey(appearance.accentKey);
    final background =
        AppBackgroundPresetX.fromString(appearance.backgroundKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: AppThemeMode.values.map((mode) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: themeMode == mode,
                  label: Text(_themeLabel(mode)),
                  onSelected: (_) => onChanged(
                    appearance.copyWith(themeModeKey: mode.storageKey),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Gap(12),
        Wrap(
          spacing: 10,
          children: AppAccentColor.values.map((a) {
            final color = Theme.of(context).brightness == Brightness.dark
                ? a.darkAccent
                : a.lightAccent;
            final selected = accent == a;
            return GestureDetector(
              onTap: () => onChanged(appearance.copyWith(accentKey: a.key)),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? palette.textPrimary : palette.border,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
        const Gap(12),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: AppBackgroundPreset.values.map((preset) {
              final selected = background == preset;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: selected,
                  label: Text(
                    isRu ? preset.label : preset.labelEn,
                    style: const TextStyle(fontSize: 11),
                  ),
                  onSelected: (_) => onChanged(
                    appearance.copyWith(backgroundKey: preset.name),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Gap(8),
        _Label(
          '${l10n.customizationFontScale}: ${appearance.fontScale.toStringAsFixed(2)}',
          palette,
        ),
        Slider(
          value: appearance.fontScale.clamp(0.85, 1.25),
          min: 0.85,
          max: 1.25,
          divisions: 8,
          onChanged: (v) => onChanged(appearance.copyWith(fontScale: v)),
        ),
        _Label(l10n.customizationUiDensity, palette),
        SegmentedButton<UiDensity>(
          segments: UiDensity.values
              .map((d) => ButtonSegment(value: d, label: Text(d.name)))
              .toList(),
          selected: {appearance.uiDensity},
          onSelectionChanged: (s) =>
              onChanged(appearance.copyWith(uiDensity: s.first)),
        ),
        const Gap(8),
        _Label(l10n.customizationCardStyle, palette),
        SegmentedButton<CardStyleId>(
          segments: CardStyleId.values
              .map((s) => ButtonSegment(value: s, label: Text(s.name)))
              .toList(),
          selected: {appearance.cardStyle},
          onSelectionChanged: (s) =>
              onChanged(appearance.copyWith(cardStyle: s.first)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationMotionReduced),
          value: appearance.motionReduced,
          onChanged: (v) => onChanged(appearance.copyWith(motionReduced: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationAmoledPureBlack),
          value: appearance.amoledPureBlack,
          onChanged: (v) => onChanged(appearance.copyWith(amoledPureBlack: v)),
        ),
      ],
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection({
    required this.home,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final HomeCustomization home;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<HomeCustomization> onChanged;

  String _sectionLabel(HomeSectionId id) => switch (id) {
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

  List<String> get _order =>
      home.sectionOrder.isNotEmpty
          ? List<String>.from(home.sectionOrder)
          : HomeSectionId.values.map((e) => e.name).toList();

  HomeSectionId? _idFromName(String name) {
    for (final id in HomeSectionId.values) {
      if (id.name == name) return id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;

    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsCompactHome),
          value: home.compactHome,
          onChanged: (v) => onChanged(home.copyWith(compactHome: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationHomeSparklines),
          value: home.showSparklines,
          onChanged: (v) => onChanged(home.copyWith(showSparklines: v)),
        ),
        Row(
          children: [
            Text(l10n.customizationHomeNewsCount),
            Expanded(
              child: Slider(
                value: home.newsCount.toDouble().clamp(3, 10),
                min: 3,
                max: 10,
                divisions: 7,
                label: home.newsCount.toString(),
                onChanged: (v) =>
                    onChanged(home.copyWith(newsCount: v.round())),
              ),
            ),
          ],
        ),
        Text(
          l10n.homeLayoutReorderHint,
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
        const Gap(4),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final next = List<String>.from(order);
            final item = next.removeAt(oldIndex);
            next.insert(newIndex, item);
            onChanged(home.copyWith(sectionOrder: next));
          },
          children: [
            for (var i = 0; i < order.length; i++)
              Builder(
                key: ValueKey(order[i]),
                builder: (context) {
                  final id = _idFromName(order[i]);
                  if (id == null) return const SizedBox.shrink();
                  final visible =
                      home.sectionVisibility[id.name] ?? id.defaultVisible;
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(Iconsax.menu, size: 18, color: palette.textSecondary),
                    title: Text(_sectionLabel(id), style: const TextStyle(fontSize: 14)),
                    value: visible,
                    onChanged: (v) {
                      final vis = Map<String, bool>.from(home.sectionVisibility);
                      vis[id.name] = v;
                      onChanged(home.copyWith(sectionVisibility: vis));
                    },
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _NavigationSection extends StatelessWidget {
  const _NavigationSection({
    required this.navigation,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final NavigationCustomization navigation;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<NavigationCustomization> onChanged;

  String _tabLabel(int index) => switch (index) {
        0 => l10n.tabHome,
        1 => l10n.tabCurrency,
        2 => l10n.tabInflation,
        3 => l10n.tabMarkets,
        4 => l10n.tabSettings,
        5 => l10n.tabMessages,
        _ => '$index',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(l10n.customizationNavDefaultTab, palette),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: CustomizationScreen._tabIndices.map((i) {
            return FilterChip(
              selected: navigation.defaultTabIndex == i,
              label: Text(_tabLabel(i)),
              onSelected: (_) =>
                  onChanged(navigation.copyWith(defaultTabIndex: i)),
            );
          }).toList(),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationNavShowFab),
          value: navigation.showAssistantFab,
          onChanged: (v) =>
              onChanged(navigation.copyWith(showAssistantFab: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationNavHideLabels),
          value: navigation.hideNavLabels,
          onChanged: (v) => onChanged(navigation.copyWith(hideNavLabels: v)),
        ),
        _Label(l10n.customizationNavVisibleTabs, palette),
        ...CustomizationScreen._tabIndices.map((i) {
          final visible = navigation.visibleTabIndices.contains(i);
          return SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_tabLabel(i)),
            value: visible,
            onChanged: (v) {
              final next = List<int>.from(navigation.visibleTabIndices);
              if (v) {
                if (!next.contains(i)) next.add(i);
              } else {
                next.remove(i);
              }
              next.sort();
              onChanged(navigation.copyWith(visibleTabIndices: next));
            },
          );
        }),
      ],
    );
  }
}

class _MarketsSection extends StatelessWidget {
  const _MarketsSection({
    required this.markets,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final MarketsCustomization markets;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<MarketsCustomization> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationMarketsGroupStocks),
          value: markets.groupStocksBySector,
          onChanged: (v) =>
              onChanged(markets.copyWith(groupStocksBySector: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationMarketsHeatmap),
          value: markets.showSectorHeatmap,
          onChanged: (v) => onChanged(markets.copyWith(showSectorHeatmap: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationMarketsCompactRows),
          value: markets.listRowCompact,
          onChanged: (v) => onChanged(markets.copyWith(listRowCompact: v)),
        ),
      ],
    );
  }
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection({
    required this.portfolio,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final PortfolioCustomization portfolio;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<PortfolioCustomization> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(l10n.customizationPortfolioAllocation, palette),
        SegmentedButton<AllocationChartType>(
          segments: AllocationChartType.values
              .map((t) => ButtonSegment(value: t, label: Text(t.name)))
              .toList(),
          selected: {portfolio.allocationChartType},
          onSelectionChanged: (s) =>
              onChanged(portfolio.copyWith(allocationChartType: s.first)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationPortfolioRealizedPnl),
          value: portfolio.showRealizedPnl,
          onChanged: (v) => onChanged(portfolio.copyWith(showRealizedPnl: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationPortfolioJournal),
          value: portfolio.showJournal,
          onChanged: (v) => onChanged(portfolio.copyWith(showJournal: v)),
        ),
      ],
    );
  }
}

class _WidgetsSection extends StatelessWidget {
  const _WidgetsSection({
    required this.widgets,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final WidgetCustomization widgets;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<WidgetCustomization> onChanged;

  String _metricLabel(WidgetMetric metric) => switch (metric) {
        WidgetMetric.usdRub => l10n.widgetMetricUsdRub,
        WidgetMetric.eurRub => l10n.widgetMetricEurRub,
        WidgetMetric.btc => l10n.widgetMetricBtc,
        WidgetMetric.eth => l10n.widgetMetricEth,
        WidgetMetric.keyRate => l10n.widgetMetricKeyRate,
        WidgetMetric.brent => l10n.widgetMetricBrent,
        WidgetMetric.wti => l10n.widgetMetricWti,
        WidgetMetric.imoex => l10n.widgetMetricImoex,
        WidgetMetric.portfolioPnl => l10n.widgetMetricPortfolio,
        WidgetMetric.inflationRu => l10n.widgetMetricInflationRu,
      };

  @override
  Widget build(BuildContext context) {
    final layout = WidgetLayout.fromStorage(widgets.layout);
    final slots = widgets.slots.length >= 4
        ? widgets.slots
        : ['usdRub', 'btc', 'keyRate', 'imoex'];

    void setSlot(int index, WidgetMetric metric) {
      final next = List<String>.from(slots);
      next[index] = metric.name;
      onChanged(widgets.copyWith(slots: next));
    }

    final slotLabels = [
      l10n.settingsWidgetSlot1,
      l10n.settingsWidgetSlot2,
      l10n.settingsWidgetSlot3,
      l10n.settingsWidgetSlot4,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<WidgetLayout>(
          segments: WidgetLayout.values
              .map((l) => ButtonSegment(value: l, label: Text(l.name)))
              .toList(),
          selected: {layout},
          onSelectionChanged: (s) =>
              onChanged(widgets.copyWith(layout: s.first.name)),
        ),
        const Gap(8),
        for (var i = 0; i < 4; i++)
          DropdownMenu<WidgetMetric>(
            initialSelection: WidgetMetric.fromStorage(
              slots[i],
              WidgetMetric.usdRub,
            ),
            label: Text(slotLabels[i]),
            dropdownMenuEntries: WidgetMetric.values
                .map(
                  (m) => DropdownMenuEntry(
                    value: m,
                    label: _metricLabel(m),
                  ),
                )
                .toList(),
            onSelected: (m) {
              if (m != null) setSlot(i, m);
            },
          ),
      ],
    );
  }
}

class _DataDisplaySection extends StatelessWidget {
  const _DataDisplaySection({
    required this.dataDisplay,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final DataDisplayCustomization dataDisplay;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<DataDisplayCustomization> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(l10n.settingsBaseCurrency, palette),
        SegmentedButton<BaseCurrency>(
          segments: BaseCurrency.values
              .map((c) => ButtonSegment(value: c, label: Text(c.label)))
              .toList(),
          selected: {BaseCurrencyX.fromString(dataDisplay.baseCurrency)},
          onSelectionChanged: (s) =>
              onChanged(dataDisplay.copyWith(baseCurrency: s.first.name)),
        ),
        const Gap(8),
        _Label(l10n.settingsLanguage, palette),
        SegmentedButton<AppLocale>(
          segments: AppLocale.values
              .map((l) => ButtonSegment(value: l, label: Text(l.label)))
              .toList(),
          selected: {AppLocale.fromCode(dataDisplay.localeCode)},
          onSelectionChanged: (s) =>
              onChanged(dataDisplay.copyWith(localeCode: s.first.code)),
        ),
        const Gap(8),
        _Label(l10n.customizationDataDecimalPlaces, palette),
        SegmentedButton<DecimalPlacesMode>(
          segments: DecimalPlacesMode.values
              .map((m) => ButtonSegment(value: m, label: Text(m.name)))
              .toList(),
          selected: {dataDisplay.decimalPlaces},
          onSelectionChanged: (s) =>
              onChanged(dataDisplay.copyWith(decimalPlaces: s.first)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationDataShowCurrencyCode),
          value: dataDisplay.showCurrencyCode,
          onChanged: (v) => onChanged(dataDisplay.copyWith(showCurrencyCode: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationData24HourTime),
          value: dataDisplay.use24HourTime,
          onChanged: (v) => onChanged(dataDisplay.copyWith(use24HourTime: v)),
        ),
      ],
    );
  }
}

class _AssistantSection extends StatelessWidget {
  const _AssistantSection({
    required this.assistant,
    required this.l10n,
    required this.palette,
    required this.onChanged,
  });

  final AssistantCustomization assistant;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<AssistantCustomization> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationAssistantPreferCloud),
          value: assistant.preferCloud,
          onChanged: (v) => onChanged(assistant.copyWith(preferCloud: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationAssistantQuickChips),
          value: assistant.showQuickChips,
          onChanged: (v) => onChanged(assistant.copyWith(showQuickChips: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.customizationAssistantVoice),
          value: assistant.voiceInputEnabled,
          onChanged: (v) => onChanged(assistant.copyWith(voiceInputEnabled: v)),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, this.palette);

  final String text;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: palette.textPrimary,
      ),
    );
  }
}
