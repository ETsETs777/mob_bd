// =============================================================================
// EcoPulse · lib/features/shared/widgets/app_hover.dart
// Автор: Цымбал Е. В.
// Дата: 01.06.2026
// Общие виджеты и действия приложения. Файл: app_hover.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/motion/app_motion.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_palette.dart';

/// Лёгкий hover для web/desktop: border + scale. На touch — no-op.
class AppHoverSurface extends StatefulWidget {
/// Создаёт [AppHoverSurface].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  const AppHoverSurface({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.clickable = false,
  });

/// Поле [child] класса [AppHoverSurface].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final Widget child;
/// Поле [borderRadius] класса [AppHoverSurface].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final double borderRadius;
/// Поле [clickable] класса [AppHoverSurface].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final bool clickable;

/// Создаёт State для [AppHoverSurface].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  State<AppHoverSurface> createState() => _AppHoverSurfaceState();
}

/// Приватный класс [_AppHoverSurfaceState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class _AppHoverSurfaceState extends State<AppHoverSurface> {
/// Поле [_hovering] класса [_AppHoverSurfaceState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  var _hovering = false;

/// Отрисовывает UI [_AppHoverSurfaceState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final duration = AppMotion.duration(context, AppMotion.fast);

    return MouseRegion(
      cursor: widget.clickable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.008 : 1,
        duration: duration,
        curve: AppMotion.curve,
        child: AnimatedContainer(
          duration: duration,
          curve: AppMotion.curve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _hovering
                  ? palette.accent.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: palette.accent.withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
