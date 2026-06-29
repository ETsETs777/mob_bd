import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app/overnight_changes_provider.dart';
import '../shared/widgets/glass_card.dart';

class OvernightChangesCard extends ConsumerWidget {
  const OvernightChangesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brief = ref.watch(overnightBriefProvider);
    if (brief == null || !brief.hasChanges) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final hours = DateTime.now().difference(brief.savedAt).inHours.clamp(1, 999);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.moon, size: 20, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.overnightChangesTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        l10n.overnightChangesSince(hours),
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(12),
            ...brief.changes.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      Formatters.percent(c.changePercent),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: c.changePercent >= 0
                            ? palette.positive
                            : palette.negative,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
