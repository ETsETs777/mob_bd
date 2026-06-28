// =============================================================================
// EcoPulse · lib/core/theme/app_palette.dart
// Автор: Цымбал Е. В.
// Дата: 15.05.2026
// Design system: тема, токены, палитра. Файл: app_palette.
// =============================================================================

import 'package:flutter/material.dart';

/// Класс [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
/// Создаёт [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.positive,
    required this.negative,
    required this.chartGrid,
    required this.chartGradientStart,
    required this.chartGradientEnd,
  });

/// Поле [background] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final Color background;
/// Поле [surface] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final Color surface;
/// Поле [surfaceLight] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  final Color surfaceLight;
/// Поле [border] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final Color border;
/// Поле [textPrimary] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final Color textPrimary;
/// Поле [textSecondary] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final Color textSecondary;
/// Поле [accent] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final Color accent;
/// Поле [positive] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  final Color positive;
/// Поле [negative] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final Color negative;
/// Поле [chartGrid] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final Color chartGrid;
/// Поле [chartGradientStart] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final Color chartGradientStart;
/// Поле [chartGradientEnd] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final Color chartGradientEnd;

/// Поле [dark] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static const dark = AppPalette(
    background: Color(0xFF0D1117),
    surface: Color(0xFF161B22),
    surfaceLight: Color(0xFF21262D),
    border: Color(0xFF30363D),
    textPrimary: Color(0xFFF0F6FC),
    textSecondary: Color(0xFF8B949E),
    accent: Color(0xFF58A6FF),
    positive: Color(0xFF3FB950),
    negative: Color(0xFFF85149),
    chartGrid: Color(0xFF21262D),
    chartGradientStart: Color(0x3358A6FF),
    chartGradientEnd: Color(0x0058A6FF),
  );

/// Поле [light] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static const light = AppPalette(
    background: Color(0xFFF6F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFF0F3F6),
    border: Color(0xFFD0D7DE),
    textPrimary: Color(0xFF1F2328),
    textSecondary: Color(0xFF656D76),
    accent: Color(0xFF0969DA),
    positive: Color(0xFF1A7F37),
    negative: Color(0xFFCF222E),
    chartGrid: Color(0xFFEAEEF2),
    chartGradientStart: Color(0x330969DA),
    chartGradientEnd: Color(0x000969DA),
  );

/// Метод [of] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ?? dark;
  }

/// Метод [copyWith] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
    Color? positive,
    Color? negative,
    Color? chartGrid,
    Color? chartGradientStart,
    Color? chartGradientEnd,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      chartGrid: chartGrid ?? this.chartGrid,
      chartGradientStart: chartGradientStart ?? this.chartGradientStart,
      chartGradientEnd: chartGradientEnd ?? this.chartGradientEnd,
    );
  }

/// Метод [lerp] класса [AppPalette].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      chartGrid: Color.lerp(chartGrid, other.chartGrid, t)!,
      chartGradientStart:
          Color.lerp(chartGradientStart, other.chartGradientStart, t)!,
      chartGradientEnd: Color.lerp(chartGradientEnd, other.chartGradientEnd, t)!,
    );
  }
}

/// Значение enum [oled].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
/// Значение enum [system].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
/// Значение enum [light].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
/// Значение enum [dark].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
/// Enum [AppThemeMode] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
/// Значение enum [oled].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
/// Значение enum [system].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
/// Значение enum [light].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
/// Значение enum [dark].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
enum AppThemeMode { dark, light, system, oled, dim, sepia, contrast }

/// Extension [AppThemeModeX].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
extension AppThemeModeX on AppThemeMode {
  String get label => switch (this) {
        AppThemeMode.dark => 'Тёмная',
        AppThemeMode.light => 'Светлая',
        AppThemeMode.system => 'Системная',
        AppThemeMode.oled => 'OLED',
        AppThemeMode.dim => 'Приглуш.',
        AppThemeMode.sepia => 'Сепия',
        AppThemeMode.contrast => 'Контраст',
      };

  String get storageKey => name;

  static AppThemeMode fromString(String? value) {
    return AppThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => AppThemeMode.dark,
    );
  }
}
