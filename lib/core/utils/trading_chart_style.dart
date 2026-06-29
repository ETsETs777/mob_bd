import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';

import '../customization/chart_visual_utils.dart';
import '../theme/app_palette.dart';
import '../../data/models/user_customization.dart';

/// Тема биржевого графика из палитры EcoPulse и кастомизации.
class TradingChartStyle {
  TradingChartStyle._();

  static CandleSticksStyle resolve({
    required BuildContext context,
    required AppPalette palette,
    required ChartVisualOptions visual,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bull = ChartVisualUtils.candleBullColor(palette, visual);
    final bear = ChartVisualUtils.candleBearColor(palette, visual);
    final showGrid = ChartVisualUtils.effectiveShowGrid(visual);
    final gridColor = showGrid ? palette.chartGrid : Colors.transparent;
    final crosshairColor = visual.showCrosshair
        ? palette.accent.withValues(alpha: 0.75)
        : palette.textSecondary.withValues(alpha: 0.25);

    final builder =
        isDark ? CandleSticksStyle.dark : CandleSticksStyle.light;

    return builder(
      chartBackgroundColor: palette.surfaceLight.withValues(alpha: 0.55),
      gridLineColor: gridColor,
      axisTextColor: palette.textSecondary,
      candleBullColor: bull,
      candleBearColor: bear,
      volumeBullColor: bull.withValues(alpha: 0.4),
      volumeBearColor: bear.withValues(alpha: 0.4),
      crosshairLineColor: crosshairColor,
      crosshairLabelBackgroundColor: palette.surface,
      crosshairLabelTextColor: palette.textPrimary,
      ohlcInfoTextColor: palette.textSecondary,
      ohlcInfoBullColor: bull,
      ohlcInfoBearColor: bear,
      priceIndicatorBullBackgroundColor: bull,
      priceIndicatorBearBackgroundColor: bear,
      priceIndicatorTextColor: palette.surface,
      scaleButtonActiveBackgroundColor: palette.accent,
      scaleButtonActiveTextColor: palette.surface,
      scaleButtonInactiveBackgroundColor: palette.surfaceLight,
      scaleButtonInactiveTextColor: palette.textPrimary,
      loadingIndicatorColor: palette.accent,
    );
  }
}
