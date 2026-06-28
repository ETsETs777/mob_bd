import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/user_customization.dart';
import 'chart_visual_utils.dart';

/// Палитры цветов серий для multi-line / pie / bar.
class ChartSeriesPalette {
  ChartSeriesPalette._();

  static const _pastel = [
    Color(0xFF79C0FF),
    Color(0xFF7EE787),
    Color(0xFFD2A8FF),
    Color(0xFFFFA657),
    Color(0xFF56D4DD),
    Color(0xFFFFB4DE),
  ];

  static const _highContrast = [
    Color(0xFF0969DA),
    Color(0xFF1A7F37),
    Color(0xFF8250DF),
    Color(0xFFCF222E),
    Color(0xFFBC4C00),
    Color(0xFF0D9488),
  ];

  static const _colorblindSafe = [
    Color(0xFF0072B2),
    Color(0xFFE69F00),
    Color(0xFF009E73),
    Color(0xFFD55E00),
    Color(0xFFCC79A7),
    Color(0xFF56B4E9),
  ];

  static List<Color> resolve({
    required AppPalette palette,
    required SeriesPalettePreset preset,
    required List<String> customHex,
    int count = 6,
  }) {
    final base = switch (preset) {
      SeriesPalettePreset.defaultPreset => [
        palette.accent,
        palette.positive,
        const Color(0xFFA371F7),
        palette.negative,
        const Color(0xFFF0883E),
        const Color(0xFF2DD4BF),
      ],
      SeriesPalettePreset.pastel => _pastel,
      SeriesPalettePreset.highContrast => _highContrast,
      SeriesPalettePreset.colorblindSafe => _colorblindSafe,
      SeriesPalettePreset.custom => _customColors(customHex, palette),
    };

    if (base.length >= count) return base.take(count).toList();
    return [
      for (var i = 0; i < count; i++) base[i % base.length],
    ];
  }

  static List<Color> _customColors(List<String> hex, AppPalette palette) {
    final parsed = hex
        .map(ChartVisualUtils.parseHexColor)
        .whereType<Color>()
        .toList();
    if (parsed.length >= 2) return parsed;
    return resolve(
      palette: palette,
      preset: SeriesPalettePreset.defaultPreset,
      customHex: const [],
    );
  }

  static String label(SeriesPalettePreset preset, {required bool isRu}) =>
      switch (preset) {
        SeriesPalettePreset.defaultPreset =>
          isRu ? 'Стандарт' : 'Default',
        SeriesPalettePreset.pastel => isRu ? 'Пастель' : 'Pastel',
        SeriesPalettePreset.highContrast =>
          isRu ? 'Контраст' : 'High contrast',
        SeriesPalettePreset.colorblindSafe =>
          isRu ? 'Доступная' : 'Colorblind safe',
        SeriesPalettePreset.custom => isRu ? 'Своя' : 'Custom',
      };
}
