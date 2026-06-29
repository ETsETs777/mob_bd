import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../customization/customization_screen.dart';
import 'settings_section_screen.dart';

/// Hub настроек: навигация по группам sub-screens.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _sections = SettingsHubSection.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsHubSubtitle,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
          ),
          const Gap(16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(Iconsax.brush_2, color: palette.accent),
              title: Text(
                l10n.customizationSettingsEntry,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              subtitle: Text(
                l10n.customizationSettingsEntrySubtitle,
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              ),
              trailing: Icon(
                Iconsax.arrow_right_3,
                color: palette.textSecondary,
                size: 18,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CustomizationScreen(),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
          const Gap(16),
          Text(
            l10n.settingsHubGroupsTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const Gap(8),
          ..._sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(_iconFor(section), color: palette.accent),
                  title: Text(
                    SettingsSectionScreen.titleFor(section, l10n),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: palette.textSecondary,
                    size: 18,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SettingsSectionScreen(section: section),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }

  static IconData _iconFor(SettingsHubSection section) => switch (section) {
        SettingsHubSection.appearance => Iconsax.colorfilter,
        SettingsHubSection.homeWidget => Iconsax.home_2,
        SettingsHubSection.localeNavigation => Iconsax.global,
        SettingsHubSection.notifications => Iconsax.notification,
        SettingsHubSection.security => Iconsax.shield_tick,
        SettingsHubSection.display => Iconsax.money,
        SettingsHubSection.apiData => Iconsax.key,
        SettingsHubSection.sync => Iconsax.cloud,
        SettingsHubSection.about => Iconsax.info_circle,
      };
}
