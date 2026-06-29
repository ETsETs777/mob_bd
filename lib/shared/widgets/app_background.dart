// =============================================================================
// EcoPulse · lib/features/shared/widgets/app_background.dart
// Автор: Цымбал Е. В.
// Дата: 31.05.2026
// Общие виджеты и действия приложения. Файл: app_background.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_backgrounds.dart';
import '../../../providers/background_provider.dart';

/// Класс [AppBackground].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
class AppBackground extends ConsumerWidget {
/// Создаёт [AppBackground].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  const AppBackground({super.key, this.child});

/// Поле [child] класса [AppBackground].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final Widget? child;

/// Отрисовывает UI [AppBackground].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(backgroundPresetProvider);
    final colors = preset.gradientColors;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: preset.gradientBegin,
              end: preset.gradientEnd,
              colors: colors,
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[1].withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -30,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.length > 2
                  ? colors[2].withValues(alpha: 0.22)
                  : colors.first.withValues(alpha: 0.22),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

/// StatelessWidget [BackgroundPreviewTile] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
class BackgroundPreviewTile extends StatelessWidget {
/// Создаёт [BackgroundPreviewTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  const BackgroundPreviewTile({
    super.key,
    required this.preset,
    required this.selected,
    required this.onTap,
  });

/// Поле [preset] класса [BackgroundPreviewTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final AppBackgroundPreset preset;
/// Поле [selected] класса [BackgroundPreviewTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final bool selected;
/// Поле [onTap] класса [BackgroundPreviewTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final VoidCallback onTap;

/// Отрисовывает UI [BackgroundPreviewTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  @override
  Widget build(BuildContext context) {
    final colors = preset.gradientColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: preset.gradientBegin,
                  end: preset.gradientEnd,
                  colors: colors,
                ),
                border: Border.all(
                  color: selected ? Colors.white : Colors.white24,
                  width: selected ? 2.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: colors[1].withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: selected
                  ? const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 22),
                    )
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              preset.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white : Colors.white70,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
