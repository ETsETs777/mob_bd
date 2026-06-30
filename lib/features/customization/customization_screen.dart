import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/customization/customization_sync.dart';
import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_provider.dart';
import 'customization_preset_marketplace.dart';
import 'customization_presets_section.dart';
import 'customization_preview.dart';
import 'customization_section_screen.dart';
import 'customization_theme_ab_preview.dart';
import 'customization_widget_preview.dart';
import 'customization_sync_panel.dart';

/// Hub кастомизации: превью, presets, sync и навигация по секциям.
class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({super.key});

  static const _sections = CustomizationSection.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final config = ref.watch(customizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customizationTitle),
        actions: [
          TextButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.customizationResetAll),
                  content: Text(l10n.customizationResetAllConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.customizationResetAll),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await CustomizationSync.resetAll(ref);
              }
            },
            child: Text(l10n.customizationResetAll),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.scaled(context, 16)),
        children: [
          Text(
            l10n.customizationSubtitle,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
          ),
          const Gap(16),
          CustomizationPreview(config: config, palette: palette),
          const Gap(16),
          CustomizationWidgetPreview(palette: palette),
          const Gap(16),
          CustomizationThemeAbPreview(palette: palette),
          const Gap(16),
          CustomizationPresetsSection(palette: palette),
          const Gap(16),
          CustomizationPresetMarketplace(palette: palette),
          const Gap(16),
          const CustomizationSyncPanel(),
          const Gap(8),
          Text(
            l10n.customizationHubSectionsTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const Gap(8),
          ..._sections.map(
            (section) => _CustomizationHubTile(
              icon: _iconFor(section),
              title: CustomizationSectionScreen.titleFor(section, l10n),
              palette: palette,
              onTap: () => openAppPage(
                context,
                CustomizationSectionScreen(section: section),
              ),
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }

  static IconData _iconFor(CustomizationSection section) => switch (section) {
        CustomizationSection.charts => Iconsax.chart_2,
        CustomizationSection.appearance => Iconsax.brush_2,
        CustomizationSection.home => Iconsax.home_2,
        CustomizationSection.navigation => Iconsax.routing_2,
        CustomizationSection.markets => Iconsax.chart_21,
        CustomizationSection.portfolio => Iconsax.wallet_3,
        CustomizationSection.widgets => Iconsax.element_3,
        CustomizationSection.dataDisplay => Iconsax.document_text,
        CustomizationSection.assistant => Iconsax.message,
      };
}

class _CustomizationHubTile extends StatelessWidget {
  const _CustomizationHubTile({
    required this.icon,
    required this.title,
    required this.palette,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: palette.accent),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          trailing: Icon(
            Iconsax.arrow_right_3,
            color: palette.textSecondary,
            size: 18,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
