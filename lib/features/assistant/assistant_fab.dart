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

/// Кнопка ассистента для [Scaffold.floatingActionButton].
class AssistantFab extends StatelessWidget {
  const AssistantFab({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return AppEntranceFab(
      heroTag: 'assistant_fab',
      backgroundColor: palette.accent,
      foregroundColor: Colors.white,
      onPressed: () => showAssistantSheet(context),
      child: const Icon(Iconsax.message_text_1),
    );
  }
}

/// Функция [showAssistantSheet] (top-level).
void showAssistantSheet(BuildContext context) {
  showAppBottomSheet<void>(
    context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const AssistantSheet(),
  );
}
