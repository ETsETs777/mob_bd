// =============================================================================
// EcoPulse · lib/core/theme/background_palette.dart
// Автор: Цымбал Е. В.
// Дата: 16.05.2026
// Design system: тема, токены, палитра. Файл: background_palette.
// =============================================================================

import 'package:flutter/material.dart';

import 'app_backgrounds.dart';
import 'app_palette.dart';

/// Extension [AppBackgroundPresetPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
extension AppBackgroundPresetPalette on AppBackgroundPreset {
  /// Подкрашивает surface/border карточек под выбранный градиент фона.
  AppPalette tintPalette(AppPalette base, {required bool isDark}) {
    if (this == AppBackgroundPreset.classic) return base;

    final colors = gradientColors;
    final mid = colors.length > 1 ? colors[1] : colors.first;
    final deep = colors.first;

    final surface = Color.alphaBlend(
      mid.withValues(alpha: isDark ? 0.42 : 0.16),
      base.surface,
    );
    final surfaceLight = Color.alphaBlend(
      mid.withValues(alpha: isDark ? 0.28 : 0.10),
      base.surfaceLight,
    );
    final border = Color.lerp(base.border, mid, isDark ? 0.55 : 0.35)!;

    return base.copyWith(
      surface: surface,
      surfaceLight: surfaceLight,
      border: border,
      chartGradientStart: mid.withValues(alpha: isDark ? 0.38 : 0.28),
      chartGradientEnd: deep.withValues(alpha: 0),
    );
  }
}

/// Прозрачность карточек — чем насыщеннее фон, тем «стекляннее» surface.
double cardSurfaceAlpha(AppBackgroundPreset preset, {required bool isDark}) {
  if (!isDark) {
    return preset == AppBackgroundPreset.minimalLight ||
            preset == AppBackgroundPreset.sand
        ? 0.92
        : 0.88;
  }
  return switch (preset) {
    AppBackgroundPreset.classic => 0.78,
    AppBackgroundPreset.minimalLight || AppBackgroundPreset.sand => 0.88,
    _ => 0.58,
  };
}
