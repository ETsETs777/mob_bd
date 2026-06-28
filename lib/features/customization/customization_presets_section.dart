import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/customization/customization_preset.dart';
import '../../core/customization/customization_presets.dart';
import '../../core/customization/customization_sync.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_presets_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/locale_provider.dart';

class CustomizationPresetsSection extends ConsumerWidget {
  const CustomizationPresetsSection({
    super.key,
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isRu = ref.watch(localeProvider) == AppLocale.ru;
    final config = ref.watch(customizationProvider);
    final presets = ref.watch(allCustomizationPresetsProvider);
    final userPresets = ref.watch(userCustomizationPresetsProvider);
    final activeId = config.meta.activePresetId;

    Future<void> applyPreset(String id) async {
      final preset = presets.firstWhere((p) => p.id == id);
      await CustomizationSync.commit(
        ref,
        CustomizationPresets.withActivePreset(config, preset),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.customizationPresetApplied(preset.label(isRu: isRu))),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.layer, color: palette.accent, size: 22),
                const Gap(10),
                Expanded(
                  child: Text(
                    l10n.customizationPresetsTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(6),
            Text(
              l10n.customizationPresetsHint,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in presets)
                  FilterChip(
                    label: Text(preset.label(isRu: isRu)),
                    selected: activeId == preset.id,
                    onSelected: (_) => applyPreset(preset.id),
                  ),
              ],
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Iconsax.save_2, size: 18),
                  label: Text(l10n.customizationPresetSave),
                  onPressed: () => _savePreset(context, ref, l10n, isRu),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Iconsax.export_1, size: 18),
                  label: Text(l10n.customizationPresetExport),
                  onPressed: userPresets.isEmpty
                      ? null
                      : () => _exportPreset(context, ref, l10n, isRu, userPresets),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Iconsax.import_1, size: 18),
                  label: Text(l10n.customizationPresetImport),
                  onPressed: () => _importPreset(context, ref, l10n),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePreset(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isRu,
  ) async {
    final ruController = TextEditingController();
    final enController = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customizationPresetSaveDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ruController,
              decoration: InputDecoration(labelText: l10n.customizationPresetNameRu),
            ),
            const Gap(8),
            TextField(
              controller: enController,
              decoration: InputDecoration(labelText: l10n.customizationPresetNameEn),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.profileSave),
          ),
        ],
      ),
    );

    if (ok != true) {
      ruController.dispose();
      enController.dispose();
      return;
    }

    final nameRu = ruController.text.trim();
    final nameEn = enController.text.trim();
    ruController.dispose();
    enController.dispose();

    if (nameRu.isEmpty && nameEn.isEmpty) return;

    final preset = await ref.read(userCustomizationPresetsProvider.notifier).saveFromCurrent(
          nameRu: nameRu.isEmpty ? nameEn : nameRu,
          nameEn: nameEn.isEmpty ? nameRu : nameEn,
        );

    await CustomizationSync.commit(
      ref,
      ref.read(customizationProvider).copyWith(
            meta: ref.read(customizationProvider).meta.copyWith(
                  activePresetId: preset.id,
                ),
          ),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.customizationPresetSaved(preset.label(isRu: isRu))),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _exportPreset(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isRu,
    List<CustomizationPreset> userPresets,
  ) async {
    final selectedId = ref.read(customizationProvider).meta.activePresetId;
    String? exportId;
    if (selectedId != null && userPresets.any((p) => p.id == selectedId)) {
      exportId = selectedId;
    } else if (userPresets.length == 1) {
      exportId = userPresets.first.id;
    } else {
      exportId = await showDialog<String>(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l10n.customizationPresetExport),
          children: [
            for (final preset in userPresets)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, preset.id),
                child: Text(preset.label(isRu: isRu)),
              ),
          ],
        ),
      );
    }

    if (exportId == null) return;

    final json = ref.read(userCustomizationPresetsProvider.notifier).exportPreset(exportId);
    await Share.share(json, subject: l10n.customizationPresetShareSubject);
  }

  Future<void> _importPreset(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customizationPresetImport),
        content: TextField(
          controller: controller,
          maxLines: 8,
          decoration: InputDecoration(hintText: l10n.customizationPresetImportHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.customizationPresetImport),
          ),
        ],
      ),
    );

    if (ok != true) {
      controller.dispose();
      return;
    }

    try {
      final preset =
          await ref.read(userCustomizationPresetsProvider.notifier).importFromJson(
                controller.text,
              );
      controller.dispose();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.customizationPresetImportSuccess(preset.nameRu)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      controller.dispose();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.customizationPresetImportError),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
