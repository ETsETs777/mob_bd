// =============================================================================
// EcoPulse · lib/features/assistant/assistant_fab.dart
// Автор: Цымбал Е. В.
// Дата: 13.06.2026
// AI-ассистент: FAB, sheet, голос. Файл: assistant_fab.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../shared/widgets/motion_widgets.dart';
import 'assistant_sheet.dart';

/// StatelessWidget [AssistantFab] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class AssistantFab extends StatelessWidget {
/// Создаёт [AssistantFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  const AssistantFab({super.key});

/// Отрисовывает UI [AssistantFab].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      right: 16,
      bottom: bottom + 72,
      child: AppEntranceFab(
        heroTag: 'assistant_fab',
        backgroundColor: palette.accent,
        foregroundColor: Colors.white,
        onPressed: () => showAssistantSheet(context),
        child: const Icon(Iconsax.message_text_1),
      ),
    );
  }
}

/// Функция [showAssistantSheet] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
void showAssistantSheet(BuildContext context) {
  showAppBottomSheet<void>(
    context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const AssistantSheet(),
  );
}
