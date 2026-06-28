// =============================================================================
// EcoPulse · lib/features/shared/widgets/charts.dart
// Автор: Цымбал Е. В.
// Дата: 01.06.2026
// Общие виджеты и действия приложения. Файл: charts.
// =============================================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/utils/chart_normalize.dart';
import '../../../core/utils/chart_events.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/candle_point.dart';
import '../../../data/models/price_point.dart';

/// Класс [ChartLineSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class ChartLineSeries {
/// Создаёт [ChartLineSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const ChartLineSeries({
    required this.label,
    required this.points,
    this.color,
  });

/// Поле [label] класса [ChartLineSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final String label;
/// Поле [points] класса [ChartLineSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final List<PricePoint> points;
/// Поле [color] класса [ChartLineSeries].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final Color? color;
}

/// StatefulWidget [LineChartWidget] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class LineChartWidget extends StatefulWidget {
/// Создаёт [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const LineChartWidget({
    super.key,
    required this.points,
    this.currencySymbol = '\$',
    this.height = 240,
    this.eventMarkers = const [],
    this.valueSuffix = '',
    this.showGrid = true,
    this.showGradientFill = true,
    this.lineWidth = 3,
    this.isStepLine = false,
  });

/// Поле [points] класса [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final List<PricePoint> points;
/// Поле [currencySymbol] класса [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String currencySymbol;
/// Поле [height] класса [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final double height;
/// Поле [eventMarkers] класса [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final List<ChartEventMarker> eventMarkers;
/// Поле [valueSuffix] класса [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final String valueSuffix;
  final bool showGrid;
  final bool showGradientFill;
  final double lineWidth;
  final bool isStepLine;

/// Создаёт State для [LineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

/// Приватный класс [_LineChartWidgetState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class _LineChartWidgetState extends State<LineChartWidget> {
/// Поле [_touchedIndex] класса [_LineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  int? _touchedIndex;

/// Отрисовывает UI [_LineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final points = widget.points;

    if (points.length < 2) {
      final l10n = AppLocalizations.of(context);
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            l10n?.chartInsufficientData ?? 'Not enough data',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
    }

    final spots = points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();

    final isUp = points.last.value >= points.first.value;
    final color = isUp ? palette.positive : palette.negative;
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final dateFmt = DateFormat('dd MMM');
    final eventIndices = widget.eventMarkers.map((e) => e.index).toSet();

    return Container(
      height: widget.height,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: palette.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: widget.showGrid,
            drawVerticalLine: _touchedIndex != null,
            verticalInterval: 1,
            getDrawingVerticalLine: (_) => FlLine(
              color: palette.accent.withValues(alpha: 0.5),
              strokeWidth: 1.5,
              dashArray: [4, 4],
            ),
            horizontalInterval: _interval(minY, maxY),
            getDrawingHorizontalLine: (_) => FlLine(
              color: palette.chartGrid,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: _interval(minY, maxY),
                getTitlesWidget: (value, meta) => Text(
                  widget.valueSuffix.isNotEmpty && widget.currencySymbol.isEmpty
                      ? '${value.toStringAsFixed(value < 10 ? 1 : 0)}${widget.valueSuffix}'
                      : _formatAxis(value, widget.currencySymbol),
                  style: TextStyle(color: palette.textSecondary, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: minY * 0.995,
          maxY: maxY * 1.005,
          extraLinesData: ExtraLinesData(
            verticalLines: widget.eventMarkers
                .map(
                  (m) => VerticalLine(
                    x: m.index.toDouble(),
                    color: palette.accent.withValues(alpha: 0.35),
                    strokeWidth: 1.5,
                    dashArray: [6, 4],
                  ),
                )
                .toList(),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: !widget.isStepLine,
              isStepLineChart: widget.isStepLine,
              curveSmoothness: 0.35,
              color: color,
              barWidth: widget.lineWidth,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, bar) =>
                    spot.x == spots.first.x ||
                    spot.x == spots.last.x ||
                    spot.x == _touchedIndex?.toDouble() ||
                    eventIndices.contains(spot.x.toInt()),
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: palette.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: widget.showGradientFill,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.28),
                    palette.chartGradientEnd,
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchCallback: (event, response) {
              if (!event.isInterestedForInteractions ||
                  response?.lineBarSpots == null ||
                  response!.lineBarSpots!.isEmpty) {
                setState(() => _touchedIndex = null);
                return;
              }
              setState(() {
                _touchedIndex = response.lineBarSpots!.first.x.toInt();
              });
            },
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: palette.accent.withValues(alpha: 0.6),
                    strokeWidth: 1.5,
                    dashArray: [4, 4],
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                      radius: 5,
                      color: palette.accent,
                      strokeWidth: 2,
                      strokeColor: palette.surface,
                    ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => palette.surface,
              getTooltipItems: (touched) => touched.map((s) {
                final idx = s.x.toInt().clamp(0, points.length - 1);
                final date = dateFmt.format(points[idx].date);
                final valueText = widget.valueSuffix.isNotEmpty
                    ? '${s.y.toStringAsFixed(2)}${widget.valueSuffix}'
                    : '${widget.currencySymbol}${s.y.toStringAsFixed(2)}';
                return LineTooltipItem(
                  '$date\n$valueText',
                  TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.4,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

/// Приватный метод [_formatAxis] класса [_LineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  String _formatAxis(double value, String symbol) {
    if (value >= 1000) return '$symbol${(value / 1000).toStringAsFixed(1)}k';
    return value.toStringAsFixed(value < 10 ? 2 : 0);
  }

/// Приватный метод [_interval] класса [_LineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  double _interval(double min, double max) {
    final range = max - min;
    if (range == 0) return 1;
    return range / 4;
  }
}

/// StatefulWidget [MultiLineChartWidget] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class MultiLineChartWidget extends StatefulWidget {
/// Создаёт [MultiLineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  const MultiLineChartWidget({
    super.key,
    required this.series,
    this.height = 260,
    this.normalized = true,
    this.valueSuffix = '',
  });

/// Поле [series] класса [MultiLineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final List<ChartLineSeries> series;
/// Поле [height] класса [MultiLineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final double height;
/// Поле [normalized] класса [MultiLineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final bool normalized;
/// Поле [valueSuffix] класса [MultiLineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String valueSuffix;

/// Создаёт State для [MultiLineChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  State<MultiLineChartWidget> createState() => _MultiLineChartWidgetState();
}

