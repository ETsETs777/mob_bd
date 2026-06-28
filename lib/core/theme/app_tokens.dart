// =============================================================================
// EcoPulse · lib/core/theme/app_tokens.dart
// Автор: Цымбал Е. В.
// Дата: 16.05.2026
// Design tokens: AppSpacing, AppRadii, AppBreakpoints.
// =============================================================================

import 'package:flutter/material.dart';

import 'appearance_theme.dart';

/// Design tokens EcoPulse — spacing, radii, breakpoints.
abstract final class AppSpacing {
/// Поле [xs] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static const xs = 4.0;
/// Поле [sm] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static const sm = 8.0;
/// Поле [md] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static const md = 16.0;
/// Поле [lg] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const lg = 24.0;
/// Поле [xl] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static const xl = 32.0;

/// Поле [page] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static const page = md;
/// Поле [card] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static const card = md;
/// Поле [section] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static const section = lg;
/// Поле [stack] класса [AppSpacing].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const stack = sm;

  /// Масштабирует spacing по [AppearanceTheme] (плотность UI).
  static double scaled(BuildContext context, double base) =>
      AppearanceTheme.of(context).spacing(base);
}

/// Класс [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
abstract final class AppRadii {
/// Поле [card] класса [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static const card = 16.0;
/// Поле [sheet] класса [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static const sheet = 20.0;
/// Поле [chip] класса [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static const chip = 10.0;
/// Поле [bar] класса [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const bar = 6.0;

/// Getter [cardBorder] класса [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static BorderRadius get cardBorder => BorderRadius.circular(card);
/// Getter [sheetBorder] класса [AppRadii].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static BorderRadius get sheetBorder =>
      const BorderRadius.vertical(top: Radius.circular(sheet));
}

/// Класс [AppBreakpoints].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
abstract final class AppBreakpoints {
/// Поле [bondAnalyticsSideBySide] класса [AppBreakpoints].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  static const bondAnalyticsSideBySide = 720.0;
/// Поле [wideContent] класса [AppBreakpoints].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const wideContent = 900.0;
}
