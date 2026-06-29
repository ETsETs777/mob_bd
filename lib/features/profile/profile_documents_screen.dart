import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../l10n/app_localizations.dart';
import '../settings/cloud_sync_settings.dart';
import '../settings/profile_backup_widgets.dart';

/// Документы, бэкап и облачная синхронизация.
class ProfileDocumentsScreen extends ConsumerWidget {
  const ProfileDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHubDocuments)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.profileHubDocumentsIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Gap(20),
          const CloudSyncSettingsCard(),
          const Gap(16),
          const BackupSettingsSection(),
        ],
      ),
    );
  }
}
