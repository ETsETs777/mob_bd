import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/api_keys_provider.dart';
import '../../providers/base_currency_provider.dart';
import '../../providers/background_provider.dart';
import '../../providers/security_provider.dart';
import '../../providers/compact_home_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../../providers/default_tab_provider.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/morning_digest_provider.dart';
import '../../core/theme/app_accent.dart';
import '../../providers/accent_provider.dart';
import '../../providers/theme_provider.dart';
import '../../core/theme/app_backgrounds.dart';
import '../auth/pin_setup_screen.dart';
import '../customization/customization_screen.dart';
import '../alerts/price_alerts_screen.dart';
import '../admin/admin_panel_screen.dart';
import 'cloud_sync_settings.dart';
import 'home_server_settings.dart';
import 'profile_backup_widgets.dart';
import '../learn/course_library_screen.dart';
import '../messages/messages_screen.dart';
import 'home_layout_settings.dart';
import 'widget_settings.dart';

/// Приватная функция [_themeModeLabel].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
String _themeModeLabel(AppThemeMode mode, AppLocalizations l10n) => switch (mode) {
      AppThemeMode.dark => l10n.settingsThemeDark,
      AppThemeMode.light => l10n.settingsThemeLight,
      AppThemeMode.system => l10n.settingsThemeAuto,
      AppThemeMode.oled => l10n.settingsThemeOled,
      AppThemeMode.dim => l10n.settingsThemeDim,
      AppThemeMode.sepia => l10n.settingsThemeSepia,
      AppThemeMode.contrast => l10n.settingsThemeContrast,
    };

IconData _themeModeIcon(AppThemeMode mode) => switch (mode) {
      AppThemeMode.dark => Iconsax.moon,
      AppThemeMode.light => Iconsax.sun_1,
      AppThemeMode.system => Iconsax.mobile,
      AppThemeMode.oled => Iconsax.monitor,
      AppThemeMode.dim => Iconsax.moon,
      AppThemeMode.sepia => Iconsax.book,
      AppThemeMode.contrast => Iconsax.eye,
    };

/// Класс [SettingsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class SettingsScreen extends ConsumerWidget {
/// Создаёт [SettingsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  const SettingsScreen({super.key});

