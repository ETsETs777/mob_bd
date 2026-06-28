import 'package:flutter/material.dart';

import '../../data/models/user_customization.dart';

/// Эффективные параметры внешнего вида из [AppearanceCustomization].
class ResolvedAppearance {
  const ResolvedAppearance({
    required this.uiDensity,
    required this.cardStyle,
    required this.motionReduced,
    required this.amoledPureBlack,
    required this.spacingScale,
    required this.visualDensity,
  });

  final UiDensity uiDensity;
  final CardStyleId cardStyle;
  final bool motionReduced;
  final bool amoledPureBlack;
  final double spacingScale;
  final VisualDensity visualDensity;

  double spacing(double base) => base * spacingScale;
}

/// Резолвер настроек внешнего вида.
class AppearanceResolver {
  AppearanceResolver._();

  static ResolvedAppearance resolve(AppearanceCustomization appearance) {
    final spacingScale = switch (appearance.uiDensity) {
      UiDensity.compact => 0.85,
      UiDensity.comfortable => 1.0,
      UiDensity.spacious => 1.15,
    };

    return ResolvedAppearance(
      uiDensity: appearance.uiDensity,
      cardStyle: appearance.cardStyle,
      motionReduced: appearance.motionReduced,
      amoledPureBlack: appearance.amoledPureBlack,
      spacingScale: spacingScale,
      visualDensity: switch (appearance.uiDensity) {
        UiDensity.compact => VisualDensity.compact,
        UiDensity.comfortable => VisualDensity.standard,
        UiDensity.spacious => VisualDensity.comfortable,
      },
    );
  }
}
