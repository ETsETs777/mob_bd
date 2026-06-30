import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/customization/customization_preset.dart';
import '../../core/customization/customization_sync.dart';
import '../../shared/widgets/preset_style_tile.dart';
import '../../core/customization/preset_marketplace_catalog.dart';
import '../../core/customization/preset_share_link.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_presets_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/locale_provider.dart';

/// Marketplace встроенных пресетов: описание, apply, share link.
class CustomizationPresetMarketplace extends ConsumerWidget {
  const CustomizationPresetMarketplace({
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
    final activeId = config.meta.activePresetId;

    Future<void> applyPreset(CustomizationPreset preset) async {
      await CustomizationSync.commitPreset(ref, preset);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.customizationPresetApplied(preset.label(isRu: isRu))),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    Future<void> sharePreset(CustomizationPreset preset) async {
      final link = PresetShareLink.encode(preset);
      await Share.share(
        '${preset.label(isRu: isRu)}\n$link',
        subject: l10n.customizationPresetShareSubject,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.shop, color: palette.accent, size: 22),
                const Gap(10),
                Expanded(
                  child: Text(
                    l10n.customizationPresetMarketplaceTitle,
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
              l10n.customizationPresetMarketplaceSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            for (final entry in PresetMarketplaceCatalog.entries) ...[
              _MarketplaceTile(
                palette: palette,
                preset: presets.firstWhere((p) => p.id == entry.presetId),
                entry: entry,
                isRu: isRu,
                isActive: activeId == entry.presetId,
                onApply: applyPreset,
                onShare: sharePreset,
                applyLabel: l10n.customizationPresetMarketplaceApply,
                shareLabel: l10n.customizationPresetShareLink,
              ),
              const Gap(8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MarketplaceTile extends StatelessWidget {
  const _MarketplaceTile({
    required this.palette,
    required this.preset,
    required this.entry,
    required this.isRu,
    required this.isActive,
    required this.onApply,
    required this.onShare,
    required this.applyLabel,
    required this.shareLabel,
  });

  final AppPalette palette;
  final CustomizationPreset preset;
  final PresetMarketplaceEntry entry;
  final bool isRu;
  final bool isActive;
  final Future<void> Function(CustomizationPreset preset) onApply;
  final Future<void> Function(CustomizationPreset preset) onShare;
  final String applyLabel;
  final String shareLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? palette.accent : palette.border,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PresetStyleTile(
                  preset: preset,
                  label: '',
                  selected: isActive,
                  palette: palette,
                  onTap: () => onApply(preset),
                  size: 56,
                  showLabel: false,
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset.label(isRu: isRu),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        entry.description(isRu: isRu),
                        style: TextStyle(fontSize: 12, color: palette.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: entry.tags(isRu: isRu).map((tag) {
                return Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 11)),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () => onApply(preset),
                  child: Text(applyLabel),
                ),
                OutlinedButton.icon(
                  onPressed: () => onShare(preset),
                  icon: const Icon(Iconsax.link_2, size: 16),
                  label: Text(shareLabel, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
