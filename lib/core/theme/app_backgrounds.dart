// =============================================================================
// EcoPulse · lib/core/theme/app_backgrounds.dart
// Автор: Цымбал Е. В.
// Дата: 15.05.2026
// Design system: тема, токены, палитра. Файл: app_backgrounds.
// =============================================================================

import 'package:flutter/material.dart';

/// Enum [AppBackgroundPreset] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
enum AppBackgroundPreset {
  classic,
  sberGreen,
  ocean,
  purpleNight,
  sunset,
  graphite,
  emerald,
  minimalLight,
  midnight,
  aurora,
  rose,
  lavender,
  sand,
  coffee,
}

/// Extension [AppBackgroundPresetX].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
extension AppBackgroundPresetX on AppBackgroundPreset {
  String get label => switch (this) {
        AppBackgroundPreset.classic => 'Классика',
        AppBackgroundPreset.sberGreen => 'Изумруд',
        AppBackgroundPreset.ocean => 'Океан',
        AppBackgroundPreset.purpleNight => 'Ночь',
        AppBackgroundPreset.sunset => 'Закат',
        AppBackgroundPreset.graphite => 'Графит',
        AppBackgroundPreset.emerald => 'Лес',
        AppBackgroundPreset.minimalLight => 'Светлый',
        AppBackgroundPreset.midnight => 'Полночь',
        AppBackgroundPreset.aurora => 'Аврора',
        AppBackgroundPreset.rose => 'Роза',
        AppBackgroundPreset.lavender => 'Лаванда',
        AppBackgroundPreset.sand => 'Песок',
        AppBackgroundPreset.coffee => 'Кофе',
      };

  String get labelEn => switch (this) {
        AppBackgroundPreset.classic => 'Classic',
        AppBackgroundPreset.sberGreen => 'Emerald',
        AppBackgroundPreset.ocean => 'Ocean',
        AppBackgroundPreset.purpleNight => 'Night',
        AppBackgroundPreset.sunset => 'Sunset',
        AppBackgroundPreset.graphite => 'Graphite',
        AppBackgroundPreset.emerald => 'Forest',
        AppBackgroundPreset.minimalLight => 'Light',
        AppBackgroundPreset.midnight => 'Midnight',
        AppBackgroundPreset.aurora => 'Aurora',
        AppBackgroundPreset.rose => 'Rose',
        AppBackgroundPreset.lavender => 'Lavender',
        AppBackgroundPreset.sand => 'Sand',
        AppBackgroundPreset.coffee => 'Coffee',
      };

  String get storageKey => name;

  static AppBackgroundPreset fromString(String? value) {
    return AppBackgroundPreset.values.firstWhere(
      (p) => p.name == value,
      orElse: () => AppBackgroundPreset.classic,
    );
  }

  List<Color> get gradientColors => switch (this) {
        AppBackgroundPreset.classic => [
            const Color(0xFF0D1117),
            const Color(0xFF161B22),
            const Color(0xFF0D1117),
          ],
        AppBackgroundPreset.sberGreen => [
            const Color(0xFF0A3D2E),
            const Color(0xFF14805A),
            const Color(0xFF0D4A35),
          ],
        AppBackgroundPreset.ocean => [
            const Color(0xFF0A1628),
            const Color(0xFF1A4B7A),
            const Color(0xFF0D2137),
          ],
        AppBackgroundPreset.purpleNight => [
            const Color(0xFF1A0A2E),
            const Color(0xFF4A1A6B),
            const Color(0xFF12081F),
          ],
        AppBackgroundPreset.sunset => [
            const Color(0xFF2D1B1B),
            const Color(0xFF8B3A2A),
            const Color(0xFF1A1010),
          ],
        AppBackgroundPreset.graphite => [
            const Color(0xFF1C1C1E),
            const Color(0xFF3A3A3C),
            const Color(0xFF141416),
          ],
        AppBackgroundPreset.emerald => [
            const Color(0xFF0B2E1F),
            const Color(0xFF1B6B45),
            const Color(0xFF082018),
          ],
        AppBackgroundPreset.minimalLight => [
            const Color(0xFFF0F4F8),
            const Color(0xFFE2EAF2),
            const Color(0xFFF8FAFC),
          ],
        AppBackgroundPreset.midnight => [
            const Color(0xFF050814),
            const Color(0xFF0F1B3D),
            const Color(0xFF060A18),
          ],
        AppBackgroundPreset.aurora => [
            const Color(0xFF0A1F1A),
            const Color(0xFF1A6B5C),
            const Color(0xFF2E8BC0),
          ],
        AppBackgroundPreset.rose => [
            const Color(0xFF2A1520),
            const Color(0xFF8B4A6B),
            const Color(0xFF1A0E14),
          ],
        AppBackgroundPreset.lavender => [
            const Color(0xFF1E1830),
            const Color(0xFF6B5B95),
            const Color(0xFF151020),
          ],
        AppBackgroundPreset.sand => [
            const Color(0xFFF5EDE0),
            const Color(0xFFE8D5BC),
            const Color(0xFFFAF6F0),
          ],
        AppBackgroundPreset.coffee => [
            const Color(0xFF1A120C),
            const Color(0xFF4A3224),
            const Color(0xFF120C08),
          ],
      };

  Alignment get gradientBegin => switch (this) {
        AppBackgroundPreset.aurora => Alignment.topCenter,
        AppBackgroundPreset.sand => Alignment.topLeft,
        _ => Alignment.topLeft,
      };

  Alignment get gradientEnd => switch (this) {
        AppBackgroundPreset.aurora => Alignment.bottomCenter,
        _ => Alignment.bottomRight,
      };

  bool get isLight =>
      this == AppBackgroundPreset.minimalLight ||
      this == AppBackgroundPreset.sand;
}
