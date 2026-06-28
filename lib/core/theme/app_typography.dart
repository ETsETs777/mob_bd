// =============================================================================
// EcoPulse · lib/core/theme/app_typography.dart
// Автор: Цымбал Е. В.
// Дата: 16.05.2026
// Типографика: tabular figures для котировок (AppTypography.quote).
// =============================================================================

import 'package:flutter/material.dart';

/// Типографика EcoPulse — tabular figures для котировок.
abstract final class AppTypography {
/// Поле [tabularFeatures] класса [AppTypography].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static const tabularFeatures = [FontFeature.tabularFigures()];

/// Метод [quote] класса [AppTypography].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static TextStyle quote(TextStyle base) =>
      base.copyWith(fontFeatures: tabularFeatures);

/// Метод [percent] класса [AppTypography].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static TextStyle percent(TextStyle base, {double? fontSize}) =>
      quote(base.copyWith(fontSize: fontSize ?? base.fontSize));
}

/// Extension [AppTypographyStyle].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
extension AppTypographyStyle on TextStyle {
  TextStyle get tabular => AppTypography.quote(this);
}
