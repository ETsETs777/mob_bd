import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../l10n/app_localizations.dart';
import '../settings/home_server_settings.dart';

/// Аккаунт домашнего сервера EcoPulse.
class ProfileServerScreen extends ConsumerWidget {
  const ProfileServerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHubServerAccount)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.profileHubServerIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Gap(16),
          const HomeServerSettingsCard(),
        ],
      ),
    );
  }
}
