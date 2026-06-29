// =============================================================================
// EcoPulse · lib/shared/widgets/animated_value_text.dart
// Автор: Цымбал Е. В.
// Дата: 31.05.2026
// Общие виджеты и действия приложения. Файл: animated_value_text.
// =============================================================================

import 'package:flutter/material.dart';

/// StatefulWidget [AnimatedValueText] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
class AnimatedValueText extends StatefulWidget {
/// Создаёт [AnimatedValueText].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  const AnimatedValueText({
    super.key,
    required this.value,
    required this.style,
    required this.format,
    this.duration = const Duration(milliseconds: 500),
  });

/// Поле [value] класса [AnimatedValueText].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final double value;
/// Поле [style] класса [AnimatedValueText].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final TextStyle style;
/// Поле [format] класса [AnimatedValueText].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  final String Function(double) format;
/// Поле [duration] класса [AnimatedValueText].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final Duration duration;

/// Создаёт State для [AnimatedValueText].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  State<AnimatedValueText> createState() => _AnimatedValueTextState();
}

/// Приватный класс [_AnimatedValueTextState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class _AnimatedValueTextState extends State<AnimatedValueText> {
/// Поле [_from] класса [_AnimatedValueTextState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  late double _from;
/// Поле [_to] класса [_AnimatedValueTextState].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  late double _to;

/// Инициализация state [_AnimatedValueTextState].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  void initState() {
    super.initState();
    _from = widget.value;
    _to = widget.value;
  }

/// Метод [didUpdateWidget] класса [_AnimatedValueTextState].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  void didUpdateWidget(covariant AnimatedValueText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _from = oldWidget.value;
      _to = widget.value;
    }
  }

/// Отрисовывает UI [_AnimatedValueTextState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_to),
      tween: Tween(begin: _from, end: _to),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      builder: (context, val, _) => Text(
        widget.format(val),
        style: widget.style,
      ),
    );
  }
}
