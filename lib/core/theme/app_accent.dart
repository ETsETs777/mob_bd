// =============================================================================
// EcoPulse · lib/core/theme/app_accent.dart
// Автор: Цымбал Е. В.
// Дата: 15.05.2026
// Design system: тема, токены, палитра. Файл: app_accent.
// =============================================================================

import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Enum [AppAccentColor] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
enum AppAccentColor {
  blue('blue', 'Blue', 'Синий'),
  green('green', 'Green', 'Зелёный'),
  purple('purple', 'Purple', 'Фиолетовый'),
  orange('orange', 'Orange', 'Оранжевый'),
  teal('teal', 'Teal', 'Бирюза'),
  rose('rose', 'Rose', 'Розовый'),
  crimson('crimson', 'Crimson', 'Малина'),
  gold('gold', 'Gold', 'Золото');

  const AppAccentColor(this.key, this.labelEn, this.labelRu);

  final String key;
  final String labelEn;
  final String labelRu;

  Color get darkAccent => switch (this) {
        AppAccentColor.blue => const Color(0xFF58A6FF),
        AppAccentColor.green => const Color(0xFF3FB950),
        AppAccentColor.purple => const Color(0xFFA371F7),
        AppAccentColor.orange => const Color(0xFFF0883E),
        AppAccentColor.teal => const Color(0xFF2DD4BF),
        AppAccentColor.rose => const Color(0xFFF472B6),
        AppAccentColor.crimson => const Color(0xFFF85149),
        AppAccentColor.gold => const Color(0xFFE3B341),
      };

  Color get lightAccent => switch (this) {
        AppAccentColor.blue => const Color(0xFF0969DA),
        AppAccentColor.green => const Color(0xFF1A7F37),
        AppAccentColor.purple => const Color(0xFF8250DF),
        AppAccentColor.orange => const Color(0xFFBC4C00),
        AppAccentColor.teal => const Color(0xFF0D9488),
        AppAccentColor.rose => const Color(0xFFDB2777),
        AppAccentColor.crimson => const Color(0xFFCF222E),
        AppAccentColor.gold => const Color(0xFF9A6700),
      };

  static AppAccentColor fromKey(String? key) {
    return AppAccentColor.values.firstWhere(
      (c) => c.key == key,
      orElse: () => AppAccentColor.blue,
    );
  }
}

/// Extension [AppPaletteAccent].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
extension AppPaletteAccent on AppPalette {
  AppPalette withAccent(AppAccentColor accent, {required bool isDark}) {
    final color = isDark ? accent.darkAccent : accent.lightAccent;
    return copyWith(
      accent: color,
      chartGradientStart: color.withValues(alpha: 0.2),
      chartGradientEnd: color.withValues(alpha: 0),
    );
  }

  AppPalette asOled({bool pureBlack = false}) {
    if (pureBlack) {
      return copyWith(
        background: const Color(0xFF000000),
        surface: const Color(0xFF000000),
        surfaceLight: const Color(0xFF0A0A0A),
        border: const Color(0xFF1A1A1A),
        chartGrid: const Color(0xFF141414),
      );
    }
    return copyWith(
      background: const Color(0xFF000000),
      surface: const Color(0xFF0A0A0A),
      surfaceLight: const Color(0xFF141414),
      border: const Color(0xFF1F1F1F),
      chartGrid: const Color(0xFF1A1A1A),
    );
  }

  /// Мягкая тёмная тема — чуть светлее классической.
  AppPalette asDim() {
    return copyWith(
      background: const Color(0xFF12151C),
      surface: const Color(0xFF1A1F28),
      surfaceLight: const Color(0xFF242A35),
      border: const Color(0xFF2E3644),
      textSecondary: textSecondary.withValues(alpha: 0.88),
    );
  }

  /// Тёплая «читалка» — сепia-подобные surface.
  AppPalette asSepia() {
    return copyWith(
      background: const Color(0xFF1C1814),
      surface: const Color(0xFF2A231C),
      surfaceLight: const Color(0xFF352E26),
      border: const Color(0xFF4A4035),
      textPrimary: const Color(0xFFF5E6D3),
      textSecondary: const Color(0xFFC4B5A0),
      chartGrid: const Color(0xFF3D3429),
    );
  }

  /// Высокий контраст для доступности.
  AppPalette asHighContrast() {
    return copyWith(
      background: const Color(0xFF000000),
      surface: const Color(0xFF0D0D0D),
      surfaceLight: const Color(0xFF1A1A1A),
      border: const Color(0xFFFAFAFA),
      textPrimary: const Color(0xFFFFFFFF),
      textSecondary: const Color(0xFFE0E0E0),
      positive: const Color(0xFF4ADE80),
      negative: const Color(0xFFFF6B6B),
      chartGrid: const Color(0xFF404040),
    );
  }
}