/// Приватный класс [_MultiLineChartWidgetState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class _MultiLineChartWidgetState extends State<MultiLineChartWidget> {
/// Поле [_touchedIndex] класса [_MultiLineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  int? _touchedIndex;

/// Отрисовывает UI [_MultiLineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);

    if (widget.series.length < 2) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            l10n?.currencyCompareSelect ?? 'Select 2+ pairs',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
    }

    final rawPoints = widget.series.map((s) => s.points).toList();
    final aligned = alignPriceSeries(rawPoints);
    if (aligned.length < 2 || aligned.first.length < 2) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            l10n?.chartInsufficientData ?? 'Not enough data',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
    }

    final defaultColors = [
      palette.accent,
      palette.positive,
      const Color(0xFFA371F7),
    ];

    final normalizedSeries = <ChartLineSeries>[];
    for (var i = 0; i < widget.series.length; i++) {
      final points = widget.normalized
          ? normalizeSeriesToIndex(aligned[i])
          : aligned[i];
      normalizedSeries.add(
        ChartLineSeries(
          label: widget.series[i].label,
          points: points,
          color: widget.series[i].color ?? defaultColors[i % defaultColors.length],
        ),
      );
    }

    final allSpots = normalizedSeries
        .map(
          (s) => s.points
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.value))
              .toList(),
        )
        .toList();

    var minY = allSpots.first.first.y;
    var maxY = allSpots.first.first.y;
    for (final spots in allSpots) {
      for (final spot in spots) {
        if (spot.y < minY) minY = spot.y;
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    final referencePoints = normalizedSeries.first.points;
    final dateFmt = DateFormat('dd MMM');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
          decoration: BoxDecoration(
            color: palette.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: _touchedIndex != null,
                getDrawingVerticalLine: (_) => FlLine(
                  color: palette.accent.withValues(alpha: 0.5),
                  strokeWidth: 1.5,
                  dashArray: [4, 4],
                ),
                horizontalInterval: _multiInterval(minY, maxY),
                getDrawingHorizontalLine: (_) => FlLine(
                  color: palette.chartGrid,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: _multiInterval(minY, maxY),
                    getTitlesWidget: (value, meta) => Text(
                      widget.normalized
                          ? value.toStringAsFixed(0)
                          : '${value.toStringAsFixed(1)}${widget.valueSuffix}',
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minY: minY * 0.995,
              maxY: maxY * 1.005,
              lineBarsData: List.generate(normalizedSeries.length, (i) {
                final color = normalizedSeries[i].color!;
                return LineChartBarData(
                  spots: allSpots[i],
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: color,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                );
              }),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response?.lineBarSpots == null ||
                      response!.lineBarSpots!.isEmpty) {
                    setState(() => _touchedIndex = null);
                    return;
                  }
                  setState(() {
                    _touchedIndex = response.lineBarSpots!.first.x.toInt();
                  });
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => palette.surface,
                  getTooltipItems: (touched) {
                    if (_touchedIndex == null) return [];
                    final idx =
                        _touchedIndex!.clamp(0, referencePoints.length - 1);
                    final date = dateFmt.format(referencePoints[idx].date);
                    return normalizedSeries.map((s) {
                      final val = s.points[idx].value;
                      return LineTooltipItem(
                        '${s.label}\n$date · ${val.toStringAsFixed(2)}${widget.valueSuffix}',
                        TextStyle(
                          color: s.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          height: 1.35,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: normalizedSeries.map((s) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  s.label,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

/// Приватный метод [_multiInterval] класса [_MultiLineChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  double _multiInterval(double min, double max) {
    final range = max - min;
    if (range == 0) return 1;
    return range / 4;
  }
}

/// StatefulWidget [CandlestickChartWidget] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
class CandlestickChartWidget extends StatefulWidget {
/// Создаёт [CandlestickChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  const CandlestickChartWidget({
    super.key,
    required this.candles,
    this.currencySymbol = '₽',
    this.height = 280,
  });

/// Поле [candles] класса [CandlestickChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final List<CandlePoint> candles;
/// Поле [currencySymbol] класса [CandlestickChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final String currencySymbol;
/// Поле [height] класса [CandlestickChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final double height;

/// Создаёт State для [CandlestickChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  State<CandlestickChartWidget> createState() => _CandlestickChartWidgetState();
}

/// Приватный класс [_CandlestickChartWidgetState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class _CandlestickChartWidgetState extends State<CandlestickChartWidget> {
/// Поле [_touchedIndex] класса [_CandlestickChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  int? _touchedIndex;

/// Отрисовывает UI [_CandlestickChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final candles = widget.candles;

    if (candles.length < 2) {
      final l10n = AppLocalizations.of(context);
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            l10n?.chartInsufficientCandles ?? 'Not enough candle data',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
    }

    final minY = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final maxY = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final dateFmt = DateFormat('dd MMM');

    return Container(
      height: widget.height,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: palette.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown: (d) => _updateTouch(d.localPosition, constraints, candles.length),
            onPanUpdate: (d) =>
                _updateTouch(d.localPosition, constraints, candles.length),
            onTapUp: (_) => setState(() => _touchedIndex = null),
            onPanEnd: (_) => setState(() => _touchedIndex = null),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _CandlestickPainter(
                    candles: candles,
                    minY: minY * 0.995,
                    maxY: maxY * 1.005,
                    bullColor: palette.positive,
                    bearColor: palette.negative,
                    gridColor: palette.chartGrid,
                  ),
                ),
                if (_touchedIndex != null)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _CandleTooltip(
                      candle: candles[_touchedIndex!],
                      dateFmt: dateFmt,
                      currencySymbol: widget.currencySymbol,
                      palette: palette,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

/// Приватный метод [_updateTouch] класса [_CandlestickChartWidgetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  void _updateTouch(Offset pos, BoxConstraints constraints, int count) {
    final chartWidth = constraints.maxWidth;
    final index = ((pos.dx / chartWidth) * count).floor().clamp(0, count - 1);
    setState(() => _touchedIndex = index);
  }
}

/// Приватный класс [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
class _CandleTooltip extends StatelessWidget {
/// Создаёт [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  const _CandleTooltip({
    required this.candle,
    required this.dateFmt,
    required this.currencySymbol,
    required this.palette,
  });

/// Поле [candle] класса [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final CandlePoint candle;
/// Поле [dateFmt] класса [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final DateFormat dateFmt;
/// Поле [currencySymbol] класса [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String currencySymbol;
/// Поле [palette] класса [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_CandleTooltip].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        '${dateFmt.format(candle.date)}\n'
        'O ${candle.open.toStringAsFixed(2)}  H ${candle.high.toStringAsFixed(2)}\n'
        'L ${candle.low.toStringAsFixed(2)}  C ${candle.close.toStringAsFixed(2)} $currencySymbol',
        style: TextStyle(
          color: palette.textPrimary,
          fontSize: 11,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Приватный класс [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class _CandlestickPainter extends CustomPainter {
/// Создаёт [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  _CandlestickPainter({
    required this.candles,
    required this.minY,
    required this.maxY,
    required this.bullColor,
    required this.bearColor,
    required this.gridColor,
  });

/// Поле [candles] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final List<CandlePoint> candles;
/// Поле [minY] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final double minY;
/// Поле [maxY] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final double maxY;
/// Поле [bullColor] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final Color bullColor;
/// Поле [bearColor] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final Color bearColor;
/// Поле [gridColor] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final Color gridColor;

/// Метод [paint] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  void paint(Canvas canvas, Size size) {
    final range = maxY - minY;
    if (range <= 0) return;

    final leftPad = 48.0;
    final chartWidth = size.width - leftPad - 4;
    final chartHeight = size.height - 8;
    final candleWidth = chartWidth / candles.length * 0.6;
    final gap = chartWidth / candles.length;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = chartHeight * i / 4;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
    }

    double yOf(double v) => chartHeight - ((v - minY) / range) * chartHeight;

    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final cx = leftPad + gap * i + gap / 2;
      final color = c.isBullish ? bullColor : bearColor;

      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = 1.5;
      canvas.drawLine(
        Offset(cx, yOf(c.high)),
        Offset(cx, yOf(c.low)),
        wickPaint,
      );

      final bodyTop = yOf(c.isBullish ? c.close : c.open);
      final bodyBottom = yOf(c.isBullish ? c.open : c.close);
      final bodyHeight = (bodyBottom - bodyTop).abs().clamp(2.0, chartHeight);
      final rect = Rect.fromCenter(
        center: Offset(cx, (bodyTop + bodyBottom) / 2),
        width: candleWidth,
        height: bodyHeight,
      );
      canvas.drawRect(rect, Paint()..color = color.withValues(alpha: 0.85));
    }
  }

/// Метод [shouldRepaint] класса [_CandlestickPainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) => true;
}

/// StatelessWidget [BarChartWidget] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class BarChartWidget extends StatelessWidget {
/// Создаёт [BarChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  const BarChartWidget({
    super.key,
    required this.labels,
    required this.values,
    this.height = 280,
    this.showGrid = true,
  });

