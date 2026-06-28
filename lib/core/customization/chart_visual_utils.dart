import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/price_point.dart';
import '../../data/models/user_customization.dart';

/// Утилиты визуальных опций графиков (пункт 4).
class ChartVisualUtils {
  ChartVisualUtils._();

  static List<int>? gridDashArray(ChartGridStyle style) => switch (style) {
        ChartGridStyle.solid => null,
        ChartGridStyle.dotted => [4, 4],
        ChartGridStyle.none => null,
      };

  static bool effectiveShowGrid(ChartVisualOptions visual) =>
      visual.showGrid && visual.gridStyle != ChartGridStyle.none;

  static bool effectiveAnimateOnLoad({
    required ChartVisualOptions visual,
    required bool motionReduced,
  }) =>
      visual.animateOnLoad && !motionReduced;

  static Color? parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    if (value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(parsed);
  }

  static Color trendLineColor({
    required List<PricePoint> points,
    required AppPalette palette,
    required ChartVisualOptions visual,
    Color? fallback,
  }) {
    if (points.length < 2) {
      return fallback ?? palette.accent;
    }
    final isUp = points.last.value >= points.first.value;
    final custom = isUp
        ? parseHexColor(visual.bullColorHex)
        : parseHexColor(visual.bearColorHex);
    if (custom != null) return custom;
    return isUp ? palette.positive : palette.negative;
  }

  static Color candleBullColor(AppPalette palette, ChartVisualOptions visual) =>
      parseHexColor(visual.bullColorHex) ?? palette.positive;

  static Color candleBearColor(AppPalette palette, ChartVisualOptions visual) =>
      parseHexColor(visual.bearColorHex) ?? palette.negative;
}
