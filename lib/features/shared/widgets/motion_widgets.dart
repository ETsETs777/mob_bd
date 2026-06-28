// =============================================================================
// EcoPulse · lib/features/shared/widgets/motion_widgets.dart
// Автор: Цымбал Е. В.
// Дата: 03.06.2026
// Общие виджеты и действия приложения. Файл: motion_widgets.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/motion/app_motion.dart';

/// Лёгкий fade+slide для списков и секций. Уважает reduced motion.
extension AppMotionEntrance on Widget {
  Widget motionEntrance(
    BuildContext context, {
    int index = 0,
    Duration? delay,
  }) {
    if (!AppMotion.enabled(context)) return this;

    final stagger = delay ?? Duration(milliseconds: (index * 45).clamp(0, 360));
    return animate()
        .fadeIn(duration: AppMotion.normal, delay: stagger, curve: AppMotion.curve)
        .moveY(
          begin: 12,
          end: 0,
          duration: AppMotion.normal,
          delay: stagger,
          curve: AppMotion.curve,
        );
  }
}

/// Сохраняет состояние таба и плавно показывает/скрывает слой.
class AppTabLayer extends StatelessWidget {
/// Создаёт [AppTabLayer].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  const AppTabLayer({
    super.key,
    required this.visible,
    required this.child,
  });

/// Поле [visible] класса [AppTabLayer].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final bool visible;
/// Поле [child] класса [AppTabLayer].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final Widget child;

/// Отрисовывает UI [AppTabLayer].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.duration(context, AppMotion.fast);
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: duration,
        curve: AppMotion.curve,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 0.012),
          duration: duration,
          curve: AppMotion.curve,
          child: RepaintBoundary(child: child),
        ),
      ),
    );
  }
}

/// FAB с мягким появлением.
class AppEntranceFab extends StatefulWidget {
/// Создаёт [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const AppEntranceFab({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.child,
    this.heroTag,
  });

/// Поле [onPressed] класса [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final VoidCallback onPressed;
/// Поле [backgroundColor] класса [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final Color backgroundColor;
/// Поле [foregroundColor] класса [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final Color foregroundColor;
/// Поле [child] класса [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final Widget child;
/// Поле [heroTag] класса [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final Object? heroTag;

/// Создаёт State для [AppEntranceFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  State<AppEntranceFab> createState() => _AppEntranceFabState();
}

/// Приватный класс [_AppEntranceFabState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class _AppEntranceFabState extends State<AppEntranceFab>
    with SingleTickerProviderStateMixin {
/// Поле [_ctrl] класса [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  late final AnimationController _ctrl;
/// Поле [_scale] класса [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  late final Animation<double> _scale;
/// Поле [_started] класса [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  var _started = false;

/// Инициализация state [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppMotion.normal);
    _scale = CurvedAnimation(parent: _ctrl, curve: AppMotion.emphasized);
  }

/// Метод [didChangeDependencies] класса [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.enabled(context)) {
      _ctrl.forward();
    } else {
      _ctrl.value = 1;
    }
  }

/// Освобождает ресурсы [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_AppEntranceFabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton(
        heroTag: widget.heroTag,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
