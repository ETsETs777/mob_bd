import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';



import '../../../core/theme/app_palette.dart';

import '../../../core/utils/home_server_error_message.dart';

import '../../../core/utils/user_local_data_sync_preferences.dart';

import '../../../l10n/app_localizations.dart';

import '../../../providers/home_server_provider.dart';

import '../../../providers/profile/user_local_data_sync_provider.dart';

import 'user_local_data_conflict_dialog.dart';



class UserLocalDataSyncCard extends ConsumerStatefulWidget {

  const UserLocalDataSyncCard({super.key});



  @override

  ConsumerState<UserLocalDataSyncCard> createState() =>

      _UserLocalDataSyncCardState();

}



class _UserLocalDataSyncCardState extends ConsumerState<UserLocalDataSyncCard> {

  bool _wifiOnly = UserLocalDataSyncPreferences.wifiOnly;
  bool _autoPush = UserLocalDataSyncPreferences.autoPushOnChange;



  Future<void> _runSmartSync() async {

    final l10n = AppLocalizations.of(context)!;

    final notifier = ref.read(userLocalDataSyncProvider.notifier);

    final ready = await notifier.prepareSync();

    if (!context.mounted) return;

    if (!ready) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(

            homeServerErrorMessage(

              l10n,

              ref.read(userLocalDataSyncProvider).lastError,

            ),

          ),

          behavior: SnackBarBehavior.floating,

        ),

      );

      return;

    }



    String? resolution;

    if (notifier.isConflict) {

      resolution = await showUserLocalDataConflictDialog(context, l10n);

      if (resolution == null) return;

    }



    final ok = await notifier.applySyncChoice(conflictResolution: resolution);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(

          ok

              ? l10n.userLocalDataSyncDone

              : homeServerErrorMessage(

                  l10n,

                  ref.read(userLocalDataSyncProvider).lastError,

                ),

        ),

        behavior: SnackBarBehavior.floating,

      ),

    );

  }



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final palette = AppPalette.of(context);

    final auth = ref.watch(homeServerProvider).auth;

    final sync = ref.watch(userLocalDataSyncProvider);



    if (!auth.isLoggedIn) {

      return const SizedBox.shrink();

    }



    return Card(

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            Row(

              children: [

                Icon(Iconsax.calendar_tick, color: palette.accent),

                const Gap(8),

                Expanded(

                  child: Text(

                    l10n.userLocalDataSyncTitle,

                    style: TextStyle(

                      fontWeight: FontWeight.w700,

                      color: palette.textPrimary,

                    ),

                  ),

                ),

              ],

            ),

            const Gap(8),

            Text(

              l10n.userLocalDataSyncSubtitle,

              style: TextStyle(color: palette.textSecondary, fontSize: 13),

            ),

            SwitchListTile(

              contentPadding: EdgeInsets.zero,

              title: Text(l10n.userLocalDataSyncWifiOnly),

              subtitle: Text(

                l10n.userLocalDataSyncWifiOnlySubtitle,

                style: TextStyle(color: palette.textSecondary, fontSize: 12),

              ),

              value: _wifiOnly,

              onChanged: (value) async {

                setState(() => _wifiOnly = value);

                await UserLocalDataSyncPreferences.setWifiOnly(value);

              },

            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.userLocalDataSyncAutoPush),
              subtitle: Text(
                l10n.userLocalDataSyncAutoPushSubtitle,
                style: TextStyle(color: palette.textSecondary, fontSize: 12),
              ),
              value: _autoPush,
              onChanged: (value) async {
                setState(() => _autoPush = value);
                await UserLocalDataSyncPreferences.setAutoPushOnChange(value);
              },
            ),
            if (sync.lastSyncedAt != null) ...[

              const Gap(4),

              Text(

                l10n.userLocalDataSyncLast(sync.lastSyncedAt!),

                style: TextStyle(color: palette.textSecondary, fontSize: 12),

              ),

            ],

            if (sync.lastError.isNotEmpty) ...[

              const Gap(8),

              Text(

                homeServerErrorMessage(l10n, sync.lastError),

                style: TextStyle(color: palette.negative, fontSize: 12),

              ),

            ],

            const Gap(12),

            Row(

              children: [

                Expanded(

                  child: OutlinedButton(

                    onPressed: sync.busy

                        ? null

                        : () async {

                            final ok = await ref

                                .read(userLocalDataSyncProvider.notifier)

                                .pullFromServer();

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(

                              SnackBar(

                                content: Text(

                                  ok

                                      ? l10n.userLocalDataSyncPulled

                                      : homeServerErrorMessage(

                                          l10n,

                                          ref.read(userLocalDataSyncProvider)

                                              .lastError,

                                        ),

                                ),

                                behavior: SnackBarBehavior.floating,

                              ),

                            );

                          },

                    child: Text(l10n.userLocalDataSyncPull),

                  ),

                ),

                const Gap(8),

                Expanded(

                  child: FilledButton(

                    onPressed: sync.busy

                        ? null

                        : () async {

                            final ok = await ref

                                .read(userLocalDataSyncProvider.notifier)

                                .pushToServer();

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(

                              SnackBar(

                                content: Text(

                                  ok

                                      ? l10n.userLocalDataSyncPushed

                                      : homeServerErrorMessage(

                                          l10n,

                                          ref.read(userLocalDataSyncProvider)

                                              .lastError,

                                        ),

                                ),

                                behavior: SnackBarBehavior.floating,

                              ),

                            );

                          },

                    child: sync.busy

                        ? const SizedBox(

                            width: 18,

                            height: 18,

                            child: CircularProgressIndicator(strokeWidth: 2),

                          )

                        : Text(l10n.userLocalDataSyncPush),

                  ),

                ),

              ],

            ),

            const Gap(8),

            TextButton(

              onPressed: sync.busy ? null : _runSmartSync,

              child: Text(l10n.userLocalDataSyncSmart),

            ),

          ],

        ),

      ),

    );

  }

}


