import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/customization/chart_registry.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/price_point.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../shared/widgets/custom_chart_view.dart';

/// Мини-превью текущих настроек кастомизации.
class CustomizationPreview extends ConsumerWidget {  const CustomizationPreview({
    super.key,
    required this.config,
    required this.palette,
  });

  final UserCustomization config;
  final AppPalette palette;

  static List<PricePoint> _samplePoints() {
    final now = DateTime.now();
    return List.generate(
      14,
      (i) => PricePoint(
        date: now.subtract(Duration(days: 13 - i)),
        value: 88 + i * 0.45 + (i % 4) * 0.15,
      ),
    );
  }

  double _chartHeight(ChartHeightPreset preset) => switch (preset) {
        ChartHeightPreset.compact => 100,
        ChartHeightPreset.normal => 130,
        ChartHeightPreset.tall => 160,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isRu = ref.watch(localeProvider) == AppLocale.ru;
    final charts = config.charts;
    final appearance = config.appearance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customizationPreview,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
                color: palette.surface.withValues(alpha: 0.6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: palette.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          l10n.customizationPreviewSample,
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  CustomChartView(
                    contextId: ChartContextId.currency,
                    height: _chartHeight(charts.defaultHeight),
                    input: ChartRenderInput(
                      points: _samplePoints(),
                      currencySymbol: '₽',
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Chip(
                  label: l10n.customizationPreviewTheme(appearance.themeModeKey),
                  palette: palette,
                ),
                _Chip(
                  label: l10n.customizationPreviewAccent(appearance.accentKey),
                  palette: palette,
                ),
                _Chip(
                  label: ChartRegistry.describe(charts.defaultType).label(isRu: isRu),
                  palette: palette,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.palette});

  final String label;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: palette.textSecondary),
      ),
    );
  }
}
