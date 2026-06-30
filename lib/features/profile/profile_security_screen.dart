import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/accent_gradients.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/security_provider.dart';
import '../auth/pin_setup_screen.dart';

/// Экран безопасности: PIN, биометрия, блокировка.
class ProfileSecurityScreen extends ConsumerWidget {
  const ProfileSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final security = ref.watch(securitySettingsProvider);
    final biometricAvailable = ref.watch(biometricAvailableProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHubSecurity)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SecurityHero(palette: palette, l10n: l10n, security: security),
          const Gap(20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(Iconsax.lock, color: palette.accent),
                    title: Text(
                      l10n.settingsPinCode,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      security.pinEnabled
                          ? l10n.settingsPinEnabled
                          : l10n.settingsPinDisabled,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    value: security.pinEnabled,
                    onChanged: (enabled) async {
                      if (enabled) {
                        await openAppPage<bool>(
                          context,
                          const PinSetupScreen(mode: PinSetupMode.create),
                        );
                      } else {
                        await openAppPage<bool>(
                          context,
                          const PinSetupScreen(mode: PinSetupMode.disable),
                        );
                      }
                    },
                  ),
                  if (security.pinEnabled) ...[
                    const Divider(height: 24),
                    biometricAvailable.when(
                      data: (available) {
                        if (!available) return const SizedBox.shrink();
                        return SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          secondary:
                              Icon(Iconsax.finger_scan, color: palette.accent),
                          title: Text(
                            l10n.settingsBiometric,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: palette.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            l10n.settingsBiometricSubtitle,
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          value: security.biometricEnabled,
                          onChanged: (enabled) async {
                            if (enabled) {
                              final ok = await ref
                                  .read(biometricAuthServiceProvider)
                                  .authenticate(reason: l10n.pinUseBiometric);
                              if (!ok || !context.mounted) return;
                            }
                            await ref
                                .read(securitySettingsProvider.notifier)
                                .setBiometricEnabled(enabled);
                          },
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const Divider(height: 24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:
                          Icon(Iconsax.password_check, color: palette.accent),
                      title: Text(
                        l10n.settingsChangePin,
                        style: TextStyle(color: palette.textPrimary),
                      ),
                      trailing: Icon(Iconsax.arrow_right_3,
                          color: palette.textSecondary, size: 18),
                      onTap: () => openAppPage(
                        context,
                        const PinSetupScreen(
                          mode: PinSetupMode.change,
                          oldPinRequired: true,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:
                          Icon(Iconsax.logout, color: palette.textSecondary),
                      title: Text(
                        l10n.settingsLockNow,
                        style: TextStyle(color: palette.textPrimary),
                      ),
                      onTap: () {
                        ref.read(appUnlockedProvider.notifier).lock();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.settingsLockedSnack),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityHero extends StatelessWidget {
  const _SecurityHero({
    required this.palette,
    required this.l10n,
    required this.security,
  });

  final AppPalette palette;
  final AppLocalizations l10n;
  final SecuritySettings security;

  @override
  Widget build(BuildContext context) {
    final protected = security.pinEnabled;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: protected
              ? accentCardGradient(palette)
              : [palette.surfaceLight, palette.surface],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            protected ? Iconsax.shield_tick : Iconsax.shield_cross,
            color: protected ? Colors.white : palette.textSecondary,
            size: 36,
          ),
          const Gap(12),
          Text(
            protected ? l10n.profileHubSecurityActive : l10n.profileHubSecurityInactive,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: protected ? Colors.white : palette.textPrimary,
            ),
          ),
          const Gap(6),
          Text(
            protected
                ? l10n.profileHubSecurityActiveSub
                : l10n.profileHubSecurityInactiveSub,
            style: TextStyle(
              fontSize: 13,
              color: protected
                  ? Colors.white.withValues(alpha: 0.85)
                  : palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