/// Поле [labels] класса [BarChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final List<String> labels;
/// Поле [values] класса [BarChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final List<double> values;
/// Поле [height] класса [BarChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final double height;
  final bool showGrid;

/// Отрисовывает UI [BarChartWidget].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    if (values.isEmpty) return const SizedBox.shrink();

    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(4, 16, 8, 8),
      decoration: BoxDecoration(
        color: palette.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal * 1.25,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => palette.surface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${labels[group.x.toInt()]}\n${rod.toY.toStringAsFixed(1)}%',
                  TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[idx],
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}%',
                  style: TextStyle(color: palette.textSecondary, fontSize: 10),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: showGrid,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: palette.chartGrid,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            final intensity = values[i] / maxVal;
            final barColor = Color.lerp(
              palette.accent.withValues(alpha: 0.5),
              palette.accent,
              intensity,
            )!;

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 20,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      barColor.withValues(alpha: 0.6),
                      barColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/// Универсальная pie/donut-диаграмма по меткам и значениям.
class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.labels,
    required this.values,
    this.height = 220,
    this.centerSpaceRadius = 0,
    this.showLegend = true,
  });

  final List<String> labels;
  final List<double> values;
  final double height;
  final double centerSpaceRadius;
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    if (labels.length < 2 || values.length < 2) {
      return const SizedBox.shrink();
    }

    final total = values.fold<double>(0, (sum, v) => sum + v);
    if (total <= 0) return const SizedBox.shrink();

    final colors = [
      palette.accent,
      palette.positive,
      const Color(0xFFA371F7),
      palette.negative,
      const Color(0xFFF0883E),
      const Color(0xFF2DD4BF),
    ];

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: centerSpaceRadius,
                sections: List.generate(values.length, (i) {
                  final pct = values[i] / total * 100;
                  return PieChartSectionData(
                    value: values[i],
                    color: colors[i % colors.length],
                    radius: (height * 0.32).clamp(48, 72),
                    title: pct >= 8 ? '${pct.toStringAsFixed(0)}%' : '',
                    titleStyle: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }),
              ),
            ),
          ),
          if (showLegend) ...[
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(labels.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
