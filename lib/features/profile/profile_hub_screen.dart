import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../core/utils/cloud_sync.dart';
import '../../providers/cloud_sync_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/price_alerts_provider.dart';
import '../../providers/security_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../customization/customization_screen.dart';
import '../learn/course_library_screen.dart';
import '../messages/messages_screen.dart';
import '../settings/settings_screen.dart';
import 'profile_documents_screen.dart';
import 'profile_notifications_screen.dart';
import 'profile_screen.dart';
import 'profile_security_screen.dart';
import 'profile_server_screen.dart';

/// Профиль-хаб в стиле банковского приложения: счета, сервисы, настройки.
class ProfileHubScreen extends ConsumerWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _ProfileHubHeader(l10n: l10n)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  l10n.profileHubAccountsTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _ProfileAccountsCarousel(l10n: l10n)),
            SliverToBoxAdapter(child: _ProfileQuickActions(l10n: l10n)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _HubSectionTitle(title: l10n.profileHubSectionProfile),
                  _HubMenuTile(
                    icon: Iconsax.user,
                    iconColor: palette.accent,
                    title: l10n.profileHubPersonalData,
                    subtitle: l10n.profileHubPersonalDataSub,
                    onTap: () => openAppPage(context, const ProfileScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.cloud_connection,
                    iconColor: const Color(0xFF5B8DEF),
                    title: l10n.profileHubServerAccount,
                    subtitle: _serverSubtitle(ref, l10n),
                    badge: ref.watch(homeServerProvider).auth.isLoggedIn
                        ? l10n.profileHubServerOnline
                        : null,
                    onTap: () => openAppPage(context, const ProfileServerScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.message,
                    iconColor: const Color(0xFF9B59B6),
                    title: l10n.profileHubMessages,
                    subtitle: l10n.messagesTitle,
                    onTap: () => openAppPage(context, const MessagesScreen()),
                  ),
                  const Gap(20),
                  _HubSectionTitle(title: l10n.profileHubSectionFinance),
                  _HubMenuTile(
                    icon: Iconsax.wallet_3,
                    iconColor: palette.positive,
                    title: l10n.profileHubPortfolio,
                    subtitle: _portfolioSubtitle(ref, l10n),
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
                  ),
                  _HubMenuTile(
                    icon: Iconsax.star,
                    iconColor: const Color(0xFFF0B90A),
                    title: l10n.profileHubWatchlist,
                    subtitle: l10n.profileHubAssets(
                      ref.watch(watchlistProvider).length,
                    ),
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
                  ),
                  const Gap(20),
                  _HubSectionTitle(title: l10n.profileHubSectionSecurity),
                  _HubMenuTile(
                    icon: Iconsax.shield_tick,
                    iconColor: const Color(0xFF26A69A),
                    title: l10n.profileHubSecurity,
                    subtitle: _securitySubtitle(ref, l10n),
                    onTap: () => openAppPage(context, const ProfileSecurityScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.document_text,
                    iconColor: const Color(0xFF7986CB),
                    title: l10n.profileHubDocuments,
                    subtitle: l10n.profileHubDocumentsSub,
                    onTap: () => openAppPage(context, const ProfileDocumentsScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.cloud_add,
                    iconColor: const Color(0xFF42A5F5),
                    title: l10n.profileHubCloudSync,
                    subtitle: _syncSubtitle(ref, l10n),
                    onTap: () => openAppPage(context, const ProfileDocumentsScreen()),
                  ),
                  const Gap(20),
                  _HubSectionTitle(title: l10n.profileHubSectionApp),
                  _HubMenuTile(
                    icon: Iconsax.notification,
                    iconColor: const Color(0xFFFF7043),
                    title: l10n.profileHubNotifications,
                    subtitle: l10n.profileHubNotificationsSub,
                    onTap: () =>
                        openAppPage(context, const ProfileNotificationsScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.brush_1,
                    iconColor: palette.accent,
                    title: l10n.profileHubCustomization,
                    subtitle: l10n.customizationSettingsEntrySubtitle,
                    onTap: () => openAppPage(context, const CustomizationScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.setting_2,
                    iconColor: palette.textSecondary,
                    title: l10n.profileHubAppSettings,
                    subtitle: l10n.profileHubAppSettingsSub,
                    onTap: () => openAppPage(context, const SettingsScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.book,
                    iconColor: const Color(0xFFAB47BC),
                    title: l10n.profileHubCourses,
                    subtitle: l10n.courseLibrarySubtitle,
                    onTap: () => openAppPage(context, const CourseLibraryScreen()),
                  ),
                  _HubMenuTile(
                    icon: Iconsax.info_circle,
                    iconColor: palette.textSecondary,
                    title: l10n.profileHubAbout,
                    subtitle: 'EcoPulse v1.0.44',
                    onTap: () => openAppPage(context, const SettingsScreen()),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _serverSubtitle(WidgetRef ref, AppLocalizations l10n) {
    final auth = ref.watch(homeServerProvider).auth;
    if (auth.isLoggedIn) {
      return auth.displayName.isNotEmpty
          ? auth.displayName
          : auth.login;
    }
    return l10n.profileHubServerOffline;
  }

  String _portfolioSubtitle(WidgetRef ref, AppLocalizations l10n) {
    final snap = ref.watch(portfolioSnapshotProvider);
    if (snap == null || snap.positions.isEmpty) {
      return l10n.profileHubPortfolioEmpty;
    }
    return '${Formatters.rub(snap.totalValueRub)} · ${l10n.profileHubPositions(snap.positions.length)}';
  }

  String _securitySubtitle(WidgetRef ref, AppLocalizations l10n) {
    final sec = ref.watch(securitySettingsProvider);
    if (sec.pinEnabled && sec.biometricEnabled) {
      return l10n.profileHubSecurityPinBio;
    }
    if (sec.pinEnabled) return l10n.settingsPinEnabled;
    return l10n.settingsPinDisabled;
  }

  String _syncSubtitle(WidgetRef ref, AppLocalizations l10n) {
    final sync = ref.watch(cloudSyncProvider);
    return switch (sync.pending) {
      CloudSyncPendingState.localChanges => l10n.cloudSyncStatusPending,
      CloudSyncPendingState.synced => l10n.cloudSyncStatusSynced,
      CloudSyncPendingState.neverSynced => l10n.cloudSyncStatusNever,
    };
  }
}

class _ProfileHubHeader extends ConsumerWidget {
  const _ProfileHubHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serverOnline = ref.watch(homeServerProvider).auth.isLoggedIn;
    final demo = ref.watch(demoModeProvider);

    final name = profile.hasName
        ? profile.displayName
        : l10n.profileGuest.split('·').first.trim();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  palette.accent.withValues(alpha: 0.35),
                  palette.background,
                ]
              : [
                  palette.accent.withValues(alpha: 0.85),
                  palette.accent.withValues(alpha: 0.45),
                ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.tabProfile,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? palette.textPrimary : Colors.white,
                ),
              ),
              const Spacer(),
              if (demo)
                _HeaderChip(
                  label: l10n.demoModeTitle,
                  color: Colors.orange,
                  textColor: Colors.white,
                ),
              if (serverOnline) ...[
                if (demo) const Gap(8),
                _HeaderChip(
                  label: l10n.profileHubServerOnline,
                  color: palette.positive.withValues(alpha: 0.9),
                  textColor: Colors.white,
                ),
              ],
            ],
          ),
          const Gap(24),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.avatarEmoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.hasName
                          ? l10n.profileGreeting(profile.displayName)
                          : name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? palette.textPrimary : Colors.white,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      profile.phone.isNotEmpty
                          ? profile.phone
                          : profile.email.isNotEmpty
                              ? profile.email
                              : l10n.profileCountryLabel(
                                  AppConstants.inflationCountries[
                                          profile.countryCode] ??
                                      profile.countryCode,
                                ),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? palette.textSecondary
                            : Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    if (profile.isComplete) ...[
                      const Gap(6),
                      Row(
                        children: [
                          Icon(
                            Iconsax.verify,
                            size: 14,
                            color: isDark ? palette.positive : Colors.white,
                          ),
                          const Gap(4),
                          Text(
                            l10n.profileHubVerified,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? palette.positive
                                  : Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Material(
                color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => openAppPage(context, const ProfileScreen()),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.edit_2,
                          size: 16,
                          color: isDark ? palette.textPrimary : Colors.white,
                        ),
                        const Gap(6),
                        Text(
                          l10n.profileHubEditProfile,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? palette.textPrimary : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.05, end: 0);
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _ProfileAccountsCarousel extends ConsumerWidget {
  const _ProfileAccountsCarousel({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final snap = ref.watch(portfolioSnapshotProvider);
    final watchlist = ref.watch(watchlistProvider);
    final alerts = ref.watch(priceAlertsProvider);
    final portfolio = ref.watch(paperPortfolioProvider);

    final cards = <_AccountCardData>[
      _AccountCardData(
        title: l10n.profileHubAccountPortfolio,
        amount: snap != null && snap.positions.isNotEmpty
            ? Formatters.rub(snap.totalValueRub)
            : Formatters.rub(portfolio.cashRub),
        subtitle: snap != null && snap.positions.isNotEmpty
            ? '${snap.pnlPercent >= 0 ? '+' : ''}${snap.pnlPercent.toStringAsFixed(1)}%'
            : l10n.profileHubPortfolioEmpty,
        subtitleColor: snap != null && snap.pnlPercent >= 0
            ? palette.positive
            : palette.negative,
        gradient: [const Color(0xFF1B5E20), const Color(0xFF43A047)],
        icon: Iconsax.chart_3,
        onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
      ),
      _AccountCardData(
        title: l10n.profileHubAccountWatchlist,
        amount: '${watchlist.length}',
        subtitle: l10n.profileHubAssets(watchlist.length),
        subtitleColor: Colors.white70,
        gradient: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
        icon: Iconsax.star,
        onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
      ),
      _AccountCardData(
        title: l10n.profileHubAccountAlerts,
        amount: '${alerts.length}',
        subtitle: l10n.profileHubActiveAlerts(alerts.length),
        subtitleColor: Colors.white70,
        gradient: [const Color(0xFFE65100), const Color(0xFFFF9800)],
        icon: Iconsax.notification,
        onTap: () => openAppPage(context, const ProfileNotificationsScreen()),
      ),
      _AccountCardData(
        title: l10n.profileHubAccountCash,
        amount: Formatters.rub(portfolio.cashRub),
        subtitle: l10n.profileHubAccountCashSub,
        subtitleColor: Colors.white70,
        gradient: [const Color(0xFF4527A0), const Color(0xFF7E57C2)],
        icon: Iconsax.wallet_money,
        onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
      ),
    ];

    return SizedBox(
      height: 148,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return _AccountCard(data: card, index: index);
        },
      ),
    );
  }
}

class _AccountCardData {
  const _AccountCardData({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.subtitleColor,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String amount;
  final String subtitle;
  final Color subtitleColor;
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback onTap;
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.data, required this.index});

  final _AccountCardData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: data.gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: data.gradient.last.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(data.icon, color: Colors.white, size: 20),
                  const Spacer(),
                  Icon(Iconsax.arrow_right_3, color: Colors.white54, size: 16),
                ],
              ),
              const Spacer(),
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(4),
              Text(
                data.amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Gap(2),
              Text(
                data.subtitle,
                style: TextStyle(
                  color: data.subtitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (80 * index).ms, duration: 320.ms)
        .slideX(begin: 0.08, end: 0);
  }
}

class _ProfileQuickActions extends ConsumerWidget {
  const _ProfileQuickActions({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);

    final actions = [
      _QuickAction(
        icon: Iconsax.export_1,
        label: l10n.profileHubQuickBackup,
        color: palette.accent,
        onTap: () => openAppPage(context, const ProfileDocumentsScreen()),
      ),
      _QuickAction(
        icon: Iconsax.shield_tick,
        label: l10n.profileHubQuickSecurity,
        color: const Color(0xFF26A69A),
        onTap: () => openAppPage(context, const ProfileSecurityScreen()),
      ),
      _QuickAction(
        icon: Iconsax.cloud_add,
        label: l10n.profileHubQuickSync,
        color: const Color(0xFF42A5F5),
        onTap: () => openAppPage(context, const ProfileDocumentsScreen()),
      ),
      _QuickAction(
        icon: Iconsax.brush_1,
        label: l10n.profileHubQuickCustomize,
        color: const Color(0xFFAB47BC),
        onTap: () => openAppPage(context, const CustomizationScreen()),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: actions
            .map(
              (a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: a,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Gap(8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubSectionTitle extends StatelessWidget {
  const _HubSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}

class _HubMenuTile extends StatelessWidget {
  const _HubMenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: palette.textPrimary,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: palette.positive.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: palette.positive,
                      ),
                    ),
                  ),
                  const Gap(8),
                ],
                Icon(Iconsax.arrow_right_3, color: palette.textSecondary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
