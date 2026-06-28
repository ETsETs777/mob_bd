// =============================================================================
// EcoPulse · lib/features/shared/widgets/app_card.dart
// Автор: Цымбал Е. В.
// Дата: 31.05.2026
// Единая карточка Card + InkWell + hover для web.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/appearance_theme.dart';
import 'app_hover.dart';

/// Единая обёртка Card + InkWell с radius 16 и hover на web/desktop.
class AppCard extends StatelessWidget {
/// Создаёт [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.hover = true,
  });

/// Поле [child] класса [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final Widget child;
/// Поле [onTap] класса [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final VoidCallback? onTap;
/// Поле [onLongPress] класса [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final VoidCallback? onLongPress;
/// Поле [padding] класса [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  final EdgeInsetsGeometry? padding;
/// Поле [margin] класса [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final EdgeInsetsGeometry? margin;
/// Поле [hover] класса [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final bool hover;

/// Отрисовывает UI [AppCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding ??
        EdgeInsets.all(AppSpacing.scaled(context, AppSpacing.card));

    Widget card = Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      child: onTap == null && onLongPress == null
          ? Padding(padding: resolvedPadding, child: child)
          : InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              borderRadius: AppRadii.cardBorder,
              child: Padding(padding: resolvedPadding, child: child),
            ),
    );

    if (hover && onTap != null) {
      card = AppHoverSurface(
        borderRadius: AppRadii.card,
        clickable: true,
        child: card,
      );
    }

    return card;
  }
}
