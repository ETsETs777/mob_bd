// =============================================================================
// EcoPulse · lib/features/markets/watchlist_volatility_heatmap.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Heatmap волатильности активов из watchlist.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/watchlist_volatility.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/watchlist_provider.dart';
import '../asset_detail/asset_detail_screen.dart';

/// Heatmap годовой волатильности для текущего watchlist.
class WatchlistVolatilityHeatmap extends ConsumerWidget {
  const WatchlistVolatilityHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final keys = ref.watch(watchlistProvider);
    if (keys.isEmpty) return const SizedBox.shrink();

    final assets = _resolveWatchlistAssets(ref, keys);
    if (assets.isEmpty) return const SizedBox.shrink();

    final snapshot = buildWatchlistVolatilityHeatmap(assets);
    if (snapshot.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.chart_21, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.watchlistVolatilityTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              l10n.watchlistVolatilitySubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(4),
            Row(
              children: [
                _LegendDot(color: palette.positive, label: l10n.watchlistVolatilityLow),
                const Gap(12),
                _LegendDot(color: palette.negative, label: l10n.watchlistVolatilityHigh),
              ],
            ),
            const Gap(12),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                const minCell = 96.0;
                final cols =
                    ((constraints.maxWidth + spacing) / (minCell + spacing))
                        .floor()
                        .clamp(2, 4);
                final cellWidth =
                    (constraints.maxWidth - spacing * (cols - 1)) / cols;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: snapshot.cells.map((cell) {
                    final factor = volatilityHeatFactor(
                      cell.annualVolPercent,
                      snapshot.minAnnualVol,
                      snapshot.maxAnnualVol,
                    );
                    final bg = Color.lerp(
                      palette.positive.withValues(alpha: 0.22),
                      palette.negative.withValues(alpha: 0.28),
                      factor,
                    )!;
                    final border = Color.lerp(
                      palette.positive.withValues(alpha: 0.5),
                      palette.negative.withValues(alpha: 0.55),
                      factor,
                    )!;

                    return SizedBox(
                      width: cellWidth,
                      child: Material(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => openAppPage(
                            context,
                            AssetDetailScreen(asset: cell.asset),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cell.asset.symbol,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: palette.textPrimary,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  l10n.watchlistVolatilityAnnual(
                                    Formatters.percent(cell.annualVolPercent),
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: palette.textPrimary,
                                  ),
                                ),
                                if (cell.changePercent != null) ...[
                                  const Gap(2),
                                  Text(
                                    Formatters.percent(cell.changePercent!),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: cell.changePercent! >= 0
                                          ? palette.positive
                                          : palette.negative,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<MarketAsset> _resolveWatchlistAssets(
    WidgetRef ref,
    List<String> keys,
  ) {
    final all = <MarketAsset>[];
    ref.watch(cryptoProvider).valueOrNull?.assets.forEach(all.add);
    ref.watch(stocksProvider).valueOrNull?.forEach(all.add);
    ref.watch(bondsProvider).valueOrNull?.forEach(all.add);
    if (all.isEmpty) return [];

    return keys
        .map((k) => assetFromKey(k, all))
        .whereType<MarketAsset>()
        .toList();
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.35),
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
        ),
        const Gap(6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: palette.textSecondary),
        ),
      ],
    );
  }
}
