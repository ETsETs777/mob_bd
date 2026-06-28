// =============================================================================
// EcoPulse · lib/features/markets/ofz_yield_curve_chart.dart
// Автор: Цымбал Е. В.
// Дата: 10.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: ofz_yield_curve_chart.
// =============================================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';

/// График кривой доходности ОФЗ (YTM × срок) с crosshair на ближайшей точке.
class OfzYieldCurveChart extends StatefulWidget {
/// Создаёт [OfzYieldCurveChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  const OfzYieldCurveChart({
    super.key,
    required this.bonds,
    this.height = 200,
    this.interactive = true,
    this.enableZoom = false,
  });

/// Поле [bonds] класса [OfzYieldCurveChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final List<MarketAsset> bonds;
/// Поле [height] класса [OfzYieldCurveChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final double height;
/// Поле [interactive] класса [OfzYieldCurveChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final bool interactive;
/// Поле [enableZoom] класса [OfzYieldCurveChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final bool enableZoom;

/// Создаёт State для [OfzYieldCurveChart].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  State<OfzYieldCurveChart> createState() => _OfzYieldCurveChartState();
}

/// Приватный класс [_OfzYieldCurveChartState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _OfzYieldCurveChartState extends State<OfzYieldCurveChart> {
/// Поле [_selectedIndex] класса [_OfzYieldCurveChartState].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  int? _selectedIndex;
/// Поле [_zoom] класса [_OfzYieldCurveChartState].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  double _zoom = 1.0;

/// Приватный метод [_adjustZoom] класса [_OfzYieldCurveChartState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  void _adjustZoom(double delta) {
    setState(() {
      _zoom = (_zoom + delta).clamp(1.0, 4.0);
      if (_zoom <= 1.01) _zoom = 1.0;
    });
  }

/// Отрисовывает UI [_OfzYieldCurveChartState].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final curve = buildOfzYieldCurve(widget.bonds);

    if (curve.length < 2) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            l10n.bondYieldCurveEmpty,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final spots = curve
        .map((p) => FlSpot(p.yearsToMaturity, p.yieldPercent))
        .toList();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final fullMaxX = spots.last.x * 1.05;
    final visibleRange = fullMaxX / _zoom;
    final minVisibleX =
        ((fullMaxX - visibleRange) / 2).clamp(0.0, fullMaxX - visibleRange);
    final chartMaxX = minVisibleX + visibleRange;
    final selected = _selectedIndex != null ? curve[_selectedIndex!] : null;

    final lineBar = LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.25,
      color: palette.accent,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, _, __, ___) {
          final idx = spots.indexWhere((s) => s.x == spot.x && s.y == spot.y);
          final isSelected = idx == _selectedIndex;
          return FlDotCirclePainter(
            radius: isSelected ? 6 : 4,
            color: palette.accent,
            strokeWidth: isSelected ? 3 : 2,
            strokeColor: palette.surface,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: palette.accent.withValues(alpha: 0.12),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.interactive && selected == null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.enableZoom && _zoom > 1
                  ? l10n.bondYieldCurveZoomActive(_zoom.toStringAsFixed(1))
                  : widget.enableZoom
                      ? l10n.bondYieldCurveZoomHint
                      : l10n.bondYieldCurveCrosshairHint,
              style: TextStyle(fontSize: 11, color: palette.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        if (selected != null)
          _CrosshairInfoCard(point: selected, palette: palette, l10n: l10n),
        if (selected != null) const SizedBox(height: 8),
        SizedBox(
          height: widget.height,
          child: _wrapZoom(
            GestureDetector(
              onDoubleTap: widget.enableZoom ? () => setState(() => _zoom = 1.0) : null,
              onScaleUpdate: widget.enableZoom
                  ? (details) {
                      if ((details.scale - 1).abs() > 0.02) {
                        _adjustZoom((details.scale - 1) * 0.8);
                      }
                    }
                  : null,
              child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: palette.chartGrid,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: palette.chartGrid,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              extraLinesData: ExtraLinesData(
                verticalLines: selected == null
                    ? []
                    : [
                        VerticalLine(
                          x: selected.yearsToMaturity,
                          color: palette.accent.withValues(alpha: 0.55),
                          strokeWidth: 1.5,
                          dashArray: [4, 4],
                        ),
                      ],
              ),
              titlesData: FlTitlesData(
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
                    getTitlesWidget: (v, _) => Text(
                      '${v.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: chartMaxX > 4 ? 2 : 1,
                    getTitlesWidget: (v, _) {
                      if (v < 0) return const SizedBox.shrink();
                      return Text(
                        '${v.toStringAsFixed(0)}${l10n.bondYearsShort}',
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: minVisibleX,
              maxX: chartMaxX,
              minY: minY * 0.98,
              maxY: maxY * 1.02,
              lineBarsData: [lineBar],
              showingTooltipIndicators: _selectedIndex != null
                  ? [
                      ShowingTooltipIndicators([
                        LineBarSpot(lineBar, 0, spots[_selectedIndex!]),
                      ]),
                    ]
                  : [],
              lineTouchData: LineTouchData(
                enabled: widget.interactive,
                handleBuiltInTouches: false,
                touchCallback: (event, response) {
                  if (!widget.interactive) return;
                  if (!event.isInterestedForInteractions) {
                    setState(() => _selectedIndex = null);
                    return;
                  }
                  final spots = response?.lineBarSpots;
                  if (spots == null || spots.isEmpty) return;

                  final idx = nearestBondYieldPointIndex(curve, spots.first.x);
                  if (_selectedIndex != idx) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedIndex = idx);
                  }
                },
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      const FlLine(color: Colors.transparent),
                      FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) =>
                            FlDotCirclePainter(
                          radius: 6,
                          color: palette.accent,
                          strokeWidth: 3,
                          strokeColor: palette.surface,
                        ),
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) =>
                      palette.surface.withValues(alpha: 0.92),
                  tooltipBorder: BorderSide(color: palette.border),
                  getTooltipItems: (touched) => touched.map((s) {
                    final idx = nearestBondYieldPointIndex(curve, s.x);
                    final pt = curve[idx];
                    return LineTooltipItem(
                      '${pt.bond.symbol}\n${Formatters.bondYield(pt.yieldPercent)}',
                      TextStyle(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            duration: AppMotion.duration(context, AppMotion.fast),
            curve: AppMotion.curve,
          ),
        ),
      ),
    ),
      ],
    );
  }

/// Приватный метод [_wrapZoom] класса [_OfzYieldCurveChartState].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  Widget _wrapZoom(Widget child) {
    if (!widget.enableZoom) return child;
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _adjustZoom(-event.scrollDelta.dy.sign * 0.25);
        }
      },
      child: child,
    );
  }
}

/// Приватный класс [_CrosshairInfoCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _CrosshairInfoCard extends StatelessWidget {
/// Создаёт [_CrosshairInfoCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  const _CrosshairInfoCard({
    required this.point,
    required this.palette,
    required this.l10n,
  });

/// Поле [point] класса [_CrosshairInfoCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final BondYieldPoint point;
/// Поле [palette] класса [_CrosshairInfoCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final AppPalette palette;
/// Поле [l10n] класса [_CrosshairInfoCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_CrosshairInfoCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: AppMotion.fast,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: palette.surfaceLight.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.accent.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.bond.symbol,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(
                    '${point.yearsToMaturity.toStringAsFixed(1)} ${l10n.bondYearsShort}',
                    style: TextStyle(
                      fontSize: 11,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              Formatters.bondYield(point.yieldPercent),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: palette.accent,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
