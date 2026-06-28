import 'package:flutter/material.dart';

import '../../data/models/user_customization.dart';
import '../customization/appearance_resolver.dart';

/// ThemeExtension с параметрами кастомизации внешнего вида.
class AppearanceTheme extends ThemeExtension<AppearanceTheme> {
  const AppearanceTheme({
    required this.uiDensity,
    required this.cardStyle,
    required this.motionReduced,
    required this.amoledPureBlack,
    required this.spacingScale,
  });

  final UiDensity uiDensity;
  final CardStyleId cardStyle;
  final bool motionReduced;
  final bool amoledPureBlack;
  final double spacingScale;

  factory AppearanceTheme.fromResolved(ResolvedAppearance resolved) {
    return AppearanceTheme(
      uiDensity: resolved.uiDensity,
      cardStyle: resolved.cardStyle,
      motionReduced: resolved.motionReduced,
      amoledPureBlack: resolved.amoledPureBlack,
      spacingScale: resolved.spacingScale,
    );
  }

  double spacing(double base) => base * spacingScale;

  static AppearanceTheme of(BuildContext context) {
    return Theme.of(context).extension<AppearanceTheme>() ??
        const AppearanceTheme(
          uiDensity: UiDensity.comfortable,
          cardStyle: CardStyleId.glass,
          motionReduced: false,
          amoledPureBlack: false,
          spacingScale: 1.0,
        );
  }

  @override
  AppearanceTheme copyWith({
    UiDensity? uiDensity,
    CardStyleId? cardStyle,
    bool? motionReduced,
    bool? amoledPureBlack,
    double? spacingScale,
  }) {
    return AppearanceTheme(
      uiDensity: uiDensity ?? this.uiDensity,
      cardStyle: cardStyle ?? this.cardStyle,
      motionReduced: motionReduced ?? this.motionReduced,
      amoledPureBlack: amoledPureBlack ?? this.amoledPureBlack,
      spacingScale: spacingScale ?? this.spacingScale,
    );
  }

  @override
  AppearanceTheme lerp(ThemeExtension<AppearanceTheme>? other, double t) {
    if (other is! AppearanceTheme) return this;
    return t < 0.5 ? this : other;
  }
}
