import 'app_palette.dart';

/// Индексы экранов в [MainShell._screens].
abstract final class ShellTabIndex {
  static const home = 0;
  static const currency = 1;
  static const inflation = 2;
  static const markets = 3;
  static const profile = 4;
  static const community = 5;
}

/// Резолв темы с учётом per-tab пресетов Markets / Profile.
AppThemeMode resolveEffectiveThemeMode({
  required AppThemeMode globalMode,
  required bool perTabThemesEnabled,
  required String marketsThemeModeKey,
  required String profileThemeModeKey,
  required int navigationIndex,
}) {
  if (!perTabThemesEnabled) return globalMode;
  return switch (navigationIndex) {
    ShellTabIndex.markets => AppThemeModeX.fromString(marketsThemeModeKey),
    ShellTabIndex.profile => AppThemeModeX.fromString(profileThemeModeKey),
    _ => globalMode,
  };
}
