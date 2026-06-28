import 'package:flutter/material.dart';

import '../../data/models/user_customization.dart';

/// Собранные визуальные параметры для отрисовки графика.
class ChartRenderStyle {
  const ChartRenderStyle({
    required this.visual,
    required this.seriesColors,
    required this.animateOnLoad,
    required this.seriesPalette,
  });

  final ChartVisualOptions visual;
  final List<Color> seriesColors;
  final bool animateOnLoad;
  final SeriesPalettePreset seriesPalette;

  Color seriesColorAt(int index) =>
      seriesColors[index % seriesColors.length];
}
