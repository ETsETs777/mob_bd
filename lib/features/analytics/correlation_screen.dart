// =============================================================================
// EcoPulse · lib/features/analytics/correlation_screen.dart
// Автор: Цымбал Е. В.
// Дата: 12.06.2026
// Сравнение активов, корреляции. Файл: correlation_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../shared/widgets/data_error_card.dart';
import '../../core/utils/correlation_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/correlation_provider.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/charts.dart';
import '../shared/widgets/loading_skeleton.dart';

/// Функция [correlationAssetLabel] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
String correlationAssetLabel(String id, AppLocalizations l10n) => switch (id) {
      'btc' => l10n.correlationBtc,
      'usdRub' => l10n.correlationUsdRub,
      'imoex' => l10n.correlationImoex,
      _ => id,
    };

/// Класс [CorrelationScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class CorrelationScreen extends ConsumerWidget {
/// Создаёт [CorrelationScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  const CorrelationScreen({super.key});

/// Отрисовывает UI [CorrelationScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final correlationAsync = ref.watch(correlationProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.correlationTitle)),
      body: correlationAsync.when(
        loading: () => const LoadingSkeleton(),
        error: (e, _) => DataErrorCard(
          error: e,
          onRetry: () => ref.read(correlationProvider.notifier).refresh(),
        ),
        data: (snapshot) {
          if (snapshot == null) {
            return Center(
              child: Text(
                l10n.chartInsufficientData,
                style: TextStyle(color: palette.textSecondary),
              ),
            );
          }

          return AppRefreshIndicator(
            onRefresh: () => ref.read(correlationProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.correlationSubtitle(snapshot.days),
                  style: TextStyle(color: palette.textSecondary, fontSize: 13),
                ),
                const Gap(20),
                _CorrelationMatrix(snapshot: snapshot, l10n: l10n),
                const Gap(24),
                Text(
                  l10n.correlationChartTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(12),
                MultiLineChartWidget(
                  normalized: true,
                  series: snapshot.assets
                      .map(
                        (a) => ChartLineSeries(
                          label: correlationAssetLabel(a.id, l10n),
                          points: a.history,
                        ),
                      )
                      .toList(),
                ),
                const Gap(16),
                Text(
                  l10n.correlationNote,
                  style: TextStyle(color: palette.textSecondary, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Приватный класс [_CorrelationMatrix].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _CorrelationMatrix extends StatelessWidget {
/// Создаёт [_CorrelationMatrix].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _CorrelationMatrix({required this.snapshot, required this.l10n});

/// Поле [snapshot] класса [_CorrelationMatrix].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final CorrelationSnapshot snapshot;
/// Поле [l10n] класса [_CorrelationMatrix].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_CorrelationMatrix].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final ids = snapshot.assets.map((a) => a.id).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 72),
                ...ids.map(
                  (id) => Expanded(
                    child: Text(
                      correlationAssetLabel(id, l10n),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            ...ids.map((rowId) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        correlationAssetLabel(rowId, l10n),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                    ...ids.map((colId) {
                      final value = snapshot.pair(rowId, colId) ?? 0;
                      return Expanded(
                        child: _MatrixCell(value: value, palette: palette),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_MatrixCell].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class _MatrixCell extends StatelessWidget {
/// Создаёт [_MatrixCell].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _MatrixCell({required this.value, required this.palette});

/// Поле [value] класса [_MatrixCell].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final double value;
/// Поле [palette] класса [_MatrixCell].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_MatrixCell].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    final abs = value.abs().clamp(0.0, 1.0);
    Color bg;
    Color fg;
    if (value >= 0.3) {
      bg = palette.positive.withValues(alpha: 0.12 + abs * 0.25);
      fg = palette.positive;
    } else if (value <= -0.3) {
      bg = palette.negative.withValues(alpha: 0.12 + abs * 0.25);
      fg = palette.negative;
    } else {
      bg = palette.surfaceLight;
      fg = palette.textPrimary;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        value.toStringAsFixed(2),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

/// Класс [CorrelationPreviewCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class CorrelationPreviewCard extends ConsumerWidget {
/// Создаёт [CorrelationPreviewCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const CorrelationPreviewCard({super.key});

/// Отрисовывает UI [CorrelationPreviewCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final correlationAsync = ref.watch(correlationProvider);

    return correlationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (snapshot) {
        if (snapshot == null) return const SizedBox.shrink();
        final btcImoex = snapshot.pair('btc', 'imoex');
        final btcUsd = snapshot.pair('btc', 'usdRub');

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => openAppPage(context, const CorrelationScreen()),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.correlationTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: palette.textSecondary),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    l10n.correlationSubtitle(snapshot.days),
                    style: TextStyle(color: palette.textSecondary, fontSize: 12),
                  ),
                  if (btcImoex != null || btcUsd != null) ...[
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (btcImoex != null)
                          _ChipPreview(
                            label: '${l10n.correlationBtc} ↔ ${l10n.correlationImoex}',
                            value: btcImoex,
                            palette: palette,
                          ),
                        if (btcUsd != null)
                          _ChipPreview(
                            label: '${l10n.correlationBtc} ↔ ${l10n.correlationUsdRub}',
                            value: btcUsd,
                            palette: palette,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Приватный класс [_ChipPreview].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
class _ChipPreview extends StatelessWidget {
/// Создаёт [_ChipPreview].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  const _ChipPreview({
    required this.label,
    required this.value,
    required this.palette,
  });

/// Поле [label] класса [_ChipPreview].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final String label;
/// Поле [value] класса [_ChipPreview].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final double value;
/// Поле [palette] класса [_ChipPreview].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_ChipPreview].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? palette.positive : palette.negative;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label ${value.toStringAsFixed(2)}',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
