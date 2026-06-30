import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/utils/home_server_error_message.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/home_server_provider.dart';
import '../../../providers/messages_provider.dart';
import '../../../providers/user_profile_provider.dart';

class HomeServerSettingsCard extends ConsumerStatefulWidget {
  const HomeServerSettingsCard({super.key});

  @override
  ConsumerState<HomeServerSettingsCard> createState() =>
      _HomeServerSettingsCardState();
}

class _HomeServerSettingsCardState extends ConsumerState<HomeServerSettingsCard> {
  late final TextEditingController _urlController;
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;
  late final TextEditingController _displayNameController;
  bool _registerMode = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(homeServerProvider).auth;
    _urlController = TextEditingController(text: auth.serverUrl);
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _displayNameController = TextEditingController(
      text: ref.read(userProfileProvider).displayName,
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  String _errorText(AppLocalizations l10n, String code) =>
      homeServerErrorMessage(l10n, code);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final server = ref.watch(homeServerProvider);
    final auth = server.auth;

    final statusColor = switch (server.online) {
      HomeServerOnlineStatus.online => palette.positive,
      HomeServerOnlineStatus.offline => palette.negative,
      HomeServerOnlineStatus.unknown => palette.textSecondary,
    };

    final statusLabel = switch (server.online) {
      HomeServerOnlineStatus.online => l10n.homeServerStatusOnline,
      HomeServerOnlineStatus.offline => l10n.homeServerStatusOffline,
      HomeServerOnlineStatus.unknown => l10n.homeServerStatusUnknown,
    };

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
                    l10n.homeServerTitle,
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
              l10n.homeServerSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.homeServerUrlLabel,
                hintText: l10n.homeServerUrlHint,
              ),
              keyboardType: TextInputType.url,
              enabled: !server.busy,
              onChanged: (v) => ref.read(homeServerProvider.notifier).setServerUrl(v),
            ),
            const Gap(4),
            Text(
              l10n.homeServerIpHint,
              style: TextStyle(color: palette.textSecondary, fontSize: 11),
            ),
            const Gap(12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Gap(8),
                if (auth.serverVersion.isNotEmpty)
                  Text(
                    'v${auth.serverVersion}',
                    style: TextStyle(color: palette.textSecondary, fontSize: 12),
                  ),
              ],
            ),
            const Gap(12),
            OutlinedButton.icon(
              onPressed: server.busy
                  ? null
                  : () async {
                      await ref.read(homeServerProvider.notifier).checkHealth();
                    },
              icon: const Icon(Iconsax.refresh),
              label: Text(l10n.homeServerCheckConnection),
            ),
            if (server.lastError.isNotEmpty) ...[
              const Gap(8),
              Text(
                _errorText(l10n, server.lastError),
                style: TextStyle(color: palette.negative, fontSize: 12),
              ),
            ],
            if (auth.isLoggedIn) ...[
              const Gap(16),
              _ProfileIdRow(profileId: auth.profileId, palette: palette, l10n: l10n),
              const Gap(8),
              Text(
                l10n.homeServerLoggedInAs(auth.login),
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: server.busy
                          ? null
                          : () async {
                              await ref.read(homeServerProvider.notifier).logout();
                              ref.read(messagesProvider.notifier).clearOnLogout();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.homeServerLoggedOut)),
                                );
                              }
                            },
                      child: Text(l10n.homeServerLogout),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: FilledButton(
                      onPressed: server.busy
                          ? null
                          : () async {
                              await ref.read(homeServerProvider.notifier).logout();
                              ref.read(messagesProvider.notifier).clearOnLogout();
                              setState(() {
                                _registerMode = false;
                                _loginController.clear();
                                _passwordController.clear();
                              });
                            },
                      child: Text(l10n.homeServerSwitchAccount),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              OutlinedButton.icon(
                onPressed: server.busy
                    ? null
                    : () async {
                        await ref.read(messagesProvider.notifier).ensureSelfThread();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.homeServerSelfChatReady)),
                          );
                        }
                      },
                icon: const Icon(Iconsax.message),
                label: Text(l10n.homeServerEnsureSelfChat),
              ),
            ] else ...[
              const Gap(16),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(l10n.homeServerLogin)),
                  ButtonSegment(value: true, label: Text(l10n.homeServerRegister)),
                ],
                selected: {_registerMode},
                onSelectionChanged: server.busy
                    ? null
                    : (s) => setState(() => _registerMode = s.first),
              ),
              const Gap(12),
              if (_registerMode)
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(labelText: l10n.profileDisplayName),
                  enabled: !server.busy,
                ),
              if (_registerMode) const Gap(12),
              TextField(
                controller: _loginController,
                decoration: InputDecoration(labelText: l10n.homeServerLoginLabel),
                enabled: !server.busy,
              ),
              const Gap(12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: l10n.homeServerPasswordLabel,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                enabled: !server.busy,
              ),
              const Gap(12),
              FilledButton(
                onPressed: server.busy
                    ? null
                    : () async {
                        final ok = await ref.read(homeServerProvider.notifier).checkHealth();
                        if (!ok || !context.mounted) return;

                        final notifier = ref.read(homeServerProvider.notifier);
                        final success = _registerMode
                            ? await notifier.register(
                                login: _loginController.text,
                                password: _passwordController.text,
                                displayName: _displayNameController.text,
                              )
                            : await notifier.login(
                                login: _loginController.text,
                                password: _passwordController.text,
                              );

                        if (!context.mounted) return;
                        if (success) {
                          await ref.read(messagesProvider.notifier).ensureSelfThread();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _registerMode
                                    ? l10n.homeServerRegisterSuccess
                                    : l10n.homeServerLoginSuccess,
                              ),
                            ),
                          );
                        }
                      },
                child: server.busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _registerMode ? l10n.homeServerRegister : l10n.homeServerLogin,
                      ),
              ),
              const Gap(8),
              OutlinedButton(
                onPressed: server.busy
                    ? null
                    : () async {
                        _loginController.text = 'test2';
                        _passwordController.text = 'test2pass';
                        _displayNameController.text = 'Test 2';
                        setState(() => _registerMode = true);
                        await ref.read(homeServerProvider.notifier).checkHealth();
                        final ok = await ref.read(homeServerProvider.notifier).register(
                              login: 'test2',
                              password: 'test2pass',
                              displayName: 'Test 2',
                            );
                        if (context.mounted && ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.homeServerTestAccountCreated)),
                          );
                        }
                      },
                child: Text(l10n.homeServerCreateTestAccount),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileIdRow extends StatelessWidget {
  const _ProfileIdRow({
    required this.profileId,
    required this.palette,
    required this.l10n,
  });

  final String profileId;
  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeServerProfileId,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const Gap(4),
                Text(
                  profileId,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.homeServerCopyProfileId,
            icon: Icon(Iconsax.copy, size: 18, color: palette.accent),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: profileId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.homeServerProfileIdCopied)),
              );
            },
          ),
        ],
      ),
    );
  }
}