/// Отрисовывает UI [SettingsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);
    final background = ref.watch(backgroundPresetProvider);
    final security = ref.watch(securitySettingsProvider);
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final defaultTab = ref.watch(defaultTabProvider);
    final compactHome = ref.watch(compactHomeProvider);
    final appLocale = ref.watch(localeProvider);
    final isRu = appLocale == AppLocale.ru;
    final apiKeys = ref.watch(apiKeysProvider);
    final l10n = AppLocalizations.of(context)!;
    final hasCoingecko = apiKeys.hasCoingecko;
    final hasFinnhub = apiKeys.hasFinnhub;
    final hasGemini = apiKeys.hasGemini;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: l10n.profileSectionTitle, palette: palette),
          const Gap(8),
          const ProfileSettingsCard(),
          const Gap(24),
          _SectionTitle(title: l10n.customizationSectionTitle, palette: palette),
          const Gap(8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(Iconsax.brush_2, color: palette.accent),
              title: Text(
                l10n.customizationSettingsEntry,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              subtitle: Text(
                l10n.customizationSettingsEntrySubtitle,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 13,
                ),
              ),
              trailing: Icon(
                Iconsax.arrow_right_3,
                color: palette.textSecondary,
                size: 18,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CustomizationScreen(),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
          const Gap(24),
          _SectionTitle(title: l10n.settingsSectionAppearance, palette: palette),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.colorfilter, color: palette.accent, size: 22),
                      const Gap(10),
                      Text(
                        l10n.settingsAppTheme,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: AppThemeMode.values.map((mode) {
                        final selected = themeMode == mode;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: selected,
                            showCheckmark: false,
                            avatar: Icon(
                              _themeModeIcon(mode),
                              size: 16,
                              color: selected
                                  ? palette.accent
                                  : palette.textSecondary,
                            ),
                            label: Text(_themeModeLabel(mode, l10n)),
                            onSelected: (_) => ref
                                .read(themeModeProvider.notifier)
                                .setMode(mode),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    l10n.settingsAccentColor,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  const Gap(10),
                  Wrap(
                    spacing: 12,
                    children: AppAccentColor.values.map((accent) {
                      final selected = accentColor == accent;
                      final color = Theme.of(context).brightness == Brightness.dark
                          ? accent.darkAccent
                          : accent.lightAccent;
                      return GestureDetector(
                        onTap: () =>
                            ref.read(accentColorProvider.notifier).setAccent(accent),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? palette.textPrimary
                                  : palette.border,
                              width: selected ? 2.5 : 1,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.45),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                          child: selected
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const Gap(8),
                  Text(
                    isRu ? accentColor.labelRu : accentColor.labelEn,
                    style: TextStyle(color: palette.textSecondary, fontSize: 13),
                  ),
                  const Gap(12),
                  Text(
                    l10n.settingsThemeCurrent(_themeModeLabel(themeMode, l10n)),
                    style: TextStyle(color: palette.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
          const Gap(16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.image, color: palette.accent, size: 22),
                      const Gap(10),
                      Text(
                        l10n.settingsAppBackground,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    l10n.settingsBackgroundSubtitle,
                    style: TextStyle(color: palette.textSecondary, fontSize: 13),
                  ),
                  const Gap(16),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: AppBackgroundPreset.values.map((preset) {
                        return _SettingsBackgroundTile(
                          preset: preset,
                          label: isRu ? preset.label : preset.labelEn,
                          selected: background == preset,
                          palette: palette,
                          onTap: () => ref
                              .read(backgroundPresetProvider.notifier)
                              .setPreset(preset),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 30.ms, duration: 300.ms),
          const Gap(24),
          Card(
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              secondary: Icon(Iconsax.row_vertical, color: palette.accent),
              title: Text(
                l10n.settingsCompactHome,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              subtitle: Text(
                l10n.settingsCompactHomeSubtitle,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 13,
                ),
              ),
              value: compactHome,
              onChanged: (v) =>
                  ref.read(compactHomeProvider.notifier).setEnabled(v),
            ),
          ),
          const Gap(8),
          Card(
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              secondary: Icon(Iconsax.code, color: palette.accent),
              title: Text(
                l10n.demoModeTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              subtitle: Text(
                l10n.demoModeSubtitle,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 13,
                ),
              ),
              value: ref.watch(demoModeProvider),
              onChanged: (v) =>
                  ref.read(demoModeProvider.notifier).setEnabled(v),
            ),
          ),
          const Gap(24),
          _SectionTitle(title: l10n.homeLayoutTitle, palette: palette),
          const Gap(8),
          const HomeLayoutSettings(),
          const Gap(8),
          const WidgetSettingsCard(),
          const Gap(24),
          _SectionTitle(title: l10n.settingsLanguage, palette: palette),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<AppLocale>(
                segments: AppLocale.values
                    .map(
                      (l) => ButtonSegment(
                        value: l,
                        label: Text(l.label),
                      ),
                    )
                    .toList(),
                selected: {appLocale},
                onSelectionChanged: (set) {
                  ref.read(localeProvider.notifier).setLocale(set.first);
                },
              ),
            ),
          ),
          const Gap(24),
          _SectionTitle(title: l10n.settingsDefaultTab, palette: palette),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DefaultTab.values.map((tab) {
                  final selected = defaultTab == tab;
                  final label = switch (tab) {
                    DefaultTab.home => l10n.tabHome,
                    DefaultTab.currency => l10n.tabCurrency,
                    DefaultTab.inflation => l10n.tabInflation,
                    DefaultTab.markets => l10n.tabMarkets,
                    DefaultTab.settings => l10n.tabSettings,
                  };
                  return FilterChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) {
                      ref.read(defaultTabProvider.notifier).setTab(tab);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const Gap(24),
          _SectionTitle(title: l10n.digestSectionTitle, palette: palette),
          const Gap(8),
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
                      l10n.digestMorningSubtitle,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    value: ref.watch(morningDigestProvider).enabled,
                    onChanged: (v) =>
                        ref.read(morningDigestProvider.notifier).setEnabled(v),
                  ),
                  if (ref.watch(morningDigestProvider).enabled) ...[
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
                          value: ref.watch(morningDigestProvider).hour,
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
          const Gap(24),
          _SectionTitle(title: l10n.alertsTitle, palette: palette),
          const Gap(8),
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
          const Gap(24),
          _SectionTitle(title: l10n.settingsSectionSecurity, palette: palette),
          const Gap(8),
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
                                  .authenticate(
                                    reason: l10n.pinUseBiometric,
                                  );
                              if (!ok || !context.mounted) return;
                            }
                            await ref
                                .read(securitySettingsProvider.notifier)
                                .setBiometricEnabled(enabled);
                          },
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                    const Divider(height: 24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Iconsax.password_check, color: palette.accent),
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
                      leading: Icon(Iconsax.logout, color: palette.textSecondary),
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
          ).animate().fadeIn(delay: 60.ms, duration: 300.ms),
          const Gap(24),
          _SectionTitle(title: l10n.settingsSectionDisplay, palette: palette),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.money, color: palette.accent, size: 22),
                      const Gap(10),
                      Text(
                        l10n.settingsBaseCurrency,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  SegmentedButton<BaseCurrency>(
                    segments: BaseCurrency.values
                        .map(
                          (c) => ButtonSegment(
                            value: c,
                            label: Text(c.code),
                          ),
                        )
                        .toList(),
                    selected: {baseCurrency},
                    onSelectionChanged: (set) {
                      ref
                          .read(baseCurrencyProvider.notifier)
                          .setCurrency(set.first);
                    },
                  ),
                  const Gap(12),
                  Text(
                    '${baseCurrency.label} · ${l10n.settingsBaseCurrencyHint}',
                    style: TextStyle(color: palette.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 50.ms, duration: 300.ms),
          const Gap(24),
          _SectionTitle(title: l10n.settingsApiKeysTitle, palette: palette),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsKeysLocalNote,
                    style: TextStyle(color: palette.textSecondary, fontSize: 13),
                  ),
                  const Gap(16),
                  _ApiKeyField(
                    label: 'CoinGecko Demo Key',
                    hint: 'x-cg-demo-api-key',
                    initialValue: apiKeys.coingecko,
                    onSave: (v) =>
                        ref.read(apiKeysProvider.notifier).saveCoingecko(v),
                  ),
                  const Gap(12),
                  _ApiKeyField(
                    label: 'Finnhub Key',
                    hint: 'finnhub.io token',
                    initialValue: apiKeys.finnhub,
                    onSave: (v) =>
                        ref.read(apiKeysProvider.notifier).saveFinnhub(v),
                  ),
                  const Gap(12),
                  _ApiKeyField(
                    label: l10n.settingsGeminiKey,
                    hint: 'Google AI Studio',
                    initialValue: apiKeys.gemini,
                    onSave: (v) =>
                        ref.read(apiKeysProvider.notifier).saveGemini(v),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 80.ms, duration: 300.ms),
          const Gap(24),
          _SectionTitle(title: l10n.settingsSectionDataApi, palette: palette),
          const Gap(8),
          _SettingsTile(
            icon: Iconsax.global,
            title: l10n.sourceFrankfurter,
            subtitle: l10n.sourceFrankfurterSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          _SettingsTile(
            icon: Iconsax.bank,
            title: l10n.sourceMoex,
            subtitle: l10n.sourceMoexSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          _SettingsTile(
            icon: Iconsax.percentage_circle,
            title: l10n.sourceCbr,
            subtitle: l10n.sourceCbrSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          _SettingsTile(
            icon: Iconsax.chart_2,
            title: l10n.sourceWorldBank,
            subtitle: l10n.sourceWorldBankSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          _SettingsTile(
            icon: Iconsax.dollar_circle,
            title: l10n.sourceCoingecko,
            subtitle: l10n.sourceCoingeckoSub,
            status: hasCoingecko ? l10n.statusKeyOk : l10n.statusNoKey,
            statusColor: hasCoingecko ? palette.positive : palette.textSecondary,
          ),
          _SettingsTile(
            icon: Iconsax.status_up,
            title: l10n.sourceFinnhub,
            subtitle: l10n.sourceFinnhubSub,
            status: hasFinnhub ? l10n.statusKeyOk : l10n.statusNotConfigured,
            statusColor: hasFinnhub ? palette.positive : palette.textSecondary,
          ),
          _SettingsTile(
            icon: Iconsax.message,
            title: l10n.settingsGeminiKey,
            subtitle: l10n.assistantTitle,
            status: hasGemini ? l10n.statusKeyOk : l10n.statusNotConfigured,
            statusColor: hasGemini ? palette.positive : palette.textSecondary,
          ),
          _SettingsTile(
            icon: Iconsax.chart_21,
            title: 'Alternative.me',
            subtitle: 'Fear & Greed Index',
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          const Gap(24),
          _SectionTitle(title: l10n.homeServerTitle, palette: palette),
          const Gap(8),
          const HomeServerSettingsCard(),
          const Gap(8),
          _SettingsTile(
            icon: Iconsax.message,
            title: l10n.messagesTitle,
            subtitle: l10n.messagesNotConnected,
            status: ref.watch(homeServerProvider).auth.isLoggedIn
                ? l10n.statusActive
                : l10n.statusNotConfigured,
            statusColor: ref.watch(homeServerProvider).auth.isLoggedIn
                ? palette.positive
                : palette.textSecondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const MessagesScreen()),
            ),
          ),
          const Gap(24),
          _SectionTitle(title: l10n.backupSectionTitle, palette: palette),
          const Gap(8),
          const CloudSyncSettingsCard(),
          const Gap(8),
          const BackupSettingsSection(),
          const Gap(24),
          _SectionTitle(title: l10n.courseLibraryTitle, palette: palette),
          const Gap(8),
          _SettingsTile(
            icon: Iconsax.book_1,
            title: l10n.courseHomeCardTitle,
            subtitle: l10n.courseLibrarySubtitle,
            status: l10n.statusActive,
            statusColor: palette.positive,
            onTap: () => openCourseLibrary(context),
          ),
          const Gap(24),
          _SectionTitle(title: l10n.settingsSectionAbout, palette: palette),
          const Gap(8),
          _AboutCard(palette: palette, l10n: l10n),
          const Gap(8),
        ],
      ),
    );
  }
}

/// Приватный класс [_AboutCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
class _AboutCard extends StatefulWidget {
/// Создаёт [_AboutCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const _AboutCard({required this.palette, required this.l10n});

/// Поле [palette] класса [_AboutCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final AppPalette palette;
/// Поле [l10n] класса [_AboutCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final AppLocalizations l10n;

/// Создаёт State для [_AboutCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  State<_AboutCard> createState() => _AboutCardState();
}

/// Приватный класс [_AboutCardState] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
class _AboutCardState extends State<_AboutCard> {
/// Поле [_versionTaps] класса [_AboutCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  int _versionTaps = 0;
/// Поле [_revealed] класса [_AboutCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  bool _revealed = false;

/// Приватный метод [_onVersionTap] класса [_AboutCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  void _onVersionTap() {
    _versionTaps++;
    if (_versionTaps >= 5 && !_revealed) {
      setState(() => _revealed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == 'ru'
                ? 'EcoPulse · Цымбал Е. В.'
                : 'EcoPulse · Tsymbal E. V.',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
    if (_versionTaps >= 10 && mounted) {
      openAppPage<void>(context, const AdminPanelScreen());
      _versionTaps = 0;
    }
  }

/// Отрисовывает UI [_AboutCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _onVersionTap,
              child: Text(
                'EcoPulse v1.0.44',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
            ),
            if (_revealed) ...[
              const Gap(6),
              Text(
                'Цымбал Е. В.',
                style: TextStyle(
                  color: palette.accent.withValues(alpha: 0.7),
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const Gap(8),
            Text(
              widget.l10n.settingsAboutDescription,
              style: TextStyle(color: palette.textSecondary, height: 1.4),
            ),
            const Gap(12),
            Text(
              widget.l10n.settingsAboutDesign,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(8),
            Text(
              widget.l10n.settingsAboutDeveloper,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

/// Приватный класс [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
class _ApiKeyField extends StatefulWidget {
/// Создаёт [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const _ApiKeyField({
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onSave,
  });

/// Поле [label] класса [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final String label;
/// Поле [hint] класса [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final String hint;
/// Поле [initialValue] класса [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final String initialValue;
/// Поле [onSave] класса [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final Future<void> Function(String) onSave;

/// Создаёт State для [_ApiKeyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  State<_ApiKeyField> createState() => _ApiKeyFieldState();
}

/// Приватный класс [_ApiKeyFieldState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class _ApiKeyFieldState extends State<_ApiKeyField> {
/// Поле [_controller] класса [_ApiKeyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  late final TextEditingController _controller;
/// Поле [_obscure] класса [_ApiKeyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  bool _obscure = true;

/// Инициализация state [_ApiKeyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

/// Метод [didUpdateWidget] класса [_ApiKeyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  void didUpdateWidget(covariant _ApiKeyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

/// Освобождает ресурсы [_ApiKeyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_ApiKeyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ),
        const Gap(8),
        FilledButton.tonal(
          onPressed: () async {
            await widget.onSave(_controller.text.trim());
            if (context.mounted) {
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.settingsApiKeySaved(widget.label)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

/// Приватный класс [_SettingsBackgroundTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
class _SettingsBackgroundTile extends StatelessWidget {
/// Создаёт [_SettingsBackgroundTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  const _SettingsBackgroundTile({
    required this.preset,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final AppBackgroundPreset preset;
  final String label;
  final bool selected;
/// Поле [palette] класса [_SettingsBackgroundTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final AppPalette palette;
/// Поле [onTap] класса [_SettingsBackgroundTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final VoidCallback onTap;

/// Отрисовывает UI [_SettingsBackgroundTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Widget build(BuildContext context) {
    final colors = preset.gradientColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: colors,
                  begin: preset.gradientBegin,
                  end: preset.gradientEnd,
                ),
                border: Border.all(
                  color: selected ? palette.accent : palette.border,
                  width: selected ? 2.5 : 1,
                ),
              ),
              child: selected
                  ? Center(
                      child: Icon(Icons.check, color: colors.first.computeLuminance() > 0.5 ? Colors.black87 : Colors.white, size: 20),
                    )
                  : null,
            ),
            const Gap(4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: selected ? palette.accent : palette.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class _SectionTitle extends StatelessWidget {
/// Создаёт [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  const _SectionTitle({required this.title, required this.palette});

/// Поле [title] класса [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final String title;
/// Поле [palette] класса [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_SectionTitle].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: palette.textSecondary,
      ),
    );
  }
}

/// Приватный класс [_SettingsTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class _SettingsTile extends StatelessWidget {
/// Создаёт [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    this.onTap,
  });

/// Поле [icon] класса [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final IconData icon;
/// Поле [title] класса [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final String title;
/// Поле [subtitle] класса [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final String subtitle;
/// Поле [status] класса [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  final String status;
/// Поле [statusColor] класса [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final Color statusColor;
/// Поле [onTap] класса [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final VoidCallback? onTap;

/// Отрисовывает UI [_SettingsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: palette.accent),
        title: Text(title, style: TextStyle(color: palette.textPrimary)),
        subtitle: Text(subtitle, style: TextStyle(color: palette.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
