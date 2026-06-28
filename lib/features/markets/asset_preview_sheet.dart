// =============================================================================
// EcoPulse · lib/features/markets/asset_preview_sheet.dart
// Автор: Цымбал Е. В.
// Дата: 06.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: asset_preview_sheet.
// =============================================================================

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';



import '../../core/motion/app_motion.dart';

import '../../core/theme/app_palette.dart';

import '../../core/utils/formatters.dart';
/// Функция [showAssetPreviewSheet] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026

import '../../data/models/market_asset.dart';

import '../../l10n/app_localizations.dart';

import '../../providers/watchlist_provider.dart';

import '../portfolio/paper_portfolio_screen.dart';

import 'asset_note_field.dart';

import '../asset_detail/asset_detail_screen.dart';

import '../shared/widgets/metric_card.dart';



/// Функция [showAssetPreviewSheet] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
void showAssetPreviewSheet(

  BuildContext context,

  WidgetRef ref,

  MarketAsset asset,

) {

  final palette = AppPalette.of(context);

  HapticFeedback.lightImpact();



  showAppBottomSheet<void>(
/// Приватный класс [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026

/// Создаёт [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
    context,

    isScrollControlled: true,

    backgroundColor: palette.surface,

/// Поле [asset] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
    shape: const RoundedRectangleBorder(
/// Поле [scrollController] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026

/// Поле [onOpenDetail] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

/// Отрисовывает UI [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
    ),

    builder: (sheetContext) => DraggableScrollableSheet(

      expand: false,

      snap: true,

      snapSizes: const [0.4, 0.55, 0.9],

      initialChildSize: 0.55,

      minChildSize: 0.32,

      maxChildSize: 0.92,

      builder: (_, scrollController) => _AssetPreviewBody(

        asset: asset,

        scrollController: scrollController,

        onOpenDetail: () {

          Navigator.pop(sheetContext);

          openAppPage(context, AssetDetailScreen(asset: asset));

        },

      ),

    ),

  );

}



/// Приватный класс [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class _AssetPreviewBody extends ConsumerWidget {

/// Создаёт [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const _AssetPreviewBody({

    required this.asset,

    required this.scrollController,

    required this.onOpenDetail,

  });



/// Поле [asset] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final MarketAsset asset;

/// Поле [scrollController] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final ScrollController scrollController;

/// Поле [onOpenDetail] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final VoidCallback onOpenDetail;



/// Отрисовывает UI [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override

  Widget build(BuildContext context, WidgetRef ref) {

    final palette = AppPalette.of(context);

    final l10n = AppLocalizations.of(context)!;

    final isFav = ref.watch(watchlistProvider).contains(watchlistKey(asset));



    final priceText = asset.type == AssetType.bondRu

        ? Formatters.bondPrice(asset.price)

        : asset.currency == 'RUB'

            ? Formatters.rub(asset.price)

            : Formatters.price(asset.price, symbol: '\$');



    return ListView(

      controller: scrollController,

      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),

      children: [

        Center(

          child: Container(

            width: 40,

            height: 4,

            decoration: BoxDecoration(

              color: palette.border,

              borderRadius: BorderRadius.circular(2),

            ),

          ),

        ),

        const Gap(16),

        Row(

          children: [

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Hero(

                    tag: assetHeroTitleTag(asset),

                    child: Material(

                      color: Colors.transparent,

                      child: Text(

                        asset.symbol,

                        style: Theme.of(context)

                            .textTheme

                            .headlineSmall

                            ?.copyWith(fontWeight: FontWeight.bold),

                      ),

                    ),

                  ),

                  Text(

                    asset.name,

                    style: TextStyle(color: palette.textSecondary),

                  ),

                ],

              ),

            ),

            IconButton(

              icon: Icon(

                isFav ? Iconsax.star_1 : Iconsax.star,

                color: isFav ? palette.accent : palette.textSecondary,

              ),

              onPressed: () {
/// Приватный метод [_typeLabel] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026

                HapticFeedback.lightImpact();

                ref.read(watchlistProvider.notifier).toggle(asset);

              },

            ),
/// Приватный класс [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026

/// Создаёт [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
          ],

/// Поле [label] класса [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
        ),
/// Поле [value] класса [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026

        const Gap(12),
