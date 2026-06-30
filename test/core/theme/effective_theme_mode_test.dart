import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/theme/app_palette.dart';
import 'package:ecopulse/core/theme/effective_theme_mode.dart';

void main() {
  test('resolveEffectiveThemeMode returns global when disabled', () {
    expect(
      resolveEffectiveThemeMode(
        globalMode: AppThemeMode.dark,
        perTabThemesEnabled: false,
        marketsThemeModeKey: 'light',
        profileThemeModeKey: 'light',
        navigationIndex: ShellTabIndex.markets,
      ),
      AppThemeMode.dark,
    );
  });

  test('resolveEffectiveThemeMode overrides markets and profile tabs', () {
    expect(
      resolveEffectiveThemeMode(
        globalMode: AppThemeMode.dark,
        perTabThemesEnabled: true,
        marketsThemeModeKey: 'oled',
        profileThemeModeKey: 'light',
        navigationIndex: ShellTabIndex.markets,
      ),
      AppThemeMode.oled,
    );
    expect(
      resolveEffectiveThemeMode(
        globalMode: AppThemeMode.dark,
        perTabThemesEnabled: true,
        marketsThemeModeKey: 'oled',
        profileThemeModeKey: 'light',
        navigationIndex: ShellTabIndex.profile,
      ),
      AppThemeMode.light,
    );
    expect(
      resolveEffectiveThemeMode(
        globalMode: AppThemeMode.dark,
        perTabThemesEnabled: true,
        marketsThemeModeKey: 'oled',
        profileThemeModeKey: 'light',
        navigationIndex: ShellTabIndex.home,
      ),
      AppThemeMode.dark,
    );
  });
}
