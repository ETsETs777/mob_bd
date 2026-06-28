// =============================================================================
// EcoPulse · lib/features/insights/timeline_screen.dart
// Автор: Цымбал Е. В.
// Дата: 13.06.2026
// Timeline событий, macro-календарь. Файл: timeline_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/timeline_builder.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/news_provider.dart';
import '../shared/widgets/app_refresh_indicator.dart';

/// Класс [TimelineScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class TimelineScreen extends ConsumerWidget {
/// Создаёт [TimelineScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  const TimelineScreen({super.key});

/// Отрисовывает UI [TimelineScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final keyRate = ref.watch(keyRateProvider).valueOrNull;
    final macro = ref.watch(macroCalendarProvider).valueOrNull ?? const [];

    final items = buildTimeline(keyRate: keyRate, macroEvents: macro);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.timelineTitle)),
      body: AppRefreshIndicator(
        onRefresh: () async {
          await ref.read(keyRateProvider.notifier).refresh();
          await ref.read(macroCalendarProvider.notifier).refresh();
        },
        child: items.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    l10n.timelineEmpty,
                    style: TextStyle(color: palette.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (_, i) => _TimelineTile(
                  item: items[i],
                  palette: palette,
                  l10n: l10n,
                ),
              ),
      ),
    );
  }
}

/// Приватный класс [_TimelineTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class _TimelineTile extends StatelessWidget {
/// Создаёт [_TimelineTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  const _TimelineTile({
    required this.item,
    required this.palette,
    required this.l10n,
  });

/// Поле [item] класса [_TimelineTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final TimelineItem item;
/// Поле [palette] класса [_TimelineTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final AppPalette palette;
/// Поле [l10n] класса [_TimelineTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_TimelineTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  @override
  Widget build(BuildContext context) {
    final icon = switch (item.kind) {
      TimelineKind.keyRate => Iconsax.bank,
      TimelineKind.macro => Iconsax.calendar,
      TimelineKind.market => Iconsax.chart,
    };
    final color = switch (item.kind) {
      TimelineKind.keyRate => palette.accent,
      TimelineKind.macro => palette.positive,
      TimelineKind.market => palette.textSecondary,
    };

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
        dense: true,
      ),
    );
  }
}