/// Отрисовывает UI [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026

        Text(

          priceText,

          style: TextStyle(

            fontSize: 32,

            fontWeight: FontWeight.w700,

            color: palette.textPrimary,

            fontFeatures: const [FontFeature.tabularFigures()],

          ),

        ),

        if (asset.changePercent != 0) ...[

          const Gap(6),

          Container(

            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

            decoration: BoxDecoration(

              color: (asset.isPositive ? palette.positive : palette.negative)

                  .withValues(alpha: 0.12),

              borderRadius: BorderRadius.circular(8),

            ),

            child: Text(

              Formatters.percent(asset.changePercent),

              style: TextStyle(

                color: asset.isPositive ? palette.positive : palette.negative,

                fontWeight: FontWeight.w600,

              ),

            ),

          ),

        ],

        if (asset.sparkline.length > 1) ...[

          const Gap(20),

          MiniSparkline(values: asset.sparkline, height: 72),

        ],

        if (asset.isBond) ...[

          const Gap(16),

          Wrap(

            spacing: 8,

            runSpacing: 8,

            children: [

              if (asset.yieldPercent != null)

                _InfoChip(

                  label: l10n.bondYieldLabel,

                  value: Formatters.bondYield(asset.yieldPercent),

                ),

              if (asset.couponPercent != null)

                _InfoChip(

                  label: l10n.bondCouponLabel,

                  value: Formatters.percent(asset.couponPercent),

                ),

              if (asset.maturityDate != null)

                _InfoChip(

                  label: l10n.bondMaturityLabel,

                  value: Formatters.date(asset.maturityDate!),

                ),

              if (asset.nextCouponDate != null)

                _InfoChip(

                  label: l10n.bondNextCouponLabel,

                  value: Formatters.date(asset.nextCouponDate!),

                ),

              if (asset.couponValueRub != null)

                _InfoChip(

                  label: l10n.bondCouponValueLabel,

                  value: Formatters.rub(asset.couponValueRub!),

                ),

            ],

          ),

        ],

        const Gap(20),

        Row(

          children: [

            _InfoChip(

              label: l10n.assetType,

              value: _typeLabel(asset, l10n),

            ),

            const Gap(8),

            _InfoChip(

              label: l10n.assetCurrency,

              value: asset.currency,

            ),

          ],

        ),

        const Gap(8),

        _InfoChip(

          label: l10n.assetSource,

          value: sourceLabelForAsset(asset),

        ),

        const Gap(16),

        AssetNoteField(assetKey: watchlistKey(asset)),

        const Gap(24),

        FilledButton.icon(

          onPressed: onOpenDetail,

          icon: const Icon(Iconsax.chart_2),

          label: Text(l10n.assetPreviewOpen),

        ),

        const Gap(8),

        OutlinedButton.icon(

          onPressed: () => buyAssetForPortfolio(context, ref, asset),

          icon: const Icon(Iconsax.wallet_add),

          label: Text(l10n.portfolioBuyAction),

        ),

        const Gap(8),

        OutlinedButton.icon(

          onPressed: () {

            HapticFeedback.lightImpact();

            ref.read(watchlistProvider.notifier).toggle(asset);

          },

          icon: Icon(isFav ? Iconsax.star_1 : Iconsax.star),

          label: Text(

            isFav ? l10n.assetPreviewRemoveWatchlist : l10n.assetPreviewAddWatchlist,

          ),

        ),

      ],

    );

  }



/// Приватный метод [_typeLabel] класса [_AssetPreviewBody].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  String _typeLabel(MarketAsset asset, AppLocalizations l10n) => switch (asset.type) {

        AssetType.crypto => l10n.assetTypeCrypto,

        AssetType.stockRu => l10n.assetTypeStockRu,

        AssetType.stockUs => l10n.assetTypeStockUs,

        AssetType.bondRu => l10n.assetTypeBondRu,

      };

}



/// Приватный класс [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _InfoChip extends StatelessWidget {

/// Создаёт [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const _InfoChip({required this.label, required this.value});



/// Поле [label] класса [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final String label;

/// Поле [value] класса [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String value;



/// Отрисовывает UI [_InfoChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override

  Widget build(BuildContext context) {

    final palette = AppPalette.of(context);

    return Container(

      width: 160,

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      decoration: BoxDecoration(

        color: palette.surfaceLight,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: palette.border),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(

            label,

            style: TextStyle(color: palette.textSecondary, fontSize: 11),

          ),

          const Gap(2),

          Text(

            value,

            style: TextStyle(

              color: palette.textPrimary,

              fontWeight: FontWeight.w600,

              fontSize: 13,

            ),

          ),

        ],

      ),

    );

  }

}

