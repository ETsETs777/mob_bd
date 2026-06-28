// =============================================================================
// EcoPulse · lib/core/theme/app_theme.dart
// Автор: Цымбал Е. В.
// Дата: 16.05.2026
// Светлая/тёмная тема, палитры, Google Fonts.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_backgrounds.dart';
import 'app_palette.dart';
import 'background_palette.dart';
import '../motion/app_motion.dart';

/// Класс [AppTheme].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
class AppTheme {
/// Метод [themeFor] класса [AppTheme].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static ThemeData themeFor(
    AppPalette palette,
    Brightness brightness, {
    AppBackgroundPreset background = AppBackgroundPreset.classic,
  }) {
    final isDark = brightness == Brightness.dark;
    final cardAlpha = cardSurfaceAlpha(background, isDark: isDark);
    final cardBorder = Color.lerp(palette.border, palette.chartGradientStart, 0.4)!;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.accent,
        onPrimary: Colors.white,
        secondary: palette.accent,
        onSecondary: Colors.white,
        error: palette.negative,
        onError: Colors.white,
        surface: palette.surface,
        onSurface: palette.textPrimary,
      ),
      dividerColor: palette.border,
      cardColor: palette.surface,
      extensions: [palette],
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: palette.textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface.withValues(alpha: cardAlpha + 0.12),
        indicatorColor: palette.surfaceLight.withValues(alpha: 0.85),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 11, color: palette.textSecondary),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: palette.accent);
          }
          return IconThemeData(color: palette.textSecondary);
        }),
      ),
      cardTheme: CardThemeData(
        color: palette.surface.withValues(alpha: cardAlpha),
        surfaceTintColor: palette.chartGradientStart.withValues(alpha: 0.2),
        elevation: isDark ? 0 : 1,
        shadowColor: palette.chartGradientStart.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardBorder),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.accent,
        textColor: palette.textPrimary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.accent;
          return palette.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent.withValues(alpha: 0.35);
          }
          return palette.border;
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return palette.accent.withValues(alpha: 0.15);
            }
            return palette.surfaceLight;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return palette.accent;
            return palette.textSecondary;
          }),
          side: WidgetStateProperty.all(BorderSide(color: palette.border)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.accent, width: 1.5),
        ),
        labelStyle: TextStyle(color: palette.textSecondary),
      ),
      pageTransitionsTheme: AppMotion.pageTransitionsTheme(brightness),
    );
  }

/// Getter [dark] класса [AppTheme].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static ThemeData get dark => themeFor(AppPalette.dark, Brightness.dark);
/// Getter [light] класса [AppTheme].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static ThemeData get light => themeFor(AppPalette.light, Brightness.light);
}
