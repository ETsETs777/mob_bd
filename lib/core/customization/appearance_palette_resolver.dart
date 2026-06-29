// =============================================================================
// EcoPulse · lib/core/customization/appearance_palette_resolver.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Резолв AppPalette из AppearanceCustomization (для A/B preview).
// =============================================================================

import 'package:flutter/material.dart';

import '../../core/theme/app_accent.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/background_palette.dart';
import '../../data/models/user_customization.dart';

/// Строит [AppPalette] по настройкам внешнего вида без Riverpod.
class AppearancePaletteResolver {
  AppearancePaletteResolver._();

  static AppPalette resolve(
    AppearanceCustomization appearance, {
    Brightness systemBrightness = Brightness.dark,
  }) {
    final mode = AppThemeModeX.fromString(appearance.themeModeKey);
    final accent = AppAccentColor.fromKey(appearance.accentKey);
    final background =
        AppBackgroundPresetX.fromString(appearance.backgroundKey);

    final isDark = switch (mode) {
      AppThemeMode.light => false,
      AppThemeMode.system => systemBrightness == Brightness.dark,
      _ => true,
    };

    final base = isDark ? AppPalette.dark : AppPalette.light;
    var palette = background.tintPalette(
      base.withAccent(accent, isDark: isDark),
      isDark: isDark,
    );

    if (isDark) {
      palette = switch (mode) {
        AppThemeMode.oled => palette.asOled(pureBlack: appearance.amoledPureBlack).copyWith(
            border: palette.border,
            chartGradientStart: palette.chartGradientStart,
            chartGradientEnd: palette.chartGradientEnd,
          ),
        AppThemeMode.dim => palette.asDim(),
        AppThemeMode.sepia => palette.asSepia(),
        AppThemeMode.contrast => palette.asHighContrast(),
        _ => palette,
      };
    }

    return palette;
  }

  static String summaryLabel(
    AppearanceCustomization appearance, {
    required bool isRu,
  }) {
    final mode = AppThemeModeX.fromString(appearance.themeModeKey);
    final accent = AppAccentColor.fromKey(appearance.accentKey);
    final background =
        AppBackgroundPresetX.fromString(appearance.backgroundKey);
    final theme = isRu ? mode.labelRu : mode.labelEn;
    final accentName = isRu ? accent.labelRu : accent.labelEn;
    final bg = isRu ? background.label : background.labelEn;
    return '$theme · $accentName · $bg';
  }
}

extension _ThemeModeLabels on AppThemeMode {
  String get labelRu => switch (this) {
        AppThemeMode.dark => 'Тёмная',
        AppThemeMode.light => 'Светлая',
        AppThemeMode.system => 'Системная',
        AppThemeMode.oled => 'OLED',
        AppThemeMode.dim => 'Приглуш.',
        AppThemeMode.sepia => 'Сепия',
        AppThemeMode.contrast => 'Контраст',
      };

  String get labelEn => switch (this) {
        AppThemeMode.dark => 'Dark',
        AppThemeMode.light => 'Light',
        AppThemeMode.system => 'System',
        AppThemeMode.oled => 'OLED',
        AppThemeMode.dim => 'Dim',
        AppThemeMode.sepia => 'Sepia',
        AppThemeMode.contrast => 'Contrast',
      };
}
