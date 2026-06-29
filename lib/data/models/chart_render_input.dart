import 'package:flutter/widgets.dart';

import '../../core/utils/chart_events.dart';
import '../../data/models/candle_point.dart';
import 'package:ecopulse/shared/widgets/charts.dart';
import 'price_point.dart';

/// Данные для отрисовки графика через [CustomChartView].
class ChartRenderInput {
  const ChartRenderInput({
    this.points,
    this.candles,
    this.series,
    this.barLabels,
    this.barValues,
    this.pieLabels,
    this.pieValues,
    this.currencySymbol = '\$',
    this.valueSuffix = '',
    this.eventMarkers = const [],
    this.customBuilder,
    this.onLoadMoreCandles,
  });

  final List<PricePoint>? points;
  final List<CandlePoint>? candles;
  final List<ChartLineSeries>? series;
  final List<String>? barLabels;
  final List<double>? barValues;
  final List<String>? pieLabels;
  final List<double>? pieValues;
  final String currencySymbol;
  final String valueSuffix;
  final List<ChartEventMarker> eventMarkers;
  final Widget Function(BuildContext context, double height)? customBuilder;
  final Future<void> Function()? onLoadMoreCandles;

  bool get hasPoints => points != null && points!.length >= 2;
  bool get hasCandles => candles != null && candles!.length >= 2;
  bool get hasMultiSeries => series != null && series!.length >= 2;
  bool get hasBarData =>
      barLabels != null &&
      barValues != null &&
      barLabels!.length >= 2 &&
      barValues!.length >= 2 &&
      barLabels!.length == barValues!.length;

  bool get hasPieData =>
      pieLabels != null &&
      pieValues != null &&
      pieLabels!.length >= 2 &&
      pieValues!.length >= 2 &&
      pieLabels!.length == pieValues!.length;

  bool get hasCustom => customBuilder != null;

  ChartRenderInput copyWith({
    List<PricePoint>? points,
    List<CandlePoint>? candles,
    List<ChartLineSeries>? series,
    List<String>? barLabels,
    List<double>? barValues,
    List<String>? pieLabels,
    List<double>? pieValues,
    String? currencySymbol,
    String? valueSuffix,
    List<ChartEventMarker>? eventMarkers,
    Widget Function(BuildContext context, double height)? customBuilder,
    Future<void> Function()? onLoadMoreCandles,
  }) {
    return ChartRenderInput(
      points: points ?? this.points,
      candles: candles ?? this.candles,
      series: series ?? this.series,
      barLabels: barLabels ?? this.barLabels,
      barValues: barValues ?? this.barValues,
      pieLabels: pieLabels ?? this.pieLabels,
      pieValues: pieValues ?? this.pieValues,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      valueSuffix: valueSuffix ?? this.valueSuffix,
      eventMarkers: eventMarkers ?? this.eventMarkers,
      customBuilder: customBuilder ?? this.customBuilder,
      onLoadMoreCandles: onLoadMoreCandles ?? this.onLoadMoreCandles,
    );
  }
}
