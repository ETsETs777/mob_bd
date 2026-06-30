import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Градиент карты на базе акцента темы.
List<Color> accentCardGradient(
  AppPalette palette, {
  double hueShift = 0,
  double darkLightness = 0.38,
  double lightLightness = 0.58,
}) {
  final hsl = HSLColor.fromColor(palette.accent);
  return [
    hsl
        .withHue((hsl.hue + hueShift) % 360)
        .withSaturation((hsl.saturation * 0.95).clamp(0.35, 1.0))
        .withLightness(darkLightness.clamp(0.22, 0.72))
        .toColor(),
    hsl
        .withHue((hsl.hue + hueShift) % 360)
        .withSaturation((hsl.saturation * 0.9).clamp(0.3, 1.0))
        .withLightness(lightLightness.clamp(0.32, 0.78))
        .toColor(),
  ];
}

/// Оттенок иконки в рамках текущей темы.
Color accentIconTone(
  AppPalette palette, {
  double hueShift = 0,
  double lightness = 0.55,
}) {
  final hsl = HSLColor.fromColor(palette.accent);
  return hsl
      .withHue((hsl.hue + hueShift) % 360)
      .withLightness(lightness.clamp(0.35, 0.75))
      .toColor();
}
