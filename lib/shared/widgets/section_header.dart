// =============================================================================
// EcoPulse · lib/shared/widgets/section_header.dart
// Автор: Цымбал Е. В.
// Дата: 03.06.2026
// Общие виджеты и действия приложения. Файл: section_header.
// =============================================================================

import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';

/// StatelessWidget [SectionHeader] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
class SectionHeader extends StatelessWidget {
/// Создаёт [SectionHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

/// Поле [title] класса [SectionHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String title;
/// Поле [actionLabel] класса [SectionHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final String? actionLabel;
/// Поле [onAction] класса [SectionHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final VoidCallback? onAction;

/// Отрисовывает UI [SectionHeader].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

/// StatelessWidget [DataSourceBadge] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class DataSourceBadge extends StatelessWidget {
/// Создаёт [DataSourceBadge].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const DataSourceBadge({super.key, required this.source});

/// Поле [source] класса [DataSourceBadge].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final String source;

/// Отрисовывает UI [DataSourceBadge].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        source,
        style: TextStyle(
          color: palette.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}
