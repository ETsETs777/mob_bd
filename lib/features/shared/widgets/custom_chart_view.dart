import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/customization/chart_customization_resolver.dart';
import '../../../core/theme/app_palette.dart';
import '../../../data/models/chart_render_input.dart';
import '../../../data/models/user_customization.dart';
import '../../../providers/customization_provider.dart';
import 'charts.dart';

/// Единая точка отрисовки графиков по реестру и кастомизации.
class CustomChartView extends ConsumerWidget {
  const CustomChartView({
    super.key,
    required this.contextId,
    required this.input,
    this.overrideType,
    this.height,
  });

  final ChartContextId contextId;
  final ChartRenderInput input;
  final ChartTypeId? overrideType;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final customization = ref.watch(customizationProvider);
    final config = ChartCustomizationResolver.resolveForRender(
      config: customization,
      context: contextId,
      input: input,
      overrideType: overrideType,
    );
    final chartHeight = height ?? config.heightPx;
    final renderStyle = ChartCustomizationResolver.renderStyle(
      config: customization,
      visual: config.visual,
      palette: palette,
    );

    final chart = switch (config.type) {
      ChartTypeId.candlestick => CandlestickChartWidget(
          candles: input.candles!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          renderStyle: renderStyle,
        ),
      ChartTypeId.normalizedOverlay => MultiLineChartWidget(
          series: input.series!,
          height: chartHeight,
          normalized: config.normalizedCompare,
          valueSuffix: input.valueSuffix,
          renderStyle: renderStyle,
        ),
      ChartTypeId.bar ||
      ChartTypeId.heatmap ||
      ChartTypeId.ladder =>
        BarChartWidget(
          labels: input.barLabels!,
          values: input.barValues!,
          height: chartHeight,
          renderStyle: renderStyle,
        ),
      ChartTypeId.pie => PieChartWidget(
          labels: _pieLabels(input),
          values: _pieValues(input),
          height: chartHeight,
          showLegend: config.showLegend,
          seriesColors: renderStyle.seriesColors,
          animateOnLoad: renderStyle.animateOnLoad,
        ),
      ChartTypeId.donut => PieChartWidget(
          labels: _pieLabels(input),
          values: _pieValues(input),
          height: chartHeight,
          centerSpaceRadius: 36,
          showLegend: config.showLegend,
          seriesColors: renderStyle.seriesColors,
          animateOnLoad: renderStyle.animateOnLoad,
        ),
      ChartTypeId.yieldCurve => input.customBuilder?.call(context, chartHeight) ??
          const SizedBox.shrink(),
      ChartTypeId.stepLine => LineChartWidget(
          points: input.points!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          eventMarkers: input.eventMarkers,
          valueSuffix: input.valueSuffix,
          showGradientFill: false,
          isStepLine: true,
          renderStyle: renderStyle,
        ),
      ChartTypeId.area => LineChartWidget(
          points: input.points!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          eventMarkers: input.eventMarkers,
          valueSuffix: input.valueSuffix,
          showGradientFill: true,
          renderStyle: renderStyle,
        ),
      ChartTypeId.line => LineChartWidget(
          points: input.points!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          eventMarkers: input.eventMarkers,
          valueSuffix: input.valueSuffix,
          showGradientFill: false,
          renderStyle: renderStyle,
        ),
    };

    if (!config.showLegend ||
        config.type == ChartTypeId.pie ||
        config.type == ChartTypeId.donut ||
        input.series == null ||
        input.series!.isEmpty) {
      return chart;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        chart,
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: input.series!.asMap().entries.map((entry) {
            final color = entry.value.color ??
                renderStyle.seriesColorAt(entry.key);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.value.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  List<String> _pieLabels(ChartRenderInput input) {
    if (input.hasPieData) return input.pieLabels!;
    return input.barLabels!;
  }

  List<double> _pieValues(ChartRenderInput input) {
    if (input.hasPieData) return input.pieValues!;
    return input.barValues!;
  }
}
