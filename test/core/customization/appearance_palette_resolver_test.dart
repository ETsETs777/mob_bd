// =============================================================================
// EcoPulse · test/core/customization/appearance_palette_resolver_test.dart
// =============================================================================

import 'package:ecopulse/core/customization/appearance_palette_resolver.dart';
import 'package:ecopulse/core/theme/app_palette.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolve light theme uses light base palette', () {
    const appearance = AppearanceCustomization(
      themeModeKey: 'light',
      accentKey: 'blue',
      backgroundKey: 'classic',
      uiDensity: UiDensity.comfortable,
      fontScale: 1,
      cardStyle: CardStyleId.flat,
      motionReduced: false,
      amoledPureBlack: false,
    );

    final palette = AppearancePaletteResolver.resolve(appearance);
    expect(palette.background, AppPalette.light.background);
    expect(palette.accent, const Color(0xFF0969DA));
  });

  test('resolve oled applies pure black surfaces', () {
    const appearance = AppearanceCustomization(
      themeModeKey: 'oled',
      accentKey: 'green',
      backgroundKey: 'graphite',
      uiDensity: UiDensity.comfortable,
      fontScale: 1,
      cardStyle: CardStyleId.flat,
      motionReduced: false,
      amoledPureBlack: true,
    );

    final palette = AppearancePaletteResolver.resolve(appearance);
    expect(palette.background, const Color(0xFF000000));
    expect(palette.surface, const Color(0xFF000000));
  });

  test('resolve system follows platform brightness', () {
    const appearance = AppearanceCustomization(
      themeModeKey: 'system',
      accentKey: 'blue',
      backgroundKey: 'classic',
      uiDensity: UiDensity.comfortable,
      fontScale: 1,
      cardStyle: CardStyleId.flat,
      motionReduced: false,
      amoledPureBlack: false,
    );

    final light = AppearancePaletteResolver.resolve(
      appearance,
      systemBrightness: Brightness.light,
    );
    final dark = AppearancePaletteResolver.resolve(
      appearance,
      systemBrightness: Brightness.dark,
    );

    expect(light.background, AppPalette.light.background);
    expect(dark.background, isNot(AppPalette.light.background));
  });

  test('summaryLabel includes theme accent and background', () {
    const appearance = AppearanceCustomization(
      themeModeKey: 'dim',
      accentKey: 'purple',
      backgroundKey: 'ocean',
      uiDensity: UiDensity.compact,
      fontScale: 1,
      cardStyle: CardStyleId.glass,
      motionReduced: false,
      amoledPureBlack: false,
    );

    expect(
      AppearancePaletteResolver.summaryLabel(appearance, isRu: true),
      contains('Приглуш.'),
    );
    expect(
      AppearancePaletteResolver.summaryLabel(appearance, isRu: false),
      contains('Dim'),
    );
  });
}
