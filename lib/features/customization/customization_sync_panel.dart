import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/motion/app_motion.dart';
import '../../core/customization/customization_cloud_sync.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization/customization_server_sync_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/home_server_provider.dart';
import '../profile/profile_server_screen.dart';

/// Панель синхронизации кастомизации с home server (LAN).
class CustomizationSyncPanel extends ConsumerStatefulWidget {
  const CustomizationSyncPanel({super.key});

  @override
  ConsumerState<CustomizationSyncPanel> createState() =>
      _CustomizationSyncPanelState();
}

class _CustomizationSyncPanelState extends ConsumerState<CustomizationSyncPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customizationServerSyncProvider.notifier).refreshRemote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final home = ref.watch(homeServerProvider);
    final sync = ref.watch(customizationServerSyncProvider);
    final local = ref.watch(customizationProvider);
    final status = ref.read(customizationServerSyncProvider.notifier).status(local);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat('d MMM yyyy · HH:mm', locale);

    final statusText = switch (status) {
      CustomizationServerSyncStatus.notLoggedIn =>
        l10n.customizationSyncNotLoggedIn,
      CustomizationServerSyncStatus.neverSynced =>
        l10n.customizationSyncNever,
      CustomizationServerSyncStatus.synced => l10n.customizationSyncSynced,
      CustomizationServerSyncStatus.localNewer =>
        l10n.customizationSyncLocalNewer,
      CustomizationServerSyncStatus.remoteNewer =>
        l10n.customizationSyncRemoteNewer,
      CustomizationServerSyncStatus.remoteMissing =>
        l10n.customizationSyncRemoteMissing,
    };

    final statusColor = switch (status) {
      CustomizationServerSyncStatus.synced => palette.positive,
      CustomizationServerSyncStatus.notLoggedIn => palette.textSecondary,
      CustomizationServerSyncStatus.neverSynced => palette.textSecondary,
      CustomizationServerSyncStatus.remoteMissing => palette.textSecondary,
      _ => palette.accent,
    };

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.scaled(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.cloud_connection, size: 22, color: palette.accent),
                const Gap(10),
                Expanded(
                  child: Text(
                    l10n.customizationSyncTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.customizationSyncSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      fontSize: 13,
                    ),
                  ),
                  if (sync.meta.lastPushAt != null) ...[
                    const Gap(4),
                    Text(
                      l10n.customizationSyncLastPush(
                        dateFmt.format(sync.meta.lastPushAt!.toLocal()),
                      ),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (sync.meta.lastPullAt != null) ...[
                    const Gap(2),
                    Text(
                      l10n.customizationSyncLastPull(
                        dateFmt.format(sync.meta.lastPullAt!.toLocal()),
                      ),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (sync.lastError.isNotEmpty &&
                      status != CustomizationServerSyncStatus.notLoggedIn) ...[
                    const Gap(4),
                    Text(
                      l10n.customizationSyncError(sync.lastError),
                      style: TextStyle(color: palette.negative, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(12),
            if (!home.auth.isLoggedIn) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    openAppPage(context, const ProfileServerScreen());
                  },
                  icon: const Icon(Iconsax.login, size: 18),
                  label: Text(l10n.customizationSyncOpenServer),
                ),
              ),
            ] else ...[
              if (sync.busy)
                const Center(child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ))
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _smartSync(context, l10n),
                    icon: const Icon(Iconsax.refresh, size: 18),
                    label: Text(l10n.customizationSyncSmart),
                  ),
                ),
                const Gap(8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _push(context, l10n),
                        icon: const Icon(Iconsax.export_1, size: 18),
                        label: Text(l10n.customizationSyncPush),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pull(context, l10n),
                        icon: const Icon(Iconsax.import_1, size: 18),
                        label: Text(l10n.customizationSyncPull),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _smartSync(BuildContext context, AppLocalizations l10n) async {
    final ok =
        await ref.read(customizationServerSyncProvider.notifier).smartSync(ref);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.customizationSyncDone : l10n.customizationSyncFailed,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _push(BuildContext context, AppLocalizations l10n) async {
    final ok =
        await ref.read(customizationServerSyncProvider.notifier).pushToServer(ref);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.customizationSyncPushDone : l10n.customizationSyncFailed,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pull(BuildContext context, AppLocalizations l10n) async {
    final ok =
        await ref.read(customizationServerSyncProvider.notifier).pullFromServer(ref);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.customizationSyncPullDone : l10n.customizationSyncFailed,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
