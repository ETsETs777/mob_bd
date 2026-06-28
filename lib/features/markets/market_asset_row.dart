// =============================================================================
// EcoPulse · lib/features/markets/market_asset_row.dart
// Автор: Цымбал Е. В.
// Дата: 09.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: market_asset_row.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/market_list_utils.dart';
import '../../data/models/market_asset.dart';
import '../../providers/watchlist_provider.dart';
import '../asset_detail/asset_detail_screen.dart' show sourceLabelForAsset;
import '../shared/widgets/app_hover.dart';
import '../shared/widgets/metric_card.dart';

/// Compact list row with inline sparkline on the right.
class MarketAssetRow extends StatelessWidget {
/// Создаёт [MarketAssetRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const MarketAssetRow({
    super.key,
    required this.asset,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

/// Поле [asset] класса [MarketAssetRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final MarketAsset asset;
/// Поле [onTap] класса [MarketAssetRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final VoidCallback onTap;
/// Поле [isFavorite] класса [MarketAssetRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
  final bool isFavorite;
/// Поле [onToggleFavorite] класса [MarketAssetRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final VoidCallback onToggleFavorite;

/// Отрисовывает UI [MarketAssetRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isBond = asset.type == AssetType.bondRu;
    final priceText = isBond
        ? Formatters.bondPrice(asset.price)
        : asset.currency == 'RUB'
            ? Formatters.rub(asset.price)
            : Formatters.price(asset.price, symbol: '\$');
    final change = asset.changePercent;
    final badge = sourceLabelForAsset(asset);
    final en = Localizations.localeOf(context).languageCode == 'en';
    final bondMeta = isBond ? bondSubtitle(asset, english: en) : null;

    return AppHoverSurface(
      borderRadius: 16,
      clickable: true,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: assetHeroTitleTag(asset),
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                asset.symbol,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: palette.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        if (badge.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: palette.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: palette.border),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                fontSize: 9,
                                color: palette.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      asset.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bondMeta != null && bondMeta.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        bondMeta,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.accent.withValues(alpha: 0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          priceText,
                          style: AppTypography.quote(
                            TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (change >= 0
                                    ? palette.positive
                                    : palette.negative)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: change >= 0
                                  ? palette.positive
                                  : palette.negative,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (asset.sparkline.length > 1) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 76,
                  height: 44,
                  child: RepaintBoundary(
                    child: MiniSparkline(
                      values: asset.sparkline,
                      height: 44,
                    ),
                  ),
                ),
              ],
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isFavorite ? Iconsax.star_1 : Iconsax.star,
                  size: 20,
                  color: isFavorite ? palette.accent : palette.textSecondary,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onToggleFavorite();
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
