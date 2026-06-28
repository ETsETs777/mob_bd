// =============================================================================
// EcoPulse · lib/app.dart
// Автор: Цымбал Е. В.
// Дата: 28.04.2026
// Корневой MaterialApp: тема, локаль, фон, home → AppGate.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/app_gate.dart';
import 'l10n/app_localizations.dart';
import 'providers/background_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';

/// Класс [EcoPulseApp].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
class EcoPulseApp extends ConsumerWidget {
/// Создаёт [EcoPulseApp].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  const EcoPulseApp({super.key});

/// Отрисовывает UI [EcoPulseApp].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(materialThemeModeProvider);
    final locale = ref.watch(localeProvider);
    final background = ref.watch(backgroundPresetProvider);
    final lightPalette = ref.watch(resolvedLightPaletteProvider);
    final darkPalette = ref.watch(resolvedDarkPaletteProvider);

    return MaterialApp(
      title: 'EcoPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFor(
        lightPalette,
        Brightness.light,
        background: background,
      ),
      darkTheme: AppTheme.themeFor(
        darkPalette,
        Brightness.dark,
        background: background,
      ),
      themeMode: themeMode,
      locale: locale.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppGate(),
    );
  }
}
