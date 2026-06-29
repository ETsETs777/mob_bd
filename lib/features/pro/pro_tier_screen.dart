import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/pro/pro_limits.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/pro_tier_provider.dart';

class ProTierScreen extends ConsumerWidget {
  const ProTierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final isPro = ref.watch(proTierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.proTierTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPro ? Iconsax.crown_1 : Iconsax.crown,
                        color: palette.accent,
                        size: 28,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          isPro ? l10n.proTierActiveTitle : l10n.proTierFreeTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Text(
                    l10n.proTierSubtitle,
                    style: TextStyle(color: palette.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const Gap(12),
          _BenefitRow(
            icon: Iconsax.notification,
            title: l10n.proBenefitAlertsTitle,
            subtitle: isPro
                ? l10n.proBenefitAlertsPro
                : l10n.proBenefitAlertsFree(ProLimits.freeMaxAlerts),
            palette: palette,
          ),
          _BenefitRow(
            icon: Iconsax.chart_21,
            title: l10n.proBenefitChartsTitle,
            subtitle: l10n.proBenefitChartsSub,
            palette: palette,
          ),
          _BenefitRow(
            icon: Iconsax.export_3,
            title: l10n.proBenefitExportTitle,
            subtitle: l10n.proBenefitExportSub,
            palette: palette,
          ),
          if (!isPro) ...[
            const Gap(16),
            Text(
              l10n.proTierComingSoon,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.palette,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: palette.accent),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: palette.textSecondary)),
      ),
    );
  }
}
