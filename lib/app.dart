// =============================================================================
// EcoPulse · lib/app.dart
// Автор: Цымбал Е. В.
// Дата: 28.04.2026
// Корневой MaterialApp: тема, локаль, фон, home → AppGate.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/appearance_theme.dart';
import 'features/shell/app_gate.dart';
import 'l10n/app_localizations.dart';
import 'providers/appearance_provider.dart';
import 'providers/background_provider.dart';
import 'providers/customization_provider.dart';
import 'providers/data_display_customization_provider.dart';
import 'providers/theme_provider.dart';
import 'features/shared/widgets/formatters_scope.dart';

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
    final dataDisplay = ref.watch(resolvedDataDisplayProvider);
    final locale = dataDisplay.appLocale;
    final background = ref.watch(backgroundPresetProvider);
    final fontScale = ref.watch(
      customizationProvider.select((c) => c.appearance.fontScale),
    );
    final appearance = ref.watch(resolvedAppearanceProvider);
    final appearanceTheme = AppearanceTheme.fromResolved(appearance);
    final lightPalette = ref.watch(resolvedLightPaletteProvider);
    final darkPalette = ref.watch(resolvedDarkPaletteProvider);

    return FormattersScope(
      child: MaterialApp(
      title: 'EcoPulse',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(fontScale),
            disableAnimations:
                appearance.motionReduced || media.disableAnimations,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: AppTheme.themeFor(
        lightPalette,
        Brightness.light,
        background: background,
        cardStyle: appearance.cardStyle,
        visualDensity: appearance.visualDensity,
        appearanceTheme: appearanceTheme,
      ),
      darkTheme: AppTheme.themeFor(
        darkPalette,
        Brightness.dark,
        background: background,
        cardStyle: appearance.cardStyle,
        visualDensity: appearance.visualDensity,
        appearanceTheme: appearanceTheme,
      ),
      themeMode: themeMode,
      locale: locale.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppGate(),
      ),
    );
  }
}
