import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/customization/customization_sync.dart';
import '../../core/customization/data_display_customization_resolver.dart';
import '../../core/customization/navigation_customization_resolver.dart';
import '../../core/motion/app_motion.dart';
import '../../core/theme/app_accent.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/background_provider.dart';
import '../../providers/accent_provider.dart';
import '../../providers/api_keys_provider.dart';
import '../../providers/broker_provider.dart';
import '../../providers/app_providers.dart';
import '../../providers/base_currency_provider.dart';
import '../../providers/compact_home_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/data_display_customization_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../../providers/default_tab_provider.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/morning_digest_provider.dart';
import '../../providers/security_provider.dart';
import '../../providers/theme_provider.dart';
import '../alerts/price_alerts_screen.dart';
import '../auth/pin_setup_screen.dart';
import '../learn/course_library_screen.dart';
import '../messages/messages_screen.dart';
import 'cloud_sync_settings.dart';
import 'home_layout_settings.dart';
import 'home_server_settings.dart';
import 'profile_backup_widgets.dart';
import 'widget_settings.dart';
import 'widgets/settings_shared_widgets.dart';

class SettingsAppearanceSection extends ConsumerWidget {
  const SettingsAppearanceSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);
    final background = ref.watch(backgroundPresetProvider);
    final compactHome = ref.watch(compactHomeProvider);
    final appLocale = ref.watch(resolvedDataDisplayProvider).appLocale;
    final isRu = appLocale == AppLocale.ru;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.settingsSectionAppearance, palette: palette),
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
                              settingsThemeModeIcon(mode),
                              size: 16,
                              color: selected
                                  ? palette.accent
                                  : palette.textSecondary,
                            ),
                            label: Text(settingsThemeModeLabel(mode, l10n)),
                            onSelected: (_) async {
                              await CustomizationSync.commit(
                                ref,
                                ref.read(customizationProvider).copyWith(
                                      appearance: ref
                                          .read(customizationProvider)
                                          .appearance
                                          .copyWith(themeModeKey: mode.storageKey),
                                    ),
                              );
                            },
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
                        onTap: () async {
                          await CustomizationSync.commit(
                            ref,
                            ref.read(customizationProvider).copyWith(
                                  appearance: ref
                                      .read(customizationProvider)
                                      .appearance
                                      .copyWith(accentKey: accent.key),
                                ),
                          );
                        },
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
                    l10n.settingsThemeCurrent(settingsThemeModeLabel(themeMode, l10n)),
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
                        return SettingsBackgroundTile(
                          preset: preset,
                          label: isRu ? preset.label : preset.labelEn,
                          selected: background == preset,
                          palette: palette,
                          onTap: () async {
                            await CustomizationSync.commit(
                              ref,
                              ref.read(customizationProvider).copyWith(
                                    appearance: ref
                                        .read(customizationProvider)
                                        .appearance
                                        .copyWith(backgroundKey: preset.name),
                                  ),
                            );
                          },
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
              onChanged: (v) async {
                await CustomizationSync.commit(
                  ref,
                  ref.read(customizationProvider).copyWith(
                        home: ref
                            .read(customizationProvider)
                            .home
                            .copyWith(compactHome: v),
                      ),
                );
              },
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
      ],
    );
  }
}

class SettingsHomeWidgetSection extends ConsumerWidget {
  const SettingsHomeWidgetSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.homeLayoutTitle, palette: palette),
          const Gap(8),
          const HomeLayoutSettings(),
          const Gap(8),
          const WidgetSettingsCard(),
          const Gap(24),
      ],
    );
  }
}

class SettingsLocaleNavigationSection extends ConsumerWidget {
  const SettingsLocaleNavigationSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final appLocale = ref.watch(resolvedDataDisplayProvider).appLocale;
    final defaultTab = ref.watch(defaultTabProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.settingsLanguage, palette: palette),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                  onSelectionChanged: (set) async {
                  await CustomizationSync.commit(
                    ref,
                    ref.read(customizationProvider).copyWith(
                          dataDisplay:
                              DataDisplayCustomizationResolver.updateLocale(
                            ref.read(customizationProvider).dataDisplay,
                            set.first,
                          ),
                        ),
                  );
                },
                ),
              ),
            ),
          ),
          const Gap(24),
          SettingsSectionTitle(title: l10n.settingsDefaultTab, palette: palette),
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
                    onSelected: (_) async {
                      await CustomizationSync.commit(
                        ref,
                        ref.read(customizationProvider).copyWith(
                              navigation:
                                  NavigationCustomizationResolver.updateDefaultTabIndex(
                                ref.read(customizationProvider).navigation,
                                tab.tabIndex,
                              ),
                            ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class SettingsNotificationsSection extends ConsumerWidget {
  const SettingsNotificationsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Gap(24),
          SettingsSectionTitle(title: l10n.digestSectionTitle, palette: palette),
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
          SettingsSectionTitle(title: l10n.alertsTitle, palette: palette),
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
      ],
    );
  }
}

class SettingsSecuritySection extends ConsumerWidget {
  const SettingsSecuritySection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final security = ref.watch(securitySettingsProvider);
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.settingsSectionSecurity, palette: palette),
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
      ],
    );
  }
}

class SettingsDisplaySection extends ConsumerWidget {
  const SettingsDisplaySection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final baseCurrency = ref.watch(resolvedDataDisplayProvider).baseCurrency;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.settingsSectionDisplay, palette: palette),
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
                    onSelectionChanged: (set) async {
                      await CustomizationSync.commit(
                        ref,
                        ref.read(customizationProvider).copyWith(
                              dataDisplay:
                                  DataDisplayCustomizationResolver
                                      .updateBaseCurrency(
                                ref.read(customizationProvider).dataDisplay,
                                set.first,
                              ),
                            ),
                      );
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
      ],
    );
  }
}

