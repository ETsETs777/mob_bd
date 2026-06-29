// =============================================================================
// EcoPulse · lib/features/markets/sector_heatmap.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/moex_sectors.dart';
import '../../core/utils/correlation_utils.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/market_list_utils.dart';
import '../../core/utils/sector_labels.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/markets/stock_market_provider.dart';
import '../shared/widgets/charts.dart';

class SectorHeatmapCard extends ConsumerWidget {
  const SectorHeatmapCard({super.key, required this.stocks});

  final List<MarketAsset> stocks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final activeSector = ref.watch(moexSectorFilterProvider);

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

    void selectSector(String sectorKey) {
      ref.read(moexSectorFilterProvider.notifier).state = sectorKey;
      ref.read(stockMarketRegionProvider.notifier).state = StockMarketRegion.moex;
      ref.read(stocksGroupedListProvider.notifier).state = false;
    }

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
              l10n.sectorHeatmapTapHint,
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
                final selected = activeSector == key;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => selectSector(key),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: selected ? 0.22 : 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? palette.accent : color.withValues(alpha: 0.35),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      '${sectorLabelForKey(key, l10n)} ${Formatters.percent(avg)}',
                      style: TextStyle(
                        color: selected ? palette.accent : color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
