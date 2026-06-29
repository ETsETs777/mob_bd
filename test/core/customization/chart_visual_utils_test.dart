import 'package:ecopulse/core/customization/chart_series_palette.dart';
import 'package:ecopulse/core/customization/chart_visual_utils.dart';
import 'package:ecopulse/core/theme/app_palette.dart';
import 'package:ecopulse/data/models/price_point.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChartVisualUtils parses hex colors', () {
    final color = ChartVisualUtils.parseHexColor('#FF5733');
    expect(color, const Color(0xFFFF5733));
  });

  test('ChartVisualUtils hides grid for none style', () {
    const visual = ChartVisualOptions(
      showGrid: true,
      gridStyle: ChartGridStyle.none,
    );
    expect(ChartVisualUtils.effectiveShowGrid(visual), isFalse);
  });

  test('ChartVisualUtils respects motionReduced for animation', () {
    const visual = ChartVisualOptions(animateOnLoad: true);
    expect(
      ChartVisualUtils.effectiveAnimateOnLoad(
        visual: visual,
        motionReduced: true,
      ),
      isFalse,
    );
    expect(
      ChartVisualUtils.effectiveAnimateOnLoad(
        visual: visual,
        motionReduced: false,
      ),
      isTrue,
    );
  });

  test('ChartVisualUtils trend line uses bull/bear hex', () {
    const palette = AppPalette.dark;
    const visual = ChartVisualOptions(
      bullColorHex: '#00FF00',
      bearColorHex: '#FF0000',
    );
    final up = ChartVisualUtils.trendLineColor(
      points: [
        PricePoint(date: DateTime(2026, 1, 1), value: 90),
        PricePoint(date: DateTime(2026, 1, 2), value: 95),
      ],
      palette: palette,
      visual: visual,
    );
    expect(up, const Color(0xFF00FF00));
  });

  test('ChartSeriesPalette resolves presets', () {
    const palette = AppPalette.dark;
    final colors = ChartSeriesPalette.resolve(
      palette: palette,
      preset: SeriesPalettePreset.colorblindSafe,
      customHex: const [],
      count: 4,
    );
    expect(colors, hasLength(4));
    expect(
      ChartSeriesPalette.label(SeriesPalettePreset.pastel, isRu: true),
      'Пастель',
    );
  });
}
