// =============================================================================
// EcoPulse · lib/features/settings/profile_backup_widgets.dart
// Автор: Цымбал Е. В.
// Дата: 19.06.2026
// Настройки, профиль, backup, layout. Файл: profile_backup_widgets.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/motion/app_motion.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/customization/customization_sync.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/utils/user_error_message.dart';
import '../../../core/utils/watchlist_report.dart';
import '../../home/economic_brief.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/commodities_provider.dart';
import '../../../providers/watchlist_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../profile/profile_screen.dart';

/// Класс [ProfileSettingsCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class ProfileSettingsCard extends ConsumerWidget {
/// Создаёт [ProfileSettingsCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  const ProfileSettingsCard({super.key});

/// Отрисовывает UI [ProfileSettingsCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    final title = profile.hasName
        ? l10n.profileGreeting(profile.displayName)
        : l10n.profileGuest;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: palette.accent.withValues(alpha: 0.15),
          child: ProfileAvatarStatic(
            emoji: profile.avatarEmoji,
            useCustomAvatar: profile.useCustomAvatar,
            size: 40,
          ),
        ),
        title: Text(title, style: TextStyle(color: palette.textPrimary)),
        subtitle: Text(
          l10n.profileCountryLabel(
            AppConstants.inflationCountries[profile.countryCode] ??
                profile.countryCode,
          ),
          style: TextStyle(color: palette.textSecondary),
        ),
        trailing: const Icon(Iconsax.arrow_right_3),
        onTap: () => openAppPage<void>(context, const ProfileScreen()),
      ),
    );
  }
}

/// Класс [BackupSettingsSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
class BackupSettingsSection extends ConsumerWidget {
/// Создаёт [BackupSettingsSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const BackupSettingsSection({super.key});

/// Отрисовывает UI [BackupSettingsSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: ListTile(
            leading: Icon(Iconsax.export_1, color: palette.accent),
            title: Text(l10n.backupExportTitle),
            subtitle: Text(
              l10n.backupExportSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            onTap: () async {
              final json = BackupService.instance.exportJson();
              await Share.share(
                json,
                subject: 'EcoPulse backup',
              );
            },
          ),
        ),
        const Gap(8),
        Card(
          child: ListTile(
            leading: Icon(Iconsax.document_text, color: palette.accent),
            title: Text(l10n.exportReportTitle),
            subtitle: Text(
              l10n.exportReportSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            onTap: () async {
              final watchlist = ref.read(watchlistProvider);
              final crypto = ref.read(cryptoProvider).valueOrNull?.assets ?? [];
              final stocks = ref.read(stocksProvider).valueOrNull ?? [];
              final brief = buildEconomicBrief(
                rates: ref.read(currencyRatesProvider).valueOrNull,
                keyRate: ref.read(keyRateProvider).valueOrNull,
                crypto: crypto,
                stocks: stocks,
                commodities: ref.read(commoditiesProvider).valueOrNull,
                fearGreed: ref.read(fearGreedProvider).valueOrNull,
              );
              final report = buildWeeklyReport(
                watchlistKeys: watchlist,
                allAssets: [...crypto, ...stocks],
                rates: ref.read(currencyRatesProvider).valueOrNull,
                crypto: crypto,
                stocks: stocks,
                commodities: ref.read(commoditiesProvider).valueOrNull,
                briefLines: brief,
                locale: l10n.localeName,
              );
              await Share.share(report, subject: 'EcoPulse report');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.exportReportDone),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ),
        const Gap(8),
        Card(
          child: ListTile(
            leading: Icon(Iconsax.import_1, color: palette.accent),
            title: Text(l10n.backupImportTitle),
            subtitle: Text(
              l10n.backupImportSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            onTap: () => _showImportDialog(context, ref, l10n),
          ),
        ),
      ],
    );
  }

/// Приватный метод [_showImportDialog] класса [BackupSettingsSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  Future<void> _showImportDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.backupImportTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: controller,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: l10n.backupImportHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.backupImportConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final payload = BackupService.instance.parseJson(controller.text);
      final count = await BackupService.instance.restore(payload);
      BackupService.instance.invalidateProviders(ref);
      await CustomizationSync.applyAfterRestore(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backupImportSuccess(count)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backupImportError(userErrorMessage(e, l10n: l10n))),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      controller.dispose();
    }
  }
}
