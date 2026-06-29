// =============================================================================
// EcoPulse · lib/shared/widgets/app_refresh_indicator.dart
// Автор: Цымбал Е. В.
// Дата: 01.06.2026
// Общие виджеты и действия приложения. Файл: app_refresh_indicator.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_palette.dart';

/// StatelessWidget [AppRefreshIndicator] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class AppRefreshIndicator extends StatelessWidget {
/// Создаёт [AppRefreshIndicator].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

/// Поле [onRefresh] класса [AppRefreshIndicator].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final Future<void> Function() onRefresh;
/// Поле [child] класса [AppRefreshIndicator].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final Widget child;

/// Отрисовывает UI [AppRefreshIndicator].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return RefreshIndicator(
      color: palette.accent,
      backgroundColor: palette.surface,
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await onRefresh();
      },
      child: child,
    );
  }
}
