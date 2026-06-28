// =============================================================================
// EcoPulse · lib/features/insights/macro_calendar_screen.dart
// Автор: Цымбал Е. В.
// Дата: 13.06.2026
// Timeline событий, macro-календарь. Файл: macro_calendar_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/constants/api_config.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/macro_event.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/news_provider.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/loading_skeleton.dart';

/// Класс [MacroCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class MacroCalendarScreen extends ConsumerWidget {
/// Создаёт [MacroCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  const MacroCalendarScreen({super.key});

/// Отрисовывает UI [MacroCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final events = ref.watch(macroCalendarProvider);
    final hasKey = ApiConfig.finnhubKey.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.macroCalendarTitle)),
      body: AppRefreshIndicator(
        onRefresh: () => ref.read(macroCalendarProvider.notifier).refresh(),
        child: !hasKey
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _HintCard(text: l10n.newsFinnhubHint, palette: palette),
                ],
              )
            : events.when(
                data: (items) {
                  if (items.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          l10n.macroCalendarEmpty,
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Gap(8),
                    itemBuilder: (_, i) =>
                        _MacroEventTile(event: items[i], palette: palette),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: ShimmerCard(),
                ),
                error: (_, __) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      l10n.newsLoadError,
                      style: TextStyle(color: palette.negative),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Приватный класс [_HintCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class _HintCard extends StatelessWidget {
/// Создаёт [_HintCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _HintCard({required this.text, required this.palette});

/// Поле [text] класса [_HintCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final String text;
/// Поле [palette] класса [_HintCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_HintCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Iconsax.key, color: palette.textSecondary),
            const Gap(12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: palette.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_MacroEventTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class _MacroEventTile extends StatelessWidget {
/// Создаёт [_MacroEventTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _MacroEventTile({required this.event, required this.palette});

/// Поле [event] класса [_MacroEventTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final MacroEvent event;
/// Поле [palette] класса [_MacroEventTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_MacroEventTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${event.date.day}.${event.date.month.toString().padLeft(2, '0')}';
    final timeStr = event.time ?? '';
    final impactColor = switch (event.impact?.toLowerCase()) {
      'high' => palette.negative,
      'medium' => palette.accent,
      _ => palette.textSecondary,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: palette.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    event.country,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                const Gap(8),
                Text(
                  '$dateStr${timeStr.isNotEmpty ? ' · $timeStr' : ''}',
                  style: TextStyle(color: palette.textSecondary, fontSize: 12),
                ),
                const Spacer(),
                if (event.impact != null)
                  Icon(Iconsax.flash_1, size: 14, color: impactColor),
              ],
            ),
            const Gap(8),
            Text(
              event.event,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            if (event.estimate != null ||
                event.previous != null ||
                event.actual != null) ...[
              const Gap(8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (event.previous != null)
                    _MetricChip(
                      label: 'Prev',
                      value: '${event.previous}${event.unit ?? ''}',
                      palette: palette,
                    ),
                  if (event.estimate != null)
                    _MetricChip(
                      label: 'Est',
                      value: '${event.estimate}${event.unit ?? ''}',
                      palette: palette,
                    ),
                  if (event.actual != null)
                    _MetricChip(
                      label: 'Act',
                      value: '${event.actual}${event.unit ?? ''}',
                      palette: palette,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_MetricChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class _MetricChip extends StatelessWidget {
/// Создаёт [_MetricChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _MetricChip({
    required this.label,
    required this.value,
    required this.palette,
  });

/// Поле [label] класса [_MetricChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final String label;
/// Поле [value] класса [_MetricChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final String value;
/// Поле [palette] класса [_MetricChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_MetricChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $value',
      style: TextStyle(fontSize: 12, color: palette.textSecondary),
    );
  }
}
