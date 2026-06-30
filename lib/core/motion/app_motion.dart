// =============================================================================
// EcoPulse · lib/core/motion/app_motion.dart
// Автор: Цымбал Е. В.
// Дата: 21.06.2026
// Анимации и маршруты: AppPageRoute, Hero, openBondAnalyticsPage.
// =============================================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/app_background.dart';

/// EcoPulse motion system — единые тайминги и переходы.
///
/// Правила стабильности:
/// - Всегда проверять [enabled] / [duration] (уважение reduced motion).
/// - Навигация через [AppPageRoute] / [openAppPage], не raw MaterialPageRoute.
/// - Микро-анимации ≤450ms; без бесконечных loop на списках.
/// - Тяжёлые экраны (графики, PageView) — без параллельных fade на всём дереве.
///
/// Bond analytics fullscreen — [openBondAnalyticsPage] (shared-axis slide).
/// Hero bond cards → AppBar через [BondAnalyticsHero] tags.
abstract final class AppMotion {
  /// Быстрая анимация (200 ms) — табы, мелкие UI-переключения.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 22.06.2026
  static const fast = Duration(milliseconds: 200);

  /// Стандартная длительность (320 ms) — переходы экранов.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 23.06.2026
  static const normal = Duration(milliseconds: 320);

  /// Медленная анимация (450 ms) — акцентные появления.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 24.06.2026
  static const slow = Duration(milliseconds: 450);

  /// Основная кривая easing для fade/slide.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 25.06.2026
  static const curve = Curves.easeOutCubic;

  /// Emphasized curve для Material 3 переходов.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 21.06.2026
  static const emphasized = Curves.easeInOutCubicEmphasized;

  /// `true`, если анимации разрешены (не включён reduced motion).
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 22.06.2026
  static bool enabled(BuildContext context) {
    return !MediaQuery.disableAnimationsOf(context);
  }

  /// Возвращает [preferred] или `Duration.zero` при reduced motion.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 23.06.2026
  static Duration duration(BuildContext context, Duration preferred) {
    return enabled(context) ? preferred : Duration.zero;
  }

  /// ThemeData page transitions: fade+slide на Android/desktop, Cupertino на iOS.
  ///
  /// Автор: Цымбал Е. В.
  /// Дата: 24.06.2026
  static PageTransitionsTheme pageTransitionsTheme(Brightness brightness) {
    return PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _FadeSlideTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: _FadeSlideTransitionsBuilder(),
        TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: _FadeSlideTransitionsBuilder(),
      },
    );
  }
}

/// Приватный класс [_FadeSlideTransitionsBuilder].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
class _FadeSlideTransitionsBuilder extends PageTransitionsBuilder {
/// Метод [buildTransitions] класса [_FadeSlideTransitionsBuilder].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!AppMotion.enabled(context)) return child;

    final slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: AppMotion.curve));

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: AppMotion.curve),
      child: SlideTransition(position: slide, child: child),
    );
  }
}

/// Push с единым переходом; на web/desktop — лёгкий fade+slide.
class AppPageRoute<T> extends MaterialPageRoute<T> {
/// Создаёт [AppPageRoute].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  AppPageRoute({
    required super.builder,
    super.settings,
    super.fullscreenDialog,
  });

/// Getter [transitionDuration] класса [AppPageRoute].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Duration get transitionDuration => AppMotion.normal;

/// Метод [buildTransitions] класса [AppPageRoute].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!AppMotion.enabled(context)) return child;

    final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.03, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Функция [openAppPage] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
Future<T?> openAppPage<T>(
  BuildContext context,
  Widget page, {
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  return Navigator.of(context).push<T>(
    AppPageRoute<T>(
      builder: (_) => AppBackground(child: page),
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    ),
  );
}

/// Горизонтальный shared-axis для карточек аналитики облигаций → fullscreen.
class AppSharedAxisPageRoute<T> extends PageRouteBuilder<T> {
/// Создаёт [AppSharedAxisPageRoute].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  AppSharedAxisPageRoute({
    required Widget page,
    RouteSettings? settings,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              AppBackground(child: page),
          transitionDuration: AppMotion.normal,
          reverseTransitionDuration: AppMotion.fast,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (!AppMotion.enabled(context)) return child;

            final curved = CurvedAnimation(
              parent: animation,
              curve: AppMotion.curve,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.06, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// Функция [openBondAnalyticsPage] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
Future<T?> openBondAnalyticsPage<T>(
  BuildContext context,
  Widget page, {
  RouteSettings? settings,
}) {
  return Navigator.of(context).push<T>(
    AppSharedAxisPageRoute<T>(page: page, settings: settings),
  );
}

/// Функция [showAppBottomSheet] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  Color? backgroundColor,
  ShapeBorder? shape,
  bool useSafeArea = false,
}) {
  final motion = AppMotion.enabled(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    backgroundColor: backgroundColor ?? Colors.transparent,
    shape: shape,
    builder: (ctx) {
      final child = builder(ctx);
      if (!motion) return child;
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: AppMotion.normal,
        curve: AppMotion.curve,
        builder: (_, t, c) => Transform.translate(
          offset: Offset(0, 16 * (1 - t)),
          child: Opacity(opacity: t, child: c),
        ),
        child: child,
      );
    },
  );
}
