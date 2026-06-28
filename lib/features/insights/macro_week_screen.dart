// =============================================================================
// EcoPulse · lib/features/insights/macro_week_screen.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Экран «Макро-неделя»: brief, ставка ЦБ и macro-события на 7 дней.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/macro_week.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/commodities_provider.dart';
import '../../providers/news_provider.dart';
import '../home/economic_brief.dart';
import '../shared/widgets/app_card.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/loading_skeleton.dart';
import 'macro_calendar_screen.dart';
import 'timeline_screen.dart';

/// Экран сводки макро-событий на ближайшие 7 дней.
class MacroWeekScreen extends ConsumerWidget {
  const MacroWeekScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    final keyRate = ref.watch(keyRateProvider);
    final macro = ref.watch(macroCalendarProvider);
    final rates = ref.watch(currencyRatesProvider).valueOrNull;
    final crypto = ref.watch(cryptoProvider).valueOrNull?.assets;
    final stocks = ref.watch(stocksProvider).valueOrNull;
    final commodities = ref.watch(commoditiesProvider).valueOrNull;
    final fearGreed = ref.watch(fearGreedProvider).valueOrNull;

    final briefLines = buildEconomicBrief(
      rates: rates,
      keyRate: keyRate.valueOrNull,
      crypto: crypto,
      stocks: stocks,
      commodities: commodities,
      fearGreed: fearGreed,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.macroWeekTitle),
        actions: [
          IconButton(
            tooltip: l10n.timelineTitle,
            icon: const Icon(Iconsax.activity),
            onPressed: () => openAppPage(context, const TimelineScreen()),
          ),
          IconButton(
            tooltip: l10n.macroCalendarTitle,
            icon: const Icon(Iconsax.calendar),
            onPressed: () => openAppPage(context, const MacroCalendarScreen()),
          ),
        ],
      ),
      body: AppRefreshIndicator(
        onRefresh: () async {
          await ref.read(keyRateProvider.notifier).refresh();
          await ref.read(macroCalendarProvider.notifier).refresh();
          await ref.read(currencyRatesProvider.notifier).refresh();
          await ref.read(cryptoProvider.notifier).refresh();
          await ref.read(stocksProvider.notifier).refresh();
          await ref.read(commoditiesProvider.notifier).refresh();
          await ref.read(fearGreedProvider.notifier).refresh();
        },
        child: macro.when(
          data: (events) {
            final plan = buildMacroWeekPlan(
              macroEvents: events,
              keyRate: keyRate.valueOrNull,
            );
            return _MacroWeekBody(
              plan: plan,
              briefLines: briefLines,
              palette: palette,
              l10n: l10n,
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: ShimmerCard(),
          ),
          error: (_, __) {
            final plan = buildMacroWeekPlan(
              keyRate: keyRate.valueOrNull,
            );
            return _MacroWeekBody(
              plan: plan,
              briefLines: briefLines,
              palette: palette,
              l10n: l10n,
            );
          },
        ),
      ),
    );
  }
}

/// Открывает экран [MacroWeekScreen].
Future<void> openMacroWeekScreen(BuildContext context) {
  return openAppPage<void>(context, const MacroWeekScreen());
}

class _MacroWeekBody extends StatelessWidget {
  const _MacroWeekBody({
    required this.plan,
    required this.briefLines,
    required this.palette,
    required this.l10n,
  });

  final MacroWeekPlan plan;
  final List<BriefLine> briefLines;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final range = l10n.macroWeekRange(
      _formatDay(plan.weekStart),
      _formatDay(plan.weekEnd),
    );
    final stats = l10n.macroWeekStats(
      plan.totalMacroEvents,
      plan.daysWithEvents,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          range,
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 13,
          ),
        ),
        const Gap(4),
        Text(
          stats,
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (briefLines.isNotEmpty) ...[
          const Gap(16),
          _BriefSection(lines: briefLines, palette: palette, l10n: l10n),
        ],
        const Gap(16),
        ...plan.days.map(
          (day) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DaySection(day: day, palette: palette, l10n: l10n),
          ),
        ),
      ],
    );
  }

  String _formatDay(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';
}

class _BriefSection extends StatelessWidget {
  const _BriefSection({
    required this.lines,
    required this.palette,
    required this.l10n,
  });

  final List<BriefLine> lines;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.flash_1, size: 18, color: palette.accent),
              const Gap(8),
              Text(
                l10n.macroWeekBriefTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          const Gap(12),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      line.label,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line.text,
                      style: TextStyle(
                        color: _lineColor(palette, line),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _lineColor(AppPalette palette, BriefLine line) {
    if (line.isPositive == null) return palette.textPrimary;
    return line.isPositive! ? palette.positive : palette.negative;
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.day,
    required this.palette,
    required this.l10n,
  });

  final MacroWeekDaySection day;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdayLabel(day.date.weekday, l10n);
    final dateStr =
        '${day.date.day.toString().padLeft(2, '0')}.${day.date.month.toString().padLeft(2, '0')}';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$weekday · $dateStr',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              if (day.isToday) ...[
                const Gap(8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: palette.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.macroWeekToday,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: palette.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const Gap(10),
          if (day.events.isEmpty)
            Text(
              l10n.macroWeekEmptyDay,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            )
          else
            ...day.events.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _EventRow(event: event, palette: palette, l10n: l10n),
              ),
            ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday, AppLocalizations l10n) {
    return switch (weekday) {
      DateTime.monday => l10n.macroWeekMon,
      DateTime.tuesday => l10n.macroWeekTue,
      DateTime.wednesday => l10n.macroWeekWed,
      DateTime.thursday => l10n.macroWeekThu,
      DateTime.friday => l10n.macroWeekFri,
      DateTime.saturday => l10n.macroWeekSat,
      _ => l10n.macroWeekSun,
    };
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.event,
    required this.palette,
    required this.l10n,
  });

  final MacroWeekEventItem event;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isKeyRate = event.kind == MacroWeekEventKind.keyRate;
    final title = isKeyRate
        ? l10n.macroWeekKeyRateToday
        : event.title;
    final subtitle = isKeyRate && event.subtitle != null
        ? '${event.subtitle}%'
        : event.subtitle;

    final impactColor = switch (event.impact?.toLowerCase()) {
      'high' => palette.negative,
      'medium' => palette.accent,
      _ => palette.textSecondary,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isKeyRate ? Iconsax.bank : Iconsax.global,
          size: 16,
          color: isKeyRate ? palette.accent : palette.textSecondary,
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                  fontSize: 13,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        if (event.impact != null)
          Icon(Iconsax.flash_1, size: 14, color: impactColor),
      ],
    );
  }
}
