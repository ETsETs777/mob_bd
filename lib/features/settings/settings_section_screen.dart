import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import 'settings_sections.dart';

enum SettingsHubSection {
  appearance,
  homeWidget,
  localeNavigation,
  notifications,
  security,
  display,
  apiData,
  sync,
  about,
}

/// Sub-screen одной группы настроек.
class SettingsSectionScreen extends ConsumerWidget {
  const SettingsSectionScreen({
    super.key,
    required this.section,
  });

  final SettingsHubSection section;

  static String titleFor(SettingsHubSection section, AppLocalizations l10n) {
    return switch (section) {
      SettingsHubSection.appearance => l10n.settingsSectionAppearance,
      SettingsHubSection.homeWidget => l10n.homeLayoutTitle,
      SettingsHubSection.localeNavigation => l10n.settingsLanguage,
      SettingsHubSection.notifications => l10n.digestSectionTitle,
      SettingsHubSection.security => l10n.settingsSectionSecurity,
      SettingsHubSection.display => l10n.settingsSectionDisplay,
      SettingsHubSection.apiData => l10n.settingsApiKeysTitle,
      SettingsHubSection.sync => l10n.backupSectionTitle,
      SettingsHubSection.about => l10n.settingsSectionAbout,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(titleFor(section, l10n))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(section),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildSection(SettingsHubSection section) {
    return switch (section) {
      SettingsHubSection.appearance => const SettingsAppearanceSection(),
      SettingsHubSection.homeWidget => const SettingsHomeWidgetSection(),
      SettingsHubSection.localeNavigation =>
        const SettingsLocaleNavigationSection(),
      SettingsHubSection.notifications => const SettingsNotificationsSection(),
      SettingsHubSection.security => const SettingsSecuritySection(),
      SettingsHubSection.display => const SettingsDisplaySection(),
      SettingsHubSection.apiData => const SettingsApiDataSection(),
      SettingsHubSection.sync => const SettingsSyncSection(),
      SettingsHubSection.about => const SettingsAboutSection(),
    };
  }
}
