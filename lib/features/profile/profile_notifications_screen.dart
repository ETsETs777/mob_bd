import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/cloud/fcm_config.dart';
import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/morning_digest_provider.dart';
import '../../providers/messages/message_push_provider.dart';
import '../../providers/home_server_provider.dart';
import '../alerts/price_alerts_screen.dart';

/// Уведомления: утренний дайджест и ценовые алерты.
class ProfileNotificationsScreen extends ConsumerWidget {
  const ProfileNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final digest = ref.watch(morningDigestProvider);
    final messagePush = ref.watch(messagePushProvider);
    final serverAuth = ref.watch(homeServerProvider).auth;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHubNotifications)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(Iconsax.sun_1, color: palette.accent),
                    title: Text(
                      l10n.digestMorningTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      l10n.digestSectionTitle,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    value: digest.enabled,
                    onChanged: (v) =>
                        ref.read(morningDigestProvider.notifier).setEnabled(v),
                  ),
                  if (digest.enabled) ...[
                    const Divider(height: 24),
                    Row(
                      children: [
                        Icon(Iconsax.clock, color: palette.accent, size: 22),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            l10n.digestMorningHour,
                            style: TextStyle(color: palette.textPrimary),
                          ),
                        ),
                        DropdownButton<int>(
                          value: digest.hour,
                          items: List.generate(6, (i) => i + 6)
                              .map(
                                (h) => DropdownMenuItem(
                                  value: h,
                                  child: Text('$h:00'),
                                ),
                              )
                              .toList(),
                          onChanged: (h) {
                            if (h != null) {
                              ref
                                  .read(morningDigestProvider.notifier)
                                  .setHour(h);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Gap(12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(Iconsax.message, color: palette.accent),
                    title: Text(
                      l10n.messagePushTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      serverAuth.isLoggedIn
                          ? l10n.messagePushSubtitle
                          : l10n.messagePushRequiresServer,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    value: messagePush.enabled && serverAuth.isLoggedIn,
                    onChanged: !serverAuth.isLoggedIn
                        ? null
                        : (v) => ref
                            .read(messagePushProvider.notifier)
                            .setEnabled(v),
                  ),
                  if (FcmConfig.isConfigured && serverAuth.isLoggedIn) ...[
                    const Gap(4),
                    Text(
                      l10n.messagePushFcmReady,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Gap(12),
          Card(
            child: ListTile(
              leading: Icon(Iconsax.notification, color: palette.accent),
              title: Text(
                l10n.alertsTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              subtitle: Text(
                l10n.alertsSettingsSubtitle,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 13,
                ),
              ),
              trailing: Icon(Iconsax.arrow_right_3,
                  color: palette.textSecondary, size: 18),
              onTap: () => openAppPage(context, const PriceAlertsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
