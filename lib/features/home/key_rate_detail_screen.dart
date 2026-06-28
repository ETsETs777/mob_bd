// =============================================================================
// EcoPulse · lib/features/home/key_rate_detail_screen.dart
// Автор: Цымбал Е. В.
// Дата: 05.06.2026
// Главный экран и виджеты секций. Файл: key_rate_detail_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/chart_events.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/price_point.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/charts.dart';

/// StatelessWidget [KeyRateDetailScreen] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class KeyRateDetailScreen extends StatelessWidget {
/// Создаёт [KeyRateDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const KeyRateDetailScreen({super.key, required this.snapshot});

/// Поле [snapshot] класса [KeyRateDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final KeyRateSnapshot snapshot;

/// Отрисовывает UI [KeyRateDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final history = snapshot.history;
    final points = history
        .map((p) => PricePoint(date: p.date, value: p.rate))
        .toList();
    final events = keyRateChangeEvents(
      dates: history.map((p) => p.date).toList(),
      rates: history.map((p) => p.rate).toList(),
    );
    final dateFmt = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.keyRateDetailTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${snapshot.current.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: palette.accent,
                ),
          ),
          Text(
            l10n.keyRateUpdated(dateFmt.format(snapshot.updatedAt)),
            style: TextStyle(color: palette.textSecondary),
          ),
          const Gap(20),
          LineChartWidget(
            points: points,
            height: 260,
            eventMarkers: events,
            valueSuffix: '%',
          ),
          const Gap(24),
          Text(
            l10n.keyRateEventsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          if (events.isEmpty)
            Text(
              l10n.keyRateEventsEmpty,
              style: TextStyle(color: palette.textSecondary),
            )
          else
            ...events.reversed.map(
              (event) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Iconsax.flash_1, color: palette.accent, size: 18),
                title: Text(
                  l10n.keyRateEventChange(
                    dateFmt.format(event.date),
                    event.label,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
