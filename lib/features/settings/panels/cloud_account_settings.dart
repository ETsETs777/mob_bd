import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/cloud/cloud_config.dart';
import '../../../core/utils/user_error_message.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/cloud/cloud_auth_provider.dart';
import '../../../providers/cloud/cloud_data_sync_provider.dart';

class CloudAccountSettingsCard extends ConsumerStatefulWidget {
  const CloudAccountSettingsCard({super.key});

  @override
  ConsumerState<CloudAccountSettingsCard> createState() =>
      _CloudAccountSettingsCardState();
}

class _CloudAccountSettingsCardState
    extends ConsumerState<CloudAccountSettingsCard> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _registerMode = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showSnack(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final auth = ref.watch(cloudAuthProvider);
    final sync = ref.watch(cloudDataSyncProvider);

    if (!CloudConfig.isConfigured) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.cloud_add, size: 22, color: palette.textSecondary),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      l10n.cloudAccountTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                l10n.cloudAccountNotConfigured,
                style: TextStyle(color: palette.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (auth.isSignedIn) {
      final syncedLabel = sync.lastSyncedAt == null
          ? l10n.cloudSyncNever
          : l10n.cloudSyncLastAt(
              DateFormat.yMMMd().add_Hm().format(sync.lastSyncedAt!.toLocal()),
            );

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.cloud, size: 22, color: palette.accent),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      l10n.cloudAccountTitle,
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
                l10n.cloudAccountSubtitle,
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              ),
              const Gap(12),
              Text(
                l10n.cloudLoggedInAs(auth.email),
                style: TextStyle(color: palette.textPrimary),
              ),
              const Gap(4),
              Text(syncedLabel, style: TextStyle(color: palette.textSecondary)),
              if (sync.error.isNotEmpty) ...[
                const Gap(8),
                Text(
                  userErrorMessage(sync.error, l10n: l10n),
                  style: TextStyle(color: palette.negative),
                ),
              ],
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: sync.busy || auth.busy
                          ? null
                          : () async {
                              HapticFeedback.lightImpact();
                              final ok = await ref
                                  .read(cloudDataSyncProvider.notifier)
                                  .push(ref);
                              if (!mounted) return;
                              await _showSnack(
                                ok
                                    ? l10n.cloudSyncPushSuccess
                                    : l10n.cloudSyncFailed,
                              );
                            },
                      icon: sync.busy
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Iconsax.export_1, size: 18),
                      label: Text(l10n.cloudSyncPush),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: sync.busy || auth.busy
                          ? null
                          : () async {
                              HapticFeedback.lightImpact();
                              final ok = await ref
                                  .read(cloudDataSyncProvider.notifier)
                                  .pull(ref);
                              if (!mounted) return;
                              await _showSnack(
                                ok
                                    ? l10n.cloudSyncPullSuccess
                                    : l10n.cloudSyncFailed,
                              );
                            },
                      icon: const Icon(Iconsax.import_1, size: 18),
                      label: Text(l10n.cloudSyncPull),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: auth.busy
                      ? null
                      : () async {
                          await ref.read(cloudAuthProvider.notifier).signOut();
                          if (!mounted) return;
                          await _showSnack(l10n.cloudLoggedOut);
                        },
                  child: Text(l10n.cloudLogout),
                ),
              ),
            ],
          ),
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
                Icon(Iconsax.cloud, size: 22, color: palette.accent),
                const Gap(10),
                Expanded(
                  child: Text(
                    l10n.cloudAccountTitle,
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
              l10n.cloudAccountSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l10n.cloudEmailLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const Gap(12),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: l10n.cloudPasswordLabel,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            if (auth.error.isNotEmpty) ...[
              const Gap(8),
              Text(
                userErrorMessage(auth.error, l10n: l10n),
                style: TextStyle(color: palette.negative),
              ),
            ],
            const Gap(16),
            FilledButton(
              onPressed: auth.busy
                  ? null
                  : () async {
                      HapticFeedback.lightImpact();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;
                      final ok = _registerMode
                          ? await ref.read(cloudAuthProvider.notifier).signUpWithEmail(
                                email: email,
                                password: password,
                              )
                          : await ref.read(cloudAuthProvider.notifier).signInWithEmail(
                                email: email,
                                password: password,
                              );
                      if (!mounted) return;
                      if (ok) {
                        await _showSnack(
                          _registerMode
                              ? l10n.cloudRegisterSuccess
                              : l10n.cloudLoginSuccess,
                        );
                      }
                    },
              child: auth.busy
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text(_registerMode ? l10n.cloudRegister : l10n.cloudLogin),
            ),
            const Gap(8),
            OutlinedButton.icon(
              onPressed: auth.busy
                  ? null
                  : () async {
                      HapticFeedback.lightImpact();
                      await ref.read(cloudAuthProvider.notifier).signInWithGoogle();
                    },
              icon: const Icon(Iconsax.google, size: 18),
              label: Text(l10n.cloudSignInGoogle),
            ),
            const Gap(8),
            TextButton(
              onPressed: () => setState(() => _registerMode = !_registerMode),
              child: Text(
                _registerMode ? l10n.cloudSwitchToLogin : l10n.cloudSwitchToRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
