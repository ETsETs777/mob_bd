// =============================================================================
// EcoPulse · lib/shared/widgets/app_segmented_control.dart
// Автор: Цымбал Е. В.
// Дата: 01.06.2026
// Общие виджеты и действия приложения. Файл: app_segmented_control.
// =============================================================================

import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';

/// Material 3 SegmentedButton с палитрой EcoPulse.
class AppSegmentedControl<T> extends StatelessWidget {
/// Создаёт [AppSegmentedControl].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.multiSelectionEnabled = false,
  });

/// Поле [segments] класса [AppSegmentedControl].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final List<ButtonSegment<T>> segments;
/// Поле [selected] класса [AppSegmentedControl].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final Set<T> selected;
/// Поле [onSelectionChanged] класса [AppSegmentedControl].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final ValueChanged<Set<T>> onSelectionChanged;
/// Поле [multiSelectionEnabled] класса [AppSegmentedControl].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final bool multiSelectionEnabled;

/// Отрисовывает UI [AppSegmentedControl].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      multiSelectionEnabled: multiSelectionEnabled,
      onSelectionChanged: onSelectionChanged,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.chip)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent.withValues(alpha: 0.18);
          }
          return null;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent;
          }
          return null;
        }),
      ),
    );
  }
}
