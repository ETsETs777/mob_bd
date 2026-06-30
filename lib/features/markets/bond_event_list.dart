// =============================================================================
// EcoPulse · lib/features/markets/bond_event_list.dart
// Автор: Цымбал Е. В.
// Дата: 08.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: bond_event_list.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/portfolio_calendar_import.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_calendar_provider.dart';
import '../asset_detail/asset_detail_screen.dart';

/// StatelessWidget [BondEventList] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class BondEventList extends StatelessWidget {
/// Создаёт [BondEventList].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const BondEventList({
    super.key,
    required this.events,
    this.showTimeline = false,
  });

/// Поле [events] класса [BondEventList].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final List<BondCalendarEvent> events;
/// Поле [showTimeline] класса [BondEventList].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final bool showTimeline;

/// Отрисовывает UI [BondEventList].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    if (!showTimeline) {
      return Column(
        children: [
          for (final event in events)
            _BondEventTile(event: event, compactLeading: false),
        ],
      );
    }

    final palette = AppPalette.of(context);
    final lineColor = palette.textSecondary.withValues(alpha: 0.25);

    return Column(
      children: [
        for (var i = 0; i < events.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      if (i > 0)
                        Expanded(
                          child: Container(width: 2, color: lineColor),
                        ),
                      _TimelineDot(event: events[i]),
                      if (i < events.length - 1)
                        Expanded(
                          child: Container(width: 2, color: lineColor),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _BondEventTile(event: events[i], compactLeading: true),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Приватный класс [_TimelineDot].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _TimelineDot extends StatelessWidget {
/// Создаёт [_TimelineDot].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const _TimelineDot({required this.event});

/// Поле [event] класса [_TimelineDot].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final BondCalendarEvent event;

/// Отрисовывает UI [_TimelineDot].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isMaturity = event.type == BondCalendarEventType.maturity;
    final color = isMaturity ? palette.negative : palette.positive;

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}

/// Приватный класс [_BondEventTile] — плитка списка.
class _BondEventTile extends ConsumerWidget {
  const _BondEventTile({
    required this.event,
    required this.compactLeading,
  });

  final BondCalendarEvent event;
  final bool compactLeading;

  Future<void> _importToCalendar(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final draft = draftFromBondCalendarEvent(l10n, event);
    await ref.read(userCalendarProvider.notifier).addEvent(
          title: draft.title,
          date: draft.date,
          amount: draft.amount > 0 ? draft.amount : null,
          currency: draft.currency,
          note: draft.note,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.userCalendarImportFromPortfolioDone),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final isMaturity = event.type == BondCalendarEventType.maturity;
    final subtitle = switch (event.type) {
      BondCalendarEventType.maturity => l10n.bondEventMaturity,
      BondCalendarEventType.coupon =>
        event.bond.couponValueRub != null
            ? l10n.bondEventCouponRub(event.note ?? '')
            : l10n.bondEventCouponPercent(event.note ?? ''),
      BondCalendarEventType.couponEstimate =>
        l10n.bondEventCouponEstimate(event.note ?? ''),
    };

    return ListTile(
      contentPadding: EdgeInsets.only(
        left: compactLeading ? 4 : 0,
        right: 0,
      ),
      dense: true,
      leading: compactLeading
          ? null
          : CircleAvatar(
              radius: 16,
              backgroundColor:
                  (isMaturity ? palette.negative : palette.positive)
                      .withValues(alpha: 0.15),
              child: Icon(
                isMaturity ? Iconsax.flag : Iconsax.money_recive,
                size: 16,
                color: isMaturity ? palette.negative : palette.positive,
              ),
            ),
      title: Text(
        event.bond.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: palette.textSecondary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Formatters.date(event.date),
            style: AppTypography.quote(
              TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.userCalendarImportFromPortfolio,
            icon: Icon(Iconsax.calendar_add, size: 18, color: palette.accent),
            onPressed: () => _importToCalendar(context, ref),
          ),
        ],
      ),
      onTap: () => openAppPage(
        context,
        AssetDetailScreen(asset: event.bond),
      ),
    );
  }
}
