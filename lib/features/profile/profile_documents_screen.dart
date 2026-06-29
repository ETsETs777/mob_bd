import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/utils/share_watchlist_chat.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/profile/home_server_provider.dart';
import '../settings/cloud_sync_settings.dart';
import '../settings/profile_backup_widgets.dart';

class ProfileDocumentsScreen extends ConsumerWidget {
  const ProfileDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final loggedIn = ref.watch(homeServerProvider).auth.isLoggedIn;

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
          const Gap(16),
          Card(
            child: ListTile(
              leading: const Icon(Iconsax.messages_2),
              title: Text(l10n.shareWatchlistToChat),
              subtitle: Text(
                loggedIn
                    ? l10n.shareWatchlistToChatHint
                    : l10n.shareWatchlistToChatNeedServer,
              ),
              enabled: loggedIn,
              onTap: loggedIn
                  ? () async {
                      final ok = await shareWatchlistToSelfChat(
                        ref,
                        locale: l10n.localeName,
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? l10n.shareWatchlistToChatSuccess
                                : l10n.shareWatchlistToChatFailed,
                          ),
                        ),
                      );
                    }
                  : null,
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
