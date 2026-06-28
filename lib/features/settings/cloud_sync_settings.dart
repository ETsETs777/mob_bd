// =============================================================================
// EcoPulse · lib/features/settings/cloud_sync_settings.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Cloud sync: экспорт/импорт JSON через файл или мессенджер.
// =============================================================================

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/customization/customization_sync.dart';
import '../../core/services/backup_service.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/cloud_sync.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/cloud_sync_provider.dart';

/// Карточка cloud sync в настройках.
class CloudSyncSettingsCard extends ConsumerStatefulWidget {
  const CloudSyncSettingsCard({super.key});

  @override
  ConsumerState<CloudSyncSettingsCard> createState() =>
      _CloudSyncSettingsCardState();
}

class _CloudSyncSettingsCardState extends ConsumerState<CloudSyncSettingsCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cloudSyncProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final sync = ref.watch(cloudSyncProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat('d MMM yyyy · HH:mm', locale);

    final statusText = switch (sync.pending) {
      CloudSyncPendingState.synced => l10n.cloudSyncStatusSynced,
      CloudSyncPendingState.localChanges => l10n.cloudSyncStatusPending,
      CloudSyncPendingState.neverSynced => l10n.cloudSyncStatusNever,
    };

    final statusColor = switch (sync.pending) {
      CloudSyncPendingState.synced => palette.positive,
      CloudSyncPendingState.localChanges => palette.accent,
      CloudSyncPendingState.neverSynced => palette.textSecondary,
    };

    final lastOut = sync.meta.lastSyncOutAt;
    final lastIn = sync.meta.lastSyncInAt;

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
                    l10n.cloudSyncTitle,
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
              l10n.cloudSyncSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      fontSize: 13,
                    ),
                  ),
                  if (lastOut != null) ...[
                    const Gap(4),
                    Text(
                      l10n.cloudSyncLastOut(dateFmt.format(lastOut)),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (lastIn != null) ...[
                    const Gap(2),
                    Text(
                      l10n.cloudSyncLastIn(dateFmt.format(lastIn)),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _syncOut(context, ref, l10n),
                    icon: const Icon(Iconsax.export_1, size: 18),
                    label: Text(l10n.cloudSyncExport),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _syncIn(context, ref, l10n),
                    icon: const Icon(Iconsax.import_1, size: 18),
                    label: Text(l10n.cloudSyncImport),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _syncOut(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final json = ref.read(cloudSyncProvider.notifier).exportJson();
    try {
      await Share.share(
        json,
        subject: l10n.cloudSyncShareSubject,
      );
      await ref.read(cloudSyncProvider.notifier).markSyncOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cloudSyncExportDone),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cloudSyncError(e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _syncIn(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      String? json;

      if (kIsWeb) {
        await _showPasteImport(context, ref, l10n);
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.bytes != null) {
        json = String.fromCharCodes(file.bytes!);
      }

      if (json == null || json.trim().isEmpty) return;

      final count =
          await ref.read(cloudSyncProvider.notifier).importFromJson(json);
      BackupService.instance.invalidateProviders(ref);
      await CustomizationSync.applyAfterRestore(ref);
      ref.read(cloudSyncProvider.notifier).refresh();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cloudSyncImportSuccess(count)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on CloudSyncException catch (e) {
      if (context.mounted) {
        final message = e.code == 'remote_not_newer'
            ? l10n.cloudSyncImportNotNewer
            : l10n.cloudSyncError(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cloudSyncError(e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _showPasteImport(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cloudSyncImport),
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
            child: Text(l10n.cloudSyncImport),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final count = await ref
          .read(cloudSyncProvider.notifier)
          .importFromJson(controller.text);
      BackupService.instance.invalidateProviders(ref);
      await CustomizationSync.applyAfterRestore(ref);
      ref.read(cloudSyncProvider.notifier).refresh();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cloudSyncImportSuccess(count)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on CloudSyncException catch (e) {
      if (context.mounted) {
        final message = e.code == 'remote_not_newer'
            ? l10n.cloudSyncImportNotNewer
            : l10n.cloudSyncError(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      controller.dispose();
    }
  }
}
