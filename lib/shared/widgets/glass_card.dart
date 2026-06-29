// =============================================================================
// EcoPulse · lib/shared/widgets/glass_card.dart
// Автор: Цымбал Е. В.
// Дата: 02.06.2026
// Общие виджеты и действия приложения. Файл: glass_card.
// =============================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/appearance_theme.dart';
import '../../core/theme/background_palette.dart';
import '../../data/models/user_customization.dart';
import '../../providers/background_provider.dart';

/// Лёгкий blur-фон для header-блоков.
class GlassCard extends ConsumerWidget {
/// Создаёт [GlassCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

/// Поле [child] класса [GlassCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final Widget child;
/// Поле [padding] класса [GlassCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final EdgeInsetsGeometry padding;
/// Поле [margin] класса [GlassCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final EdgeInsetsGeometry? margin;

/// Отрисовывает UI [GlassCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final preset = ref.watch(backgroundPresetProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardStyle = AppearanceTheme.of(context).cardStyle;
    final alpha = cardSurfaceAlpha(preset, isDark: isDark);
    final border = Color.lerp(palette.border, palette.chartGradientStart, 0.45)!;
    final resolvedPadding = padding ??
        EdgeInsets.all(AppSpacing.scaled(context, AppSpacing.card));

    if (cardStyle == CardStyleId.flat) {
      return Container(
        margin: margin,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(padding: resolvedPadding, child: child),
      );
    }

    if (cardStyle == CardStyleId.bordered) {
      return Container(
        margin: margin,
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: isDark ? 0.92 : 0.98),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.border, width: 1.5),
        ),
        child: Padding(padding: resolvedPadding, child: child),
      );
    }

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.surface.withValues(alpha: alpha),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border.withValues(alpha: 0.75)),
              boxShadow: preset == AppBackgroundPreset.classic
                  ? null
                  : [
                      BoxShadow(
                        color: palette.chartGradientStart.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Padding(padding: resolvedPadding, child: child),
          ),
        ),
      ),
    );
  }
}
