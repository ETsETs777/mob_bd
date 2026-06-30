// =============================================================================
// EcoPulse · lib/features/settings/widget_settings.dart
// Автор: Цымбал Е. В.
// Дата: 19.06.2026
// Настройки Android home widget: layout 4×1 / 2×2 и 4 метрики.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/customization/customization_sync.dart';
import '../../../core/customization/widget_customization_resolver.dart';
import '../../../core/services/home_widget_refresh_pipeline.dart';
import '../../../core/theme/app_palette.dart';
import '../../../data/models/user_customization.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/commodities_provider.dart';
import '../../../providers/customization_provider.dart';
import '../../../providers/paper_portfolio_provider.dart';
import '../../../providers/widget_config_provider.dart';
import '../../../providers/widget_customization_provider.dart';

class WidgetSettingsCard extends ConsumerWidget {
  const WidgetSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final config = ref.watch(resolvedWidgetConfigProvider);

    Future<void> refreshWidget() async {
      await HomeWidgetRefreshPipeline.refresh(ref.read);
    }

    Future<void> commitWidgets(WidgetCustomization widgets) async {
      await CustomizationSync.commit(
        ref,
        ref.read(customizationProvider).copyWith(widgets: widgets),
      );
      await refreshWidget();
    }

    String metricLabel(WidgetMetric metric) => switch (metric) {
          WidgetMetric.usdRub => l10n.widgetMetricUsdRub,
          WidgetMetric.eurRub => l10n.widgetMetricEurRub,
          WidgetMetric.btc => l10n.widgetMetricBtc,
          WidgetMetric.eth => l10n.widgetMetricEth,
          WidgetMetric.keyRate => l10n.widgetMetricKeyRate,
          WidgetMetric.brent => l10n.widgetMetricBrent,
          WidgetMetric.wti => l10n.widgetMetricWti,
          WidgetMetric.imoex => l10n.widgetMetricImoex,
          WidgetMetric.portfolioPnl => l10n.widgetMetricPortfolio,
          WidgetMetric.inflationRu => l10n.widgetMetricInflationRu,
        };

    String layoutLabel(WidgetLayout layout) => switch (layout) {
          WidgetLayout.auto => l10n.settingsWidgetLayoutAuto,
          WidgetLayout.compact => l10n.settingsWidgetLayoutCompact,
          WidgetLayout.expanded => l10n.settingsWidgetLayoutExpanded,
        };

    Widget metricDropdown(
      String label,
      WidgetMetric value,
      Future<void> Function(WidgetMetric) onChanged,
    ) {
      return DropdownButtonFormField<WidgetMetric>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: WidgetMetric.values
            .map(
              (m) => DropdownMenuItem(
                value: m,
                child: Text(metricLabel(m)),
              ),
            )
            .toList(),
        onChanged: (v) async {
          if (v == null) return;
          await onChanged(v);
        },
      );
    }

    final showExpandedSlots =
        config.layout == WidgetLayout.expanded || config.layout == WidgetLayout.auto;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.mobile, color: palette.accent, size: 22),
                const Gap(10),
                Expanded(
                  child: Text(
                    l10n.settingsWidgetConfigTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: l10n.retry,
                  onPressed: refreshWidget,
                ),
              ],
            ),
            Text(
              l10n.settingsWidgetConfigSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const Gap(12),
            DropdownButtonFormField<WidgetLayout>(
              value: config.layout,
              decoration: InputDecoration(labelText: l10n.settingsWidgetLayout),
              items: WidgetLayout.values
                  .map(
                    (layout) => DropdownMenuItem(
                      value: layout,
                      child: Text(layoutLabel(layout)),
                    ),
                  )
                  .toList(),
              onChanged: (v) async {
                if (v == null) return;
                await commitWidgets(
                  WidgetCustomizationResolver.updateLayout(
                    ref.read(customizationProvider).widgets,
                    v,
                  ),
                );
              },
            ),
            const Gap(8),
            metricDropdown(l10n.settingsWidgetSlot1, config.slot1, (v) async {
              await commitWidgets(
                WidgetCustomizationResolver.updateSlot(
                  ref.read(customizationProvider).widgets,
                  0,
                  v,
                ),
              );
            }),
            const Gap(8),
            metricDropdown(l10n.settingsWidgetSlot2, config.slot2, (v) async {
              await commitWidgets(
                WidgetCustomizationResolver.updateSlot(
                  ref.read(customizationProvider).widgets,
                  1,
                  v,
                ),
              );
            }),
            if (showExpandedSlots) ...[
              const Gap(8),
              metricDropdown(l10n.settingsWidgetSlot3, config.slot3, (v) async {
                await commitWidgets(
                  WidgetCustomizationResolver.updateSlot(
                    ref.read(customizationProvider).widgets,
                    2,
                    v,
                  ),
                );
              }),
              const Gap(8),
              metricDropdown(l10n.settingsWidgetSlot4, config.slot4, (v) async {
                await commitWidgets(
                  WidgetCustomizationResolver.updateSlot(
                    ref.read(customizationProvider).widgets,
                    3,
                    v,
                  ),
                );
              }),
            ],
            const Gap(8),
            Text(
              l10n.settingsWidgetLayoutHint,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
