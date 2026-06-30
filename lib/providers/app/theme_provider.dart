// =============================================================================
// EcoPulse · lib/providers/theme_provider.dart
// Автор: Цымбал Е. В.
// Дата: 24.05.2026
// Riverpod state: провайдеры и notifiers. Файл: theme_provider.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_accent.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/background_palette.dart';
import '../../core/theme/effective_theme_mode.dart';
import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/app/accent_provider.dart';
import 'package:ecopulse/providers/customization/appearance_provider.dart';
import 'package:ecopulse/providers/app/background_provider.dart';
import 'package:ecopulse/providers/customization/customization_provider.dart';
import 'package:ecopulse/providers/app_providers.dart';

/// Riverpod-провайдер [themeModeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);

/// Riverpod AsyncNotifier [ThemeModeNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class ThemeModeNotifier extends Notifier<AppThemeMode> {
/// Поле [_cacheKey] класса [ThemeModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  static const _cacheKey = 'theme_mode';

/// Отрисовывает UI [ThemeModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  @override
  AppThemeMode build() {
    final stored = CacheService.instance.getString(_cacheKey);
    return AppThemeModeX.fromString(stored);
  }

/// Метод [setMode] класса [ThemeModeNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    await CacheService.instance.putString(_cacheKey, mode.storageKey);
  }
}

/// Активная тема с учётом per-tab пресетов Markets / Profile.
final effectiveThemeModeProvider = Provider<AppThemeMode>((ref) {
  final global = ref.watch(themeModeProvider);
  final appearance = ref.watch(customizationProvider.select((c) => c.appearance));
  final tab = ref.watch(navigationIndexProvider);
  return resolveEffectiveThemeMode(
    globalMode: global,
    perTabThemesEnabled: appearance.perTabThemesEnabled,
    marketsThemeModeKey: appearance.marketsThemeModeKey,
    profileThemeModeKey: appearance.profileThemeModeKey,
    navigationIndex: tab,
  );
});

/// Riverpod-провайдер [materialThemeModeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final materialThemeModeProvider = Provider<ThemeMode>((ref) {
  final mode = ref.watch(effectiveThemeModeProvider);
  return switch (mode) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.system => ThemeMode.system,
    _ => ThemeMode.dark,
  };
});

/// Riverpod-провайдер [resolvedDarkPaletteProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
final resolvedDarkPaletteProvider = Provider<AppPalette>((ref) {
  final mode = ref.watch(effectiveThemeModeProvider);
  final accent = ref.watch(accentColorProvider);
  final background = ref.watch(backgroundPresetProvider);
  final amoledPureBlack = ref.watch(
    resolvedAppearanceProvider.select((a) => a.amoledPureBlack),
  );
  var palette = background.tintPalette(
    AppPalette.dark.withAccent(accent, isDark: true),
    isDark: true,
  );
  palette = switch (mode) {
    AppThemeMode.oled => palette.asOled(pureBlack: amoledPureBlack).copyWith(
        border: palette.border,
        chartGradientStart: palette.chartGradientStart,
        chartGradientEnd: palette.chartGradientEnd,
      ),
    AppThemeMode.dim => palette.asDim(),
    AppThemeMode.sepia => palette.asSepia(),
    AppThemeMode.contrast => palette.asHighContrast(),
    _ => palette,
  };
  return palette;
});

/// Riverpod-провайдер [resolvedLightPaletteProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
final resolvedLightPaletteProvider = Provider<AppPalette>((ref) {
  final accent = ref.watch(accentColorProvider);
  final background = ref.watch(backgroundPresetProvider);
  return background.tintPalette(
    AppPalette.light.withAccent(accent, isDark: false),
    isDark: false,
  );
});
