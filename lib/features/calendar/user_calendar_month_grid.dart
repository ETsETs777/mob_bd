import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/user_calendar_plan.dart';

/// Даты (без времени) с событиями календаря.
Set<DateTime> eventDatesFromPlan(UserCalendarPlan plan) {
  return plan.events
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet();
}

/// Компактная сетка месяца с точками на днях с событиями.
class UserCalendarMonthGrid extends StatefulWidget {
  const UserCalendarMonthGrid({
    super.key,
    required this.eventDates,
    required this.locale,
    this.onDaySelected,
  });

  final Set<DateTime> eventDates;
  final String locale;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  State<UserCalendarMonthGrid> createState() => _UserCalendarMonthGridState();
}

class _UserCalendarMonthGridState extends State<UserCalendarMonthGrid> {
  late DateTime _month;
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selected = DateTime(now.year, now.month, now.day);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final monthLabel = MaterialLocalizations.of(context).formatMonthYear(_month);
    final weekdayLabels = _weekdayLabels(context);

    final firstDay = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final startOffset = (firstDay.weekday + 6) % 7;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _shiftMonth(-1),
                ),
                Expanded(
                  child: Text(
                    monthLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _shiftMonth(1),
                ),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                for (final label in weekdayLabels)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(6),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: startOffset + daysInMonth,
              itemBuilder: (context, index) {
                if (index < startOffset) return const SizedBox.shrink();
                final day = index - startOffset + 1;
                final date = DateTime(_month.year, _month.month, day);
                final hasEvent = widget.eventDates.contains(date);
                final isSelected = _selected == date;
                final isToday = _isSameDay(date, DateTime.now());

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() => _selected = date);
                    widget.onDaySelected?.call(date);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? palette.accent.withValues(alpha: 0.2)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(color: palette.accent, width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: palette.textPrimary,
                          ),
                        ),
                        if (hasEvent)
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: palette.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> _weekdayLabels(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    return List.generate(
      7,
      (i) {
        final weekday = DateTime.monday + i;
        return material.narrowWeekdays[weekday - 1];
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
