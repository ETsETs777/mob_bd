// =============================================================================
// EcoPulse · lib/features/shared/widgets/loading_skeleton.dart
// Автор: Цымбал Е. В.
// Дата: 02.06.2026
// Общие виджеты и действия приложения. Файл: loading_skeleton.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_palette.dart';

/// StatelessWidget [LoadingSkeleton] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class LoadingSkeleton extends StatelessWidget {
/// Создаёт [LoadingSkeleton].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  const LoadingSkeleton({super.key, this.itemCount = 4});

/// Поле [itemCount] класса [LoadingSkeleton].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final int itemCount;

/// Отрисовывает UI [LoadingSkeleton].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}

/// StatelessWidget [ShimmerCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
class ShimmerCard extends StatelessWidget {
/// Создаёт [ShimmerCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const ShimmerCard({super.key});

/// Отрисовывает UI [ShimmerCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? palette.surface : palette.surfaceLight,
      highlightColor: isDark ? palette.surfaceLight : palette.surface,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.border),
        ),
      ),
    );
  }
}

/// StatelessWidget [ErrorState] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class ErrorState extends StatelessWidget {
/// Создаёт [ErrorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

/// Поле [message] класса [ErrorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final String message;
/// Поле [onRetry] класса [ErrorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final VoidCallback onRetry;

/// Отрисовывает UI [ErrorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: palette.textSecondary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// StatelessWidget [OfflineBanner] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class OfflineBanner extends StatelessWidget {
/// Создаёт [OfflineBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const OfflineBanner({super.key});

/// Отрисовывает UI [OfflineBanner].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: palette.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 16, color: palette.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline — показаны сохранённые данные',
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
