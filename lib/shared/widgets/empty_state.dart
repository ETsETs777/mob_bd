// =============================================================================
// EcoPulse · lib/shared/widgets/empty_state.dart
// Автор: Цымбал Е. В.
// Дата: 02.06.2026
// Общие виджеты и действия приложения. Файл: empty_state.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';

/// StatelessWidget [EmptyState] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class EmptyState extends StatelessWidget {
/// Создаёт [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Iconsax.chart,
    this.actionLabel,
    this.onAction,
  });

/// Поле [title] класса [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String title;
/// Поле [subtitle] класса [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String? subtitle;
/// Поле [icon] класса [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final IconData icon;
/// Поле [actionLabel] класса [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final String? actionLabel;
/// Поле [onAction] класса [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final VoidCallback? onAction;

/// Отрисовывает UI [EmptyState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: palette.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(color: palette.border),
              ),
              child: Icon(icon, size: 40, color: palette.textSecondary),
            ),
            const Gap(20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const Gap(8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const Gap(20),
              FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
