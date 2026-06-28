import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/chart_customization_resolver.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/user_customization.dart';
import '../../providers/customization_provider.dart';
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
    final config = ChartCustomizationResolver.resolveForRender(
      config: ref.watch(customizationProvider),
      context: contextId,
      input: input,
      overrideType: overrideType,
    );
    final chartHeight = height ?? config.heightPx;
    final visual = config.visual;

    final chart = switch (config.type) {
      ChartTypeId.candlestick => CandlestickChartWidget(
          candles: input.candles!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
        ),
      ChartTypeId.normalizedOverlay => MultiLineChartWidget(
          series: input.series!,
          height: chartHeight,
          normalized: config.normalizedCompare,
          valueSuffix: input.valueSuffix,
        ),
      ChartTypeId.bar ||
      ChartTypeId.heatmap ||
      ChartTypeId.ladder =>
        BarChartWidget(
          labels: input.barLabels!,
          values: input.barValues!,
          height: chartHeight,
          showGrid: visual.showGrid,
        ),
      ChartTypeId.pie => PieChartWidget(
          labels: _pieLabels(input),
          values: _pieValues(input),
          height: chartHeight,
          showLegend: config.showLegend,
        ),
      ChartTypeId.donut => PieChartWidget(
          labels: _pieLabels(input),
          values: _pieValues(input),
          height: chartHeight,
          centerSpaceRadius: 36,
          showLegend: config.showLegend,
        ),
      ChartTypeId.yieldCurve => input.customBuilder?.call(context, chartHeight) ??
          const SizedBox.shrink(),
      ChartTypeId.stepLine => LineChartWidget(
          points: input.points!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          eventMarkers: input.eventMarkers,
          valueSuffix: input.valueSuffix,
          showGrid: visual.showGrid,
          showGradientFill: false,
          lineWidth: visual.lineWidth,
          isStepLine: true,
        ),
      ChartTypeId.area => LineChartWidget(
          points: input.points!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          eventMarkers: input.eventMarkers,
          valueSuffix: input.valueSuffix,
          showGrid: visual.showGrid,
          showGradientFill: visual.showGradientFill,
          lineWidth: visual.lineWidth,
        ),
      ChartTypeId.line => LineChartWidget(
          points: input.points!,
          currencySymbol: input.currencySymbol,
          height: chartHeight,
          eventMarkers: input.eventMarkers,
          valueSuffix: input.valueSuffix,
          showGrid: visual.showGrid,
          showGradientFill: false,
          lineWidth: visual.lineWidth,
        ),
    };

    if (!config.showLegend || config.type == ChartTypeId.pie || config.type == ChartTypeId.donut) {
      return chart;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        chart,
        if (input.series != null && input.series!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: input.series!.map((s) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: s.color ?? Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    s.label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
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
