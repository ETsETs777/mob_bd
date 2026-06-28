import 'package:ecopulse/core/customization/appearance_resolver.dart';
import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/theme/app_accent.dart';
import 'package:ecopulse/core/theme/app_palette.dart';
import 'package:ecopulse/core/theme/appearance_theme.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppearanceResolver maps density to spacing scale', () {
    final defaults = CustomizationDefaults.create().appearance;

    expect(
      AppearanceResolver.resolve(
        defaults.copyWith(uiDensity: UiDensity.compact),
      ).spacingScale,
      0.85,
    );
    expect(
      AppearanceResolver.resolve(
        defaults.copyWith(uiDensity: UiDensity.spacious),
      ).spacingScale,
      1.15,
    );
  });

  test('AppearanceResolver preserves motion and card style flags', () {
    final resolved = AppearanceResolver.resolve(
      CustomizationDefaults.create().appearance.copyWith(
            cardStyle: CardStyleId.bordered,
            motionReduced: true,
            amoledPureBlack: true,
          ),
    );

    expect(resolved.cardStyle, CardStyleId.bordered);
    expect(resolved.motionReduced, isTrue);
    expect(resolved.amoledPureBlack, isTrue);
  });

  test('AppearanceTheme scales spacing', () {
    const theme = AppearanceTheme(
      uiDensity: UiDensity.compact,
      cardStyle: CardStyleId.glass,
      motionReduced: false,
      amoledPureBlack: false,
      spacingScale: 0.85,
    );

    expect(theme.spacing(16), closeTo(13.6, 0.001));
  });

  test('AppPalette asOled pureBlack uses full black surfaces', () {
    final oled = AppPalette.dark.asOled(pureBlack: true);
    expect(oled.background, const Color(0xFF000000));
    expect(oled.surface, const Color(0xFF000000));
  });
}
