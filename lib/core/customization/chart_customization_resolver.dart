import '../../data/models/chart_render_input.dart';
import '../../data/models/user_customization.dart';
import '../../core/theme/app_palette.dart';
import 'chart_registry.dart';
import 'chart_render_style.dart';
import 'chart_series_palette.dart';
import 'chart_visual_utils.dart';

/// Эффективные параметры графика для контекста экрана.
class ResolvedChartConfig {
  const ResolvedChartConfig({
    required this.type,
    required this.periodKey,
    required this.height,
    required this.visual,
    required this.showLegend,
    required this.normalizedCompare,
    required this.preferCandlesWhenAvailable,
  });

  final ChartTypeId type;
  final String periodKey;
  final ChartHeightPreset height;
  final ChartVisualOptions visual;
  final bool showLegend;
  final bool normalizedCompare;
  final bool preferCandlesWhenAvailable;

  double get heightPx => ChartCustomizationResolver.heightPx(height);
}

/// Резолвер настроек графиков из [UserCustomization].
class ChartCustomizationResolver {
  ChartCustomizationResolver._();

  static double heightPx(ChartHeightPreset preset) => switch (preset) {
        ChartHeightPreset.compact => 180,
        ChartHeightPreset.normal => 240,
        ChartHeightPreset.tall => 300,
      };

  static ResolvedChartConfig resolve(
    UserCustomization config,
    ChartContextId context,
  ) {
    final charts = config.charts;
    final profile = charts.profileFor(context);

    final type = profile.useGlobalDefaults
        ? charts.defaultType
        : (profile.type ?? charts.defaultType);

    final periodKey = profile.useGlobalDefaults
        ? charts.defaultPeriodKey
        : (profile.periodKey ?? charts.defaultPeriodKey);

    final visual = profile.useGlobalDefaults
        ? charts.visual
        : (profile.visual ?? charts.visual);

    return ResolvedChartConfig(
      type: type,
      periodKey: periodKey,
      height: charts.defaultHeight,
      visual: visual,
      showLegend: charts.showLegend,
      normalizedCompare: charts.normalizedCompare,
      preferCandlesWhenAvailable: charts.preferCandlesWhenAvailable,
    );
  }

  static ResolvedChartConfig resolveForRender({
    required UserCustomization config,
    required ChartContextId context,
    required ChartRenderInput input,
    ChartTypeId? overrideType,
  }) {
    final base = resolve(config, context);
    var type = overrideType ?? base.type;

    if (overrideType == null &&
        base.preferCandlesWhenAvailable &&
        input.hasCandles &&
        (type == ChartTypeId.line || type == ChartTypeId.area)) {
      type = ChartTypeId.candlestick;
    }

    type = ChartRegistry.resolveCompatible(
      preferred: type,
      context: context,
      input: input,
    );

    return ResolvedChartConfig(
      type: type,
      periodKey: base.periodKey,
      height: base.height,
      visual: base.visual,
      showLegend: base.showLegend,
      normalizedCompare: base.normalizedCompare,
      preferCandlesWhenAvailable: base.preferCandlesWhenAvailable,
    );
  }

  static ChartRenderStyle renderStyle({
    required UserCustomization config,
    required ChartVisualOptions visual,
    required AppPalette palette,
  }) {
    return ChartRenderStyle(
      visual: visual,
      seriesColors: ChartSeriesPalette.resolve(
        palette: palette,
        preset: config.charts.seriesPalette,
        customHex: config.charts.customSeriesColorsHex,
      ),
      animateOnLoad: ChartVisualUtils.effectiveAnimateOnLoad(
        visual: visual,
        motionReduced: config.appearance.motionReduced,
      ),
      seriesPalette: config.charts.seriesPalette,
    );
  }
}
