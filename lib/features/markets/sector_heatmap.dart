// =============================================================================
// EcoPulse · lib/features/markets/sector_heatmap.dart
// Автор: Цымбал Е. В.
// Дата: 10.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: sector_heatmap.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants/moex_sectors.dart';
import '../../core/utils/correlation_utils.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/sector_labels.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/charts.dart';

/// StatelessWidget [SectorHeatmapCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
class SectorHeatmapCard extends StatelessWidget {
/// Создаёт [SectorHeatmapCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  const SectorHeatmapCard({super.key, required this.stocks});

/// Поле [stocks] класса [SectorHeatmapCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final List<MarketAsset> stocks;

/// Отрисовывает UI [SectorHeatmapCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    final ruStocks = stocks.where((a) => a.type == AssetType.stockRu);
    final sectorItems = ruStocks
        .map((a) {
          final sector = moexSectorKey(a.symbol);
          if (sector == null) return null;
          final weekly = changeFromSparkline(a.sparkline) ?? a.changePercent;
          return (sector: sector, change: weekly);
        })
        .whereType<({String sector, double change})>()
        .toList();

    if (sectorItems.isEmpty) return const SizedBox.shrink();

    final averages = averageChangeBySector(sectorItems);
    final keys = averages.keys.toList()
      ..sort((a, b) => averages[b]!.compareTo(averages[a]!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sectorHeatmapTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Gap(4),
            Text(
              l10n.sectorHeatmapSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(16),
            BarChartWidget(
              labels: keys.map((k) => sectorLabelForKey(k, l10n)).toList(),
              values: keys.map((k) => averages[k]!.abs()).toList(),
              height: 160,
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keys.map((key) {
                final avg = averages[key]!;
                final color = avg >= 0 ? palette.positive : palette.negative;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    '${sectorLabelForKey(key, l10n)} ${Formatters.percent(avg)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
