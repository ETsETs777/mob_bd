import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/motion/app_motion.dart';
import '../../core/navigation/calendar_navigation_intent.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_calendar_provider.dart';
import 'user_calendar_helpers.dart';
import 'user_calendar_screen.dart';

/// Компактная карточка ближайших событий календаря.
class UserCalendarHomeCard extends ConsumerWidget {
  const UserCalendarHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final plan = ref.watch(userCalendarPlanProvider(90));
    final upcoming = plan.upcoming.take(5).toList();

    if (upcoming.isEmpty) {
      return Card(
        child: ListTile(
          leading: Icon(Iconsax.calendar_1, color: palette.accent),
          title: Text(l10n.userCalendarTitle),
          subtitle: Text(l10n.userCalendarEmpty),
          trailing: const Icon(Iconsax.arrow_right_3),
          onTap: () => openAppPage(context, const UserCalendarScreen()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.calendar_1, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.userCalendarTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      openAppPage(context, const UserCalendarScreen()),
                  child: Text(l10n.userCalendarOpenAll),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.userCalendarSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            for (final item in upcoming) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(
                  calendarItemTitle(l10n, item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(DateFormat.MMMd(locale).format(item.date)),
                trailing: item.amount != null
                    ? Text(
                        formatCalendarAmount(item.amount!, item.currency),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: palette.positive,
                          fontSize: 13,
                        ),
                      )
                    : null,
                onTap: () {
                  CalendarNavigationIntent.openPlanItem(item);
                  openAppPage(context, const UserCalendarScreen());
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