class SettingsApiDataSection extends ConsumerWidget {
  const SettingsApiDataSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final apiKeys = ref.watch(apiKeysProvider);
    final hasCoingecko = apiKeys.hasCoingecko;
    final hasFinnhub = apiKeys.hasFinnhub;
    final hasGemini = apiKeys.hasGemini;
    final hasTinkoff = apiKeys.hasTinkoffBroker;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.settingsApiKeysTitle, palette: palette),
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
                  SettingsApiKeyField(
                    label: 'CoinGecko Demo Key',
                    hint: 'x-cg-demo-api-key',
                    initialValue: apiKeys.coingecko,
                    onSave: (v) =>
                        ref.read(apiKeysProvider.notifier).saveCoingecko(v),
                  ),
                  const Gap(12),
                  SettingsApiKeyField(
                    label: 'Finnhub Key',
                    hint: 'finnhub.io token',
                    initialValue: apiKeys.finnhub,
                    onSave: (v) =>
                        ref.read(apiKeysProvider.notifier).saveFinnhub(v),
                  ),
                  const Gap(12),
                  SettingsApiKeyField(
                    label: l10n.settingsGeminiKey,
                    hint: 'Google AI Studio',
                    initialValue: apiKeys.gemini,
                    onSave: (v) =>
                        ref.read(apiKeysProvider.notifier).saveGemini(v),
                  ),
                  const Gap(12),
                  SettingsApiKeyField(
                    label: l10n.brokerTokenLabel,
                    hint: l10n.brokerTokenHint,
                    initialValue: apiKeys.tinkoffBroker,
                    onSave: (v) async {
                      await ref
                          .read(apiKeysProvider.notifier)
                          .saveTinkoffBroker(v);
                      if (v.trim().isNotEmpty) {
                        await ref.read(brokerPortfolioProvider.notifier).refresh();
                      }
                    },
                  ),
                  if (hasTinkoff) ...[
                    const Gap(8),
                    Text(
                      l10n.brokerReadOnlyDisclaimer,
                      style: TextStyle(fontSize: 12, color: palette.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ).animate().fadeIn(delay: 80.ms, duration: 300.ms),
          const Gap(24),
          SettingsSectionTitle(title: l10n.settingsSectionDataApi, palette: palette),
          const Gap(8),
          SettingsTile(
            icon: Iconsax.global,
            title: l10n.sourceFrankfurter,
            subtitle: l10n.sourceFrankfurterSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          SettingsTile(
            icon: Iconsax.bank,
            title: l10n.sourceMoex,
            subtitle: l10n.sourceMoexSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          SettingsTile(
            icon: Iconsax.percentage_circle,
            title: l10n.sourceCbr,
            subtitle: l10n.sourceCbrSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          SettingsTile(
            icon: Iconsax.chart_2,
            title: l10n.sourceWorldBank,
            subtitle: l10n.sourceWorldBankSub,
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          SettingsTile(
            icon: Iconsax.dollar_circle,
            title: l10n.sourceCoingecko,
            subtitle: l10n.sourceCoingeckoSub,
            status: hasCoingecko ? l10n.statusKeyOk : l10n.statusNoKey,
            statusColor: hasCoingecko ? palette.positive : palette.textSecondary,
          ),
          SettingsTile(
            icon: Iconsax.status_up,
            title: l10n.sourceFinnhub,
            subtitle: l10n.sourceFinnhubSub,
            status: hasFinnhub ? l10n.statusKeyOk : l10n.statusNotConfigured,
            statusColor: hasFinnhub ? palette.positive : palette.textSecondary,
          ),
          SettingsTile(
            icon: Iconsax.message,
            title: l10n.settingsGeminiKey,
            subtitle: l10n.assistantTitle,
            status: hasGemini ? l10n.statusKeyOk : l10n.statusNotConfigured,
            statusColor: hasGemini ? palette.positive : palette.textSecondary,
          ),
          SettingsTile(
            icon: Iconsax.chart_21,
            title: 'Alternative.me',
            subtitle: 'Fear & Greed Index',
            status: l10n.statusActive,
            statusColor: palette.positive,
          ),
          const Gap(24),
      ],
    );
  }
}

class SettingsSyncSection extends ConsumerWidget {
  const SettingsSyncSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.homeServerTitle, palette: palette),
          const Gap(8),
          const HomeServerSettingsCard(),
          const Gap(8),
          SettingsTile(
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
          SettingsSectionTitle(title: l10n.backupSectionTitle, palette: palette),
          const Gap(8),
          const CloudSyncSettingsCard(),
          const Gap(8),
          const BackupSettingsSection(),
      ],
    );
  }
}

class SettingsAboutSection extends ConsumerWidget {
  const SettingsAboutSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SettingsSectionTitle(title: l10n.courseLibraryTitle, palette: palette),
          const Gap(8),
          SettingsTile(
            icon: Iconsax.book_1,
            title: l10n.courseHomeCardTitle,
            subtitle: l10n.courseLibrarySubtitle,
            status: l10n.statusActive,
            statusColor: palette.positive,
            onTap: () => openCourseLibrary(context),
          ),
          const Gap(24),
          SettingsSectionTitle(title: l10n.settingsSectionAbout, palette: palette),
          const Gap(8),
          SettingsAboutCard(palette: palette, l10n: l10n),
          const Gap(8),
      ],
    );
  }
}
