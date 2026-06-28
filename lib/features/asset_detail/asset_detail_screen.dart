// =============================================================================
// EcoPulse · lib/features/asset_detail/asset_detail_screen.dart
// Автор: Цымбал Е. В.
// Дата: 13.06.2026
// Детальная карточка актива с графиком. Файл: asset_detail_screen.
// =============================================================================

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/chart_share.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/candle_point.dart';
import '../../data/models/chart_period.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../markets/asset_note_field.dart';
import '../../core/customization/chart_context_profiles.dart';
import '../../providers/chart_customization_provider.dart';
import '../../providers/customization_provider.dart';
import '../shared/widgets/charts.dart';
import '../shared/widgets/custom_chart_view.dart';
import '../shared/widgets/loading_skeleton.dart';

/// Класс [AssetDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
class AssetDetailScreen extends ConsumerStatefulWidget {
/// Создаёт [AssetDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  const AssetDetailScreen({super.key, required this.asset});

/// Поле [asset] класса [AssetDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  final MarketAsset asset;

/// Создаёт State для [AssetDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

/// Приватный класс [_AssetDetailScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
/// Поле [_chartKey] класса [_AssetDetailScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final _chartKey = GlobalKey();

/// Отрисовывает UI [_AssetDetailScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final period = ChartContextProfiles.periodFromKey(
      ref.watch(resolvedChartConfigProvider(ChartContextId.assetDetail)).periodKey,
    );
    final chartMode = ref.watch(chartDisplayModeProvider);
    final detailAsync = ref.watch(
      assetDetailProvider(AssetDetailParams(asset: widget.asset, days: period.days)),
    );
    final isFavorite =
        ref.watch(watchlistProvider).contains(watchlistKey(widget.asset));

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: assetHeroTitleTag(widget.asset),
          child: Material(
            color: Colors.transparent,
            child: Text(widget.asset.symbol),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_3),
            tooltip: l10n.shareChart,
            onPressed: () => shareWidgetAsPng(
              boundaryKey: _chartKey,
              fileName: '${widget.asset.symbol}_chart.png',
              text: '${widget.asset.symbol} · EcoPulse',
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Iconsax.star_1 : Iconsax.star,
              color: isFavorite ? palette.accent : palette.textSecondary,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(watchlistProvider.notifier).toggle(widget.asset);
            },
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const LoadingSkeleton(itemCount: 2),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.errorGeneric(e.toString()),
                style: TextStyle(color: palette.negative),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(
                  assetDetailProvider(
                    AssetDetailParams(asset: widget.asset, days: period.days),
                  ),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (detail) {
          final isBond = widget.asset.type == AssetType.bondRu;
          final priceText = isBond
              ? Formatters.bondPrice(widget.asset.price)
              : widget.asset.currency == 'RUB'
                  ? Formatters.rub(widget.asset.price)
                  : Formatters.price(widget.asset.price);
          final canShowCandles = detail.candles.length >= 2 &&
              widget.asset.type != AssetType.crypto;
          final useCandles =
              canShowCandles && chartMode == ChartDisplayMode.candlestick;
          final currencySymbol =
              widget.asset.currency == 'RUB' ? '₽' : '\$';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (widget.asset.imageUrl != null)
                Center(
                  child: Hero(
                    tag: assetHeroIconTag(widget.asset),
                    child: CachedNetworkImage(
                      imageUrl: widget.asset.imageUrl!,
                      width: 56,
                      height: 56,
                      placeholder: (_, __) => SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.accent,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Iconsax.chart,
                        size: 48,
                        color: palette.accent,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                widget.asset.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                priceText,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                Formatters.percent(widget.asset.changePercent),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.asset.isPositive
                      ? palette.positive
                      : palette.negative,
                ),
              ),
              if (isBond) ...[
                const SizedBox(height: 16),
                if (widget.asset.yieldPercent != null)
                  _InfoRow(
                    label: l10n.bondYieldLabel,
                    value: Formatters.bondYield(widget.asset.yieldPercent),
                  ),
                if (widget.asset.couponPercent != null)
                  _InfoRow(
                    label: l10n.bondCouponLabel,
                    value: Formatters.percent(widget.asset.couponPercent),
                  ),
                if (widget.asset.maturityDate != null)
                  _InfoRow(
                    label: l10n.bondMaturityLabel,
                    value: Formatters.date(widget.asset.maturityDate!),
                  ),
                if (widget.asset.faceValue != null)
                  _InfoRow(
                    label: l10n.bondFaceValueLabel,
                    value: Formatters.rub(widget.asset.faceValue!),
                  ),
                if (widget.asset.nextCouponDate != null)
                  _InfoRow(
                    label: l10n.bondNextCouponLabel,
                    value: Formatters.date(widget.asset.nextCouponDate!),
                  ),
                if (widget.asset.couponValueRub != null)
                  _InfoRow(
                    label: l10n.bondCouponValueLabel,
                    value: Formatters.rub(widget.asset.couponValueRub!),
                  ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    l10n.chartTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (canShowCandles) ...[
                    SegmentedButton<ChartDisplayMode>(
                      segments: [
                        ButtonSegment(
                          value: ChartDisplayMode.line,
                          icon: const Icon(Iconsax.chart_2, size: 16),
                          label: Text(l10n.chartLine, style: const TextStyle(fontSize: 11)),
                        ),
                        ButtonSegment(
                          value: ChartDisplayMode.candlestick,
                          icon: const Icon(Iconsax.chart_21, size: 16),
                          label: Text(l10n.chartCandles, style: const TextStyle(fontSize: 11)),
                        ),
                      ],
                      selected: {chartMode},
                      onSelectionChanged: (set) {
                        HapticFeedback.selectionClick();
                        ref.read(chartDisplayModeProvider.notifier).state =
                            set.first;
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  SegmentedButton<ChartPeriod>(
                    segments: ChartPeriod.values
                        .map(
                          (p) => ButtonSegment(
                            value: p,
                            label: Text(
                              p.label,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    selected: {period},
                    onSelectionChanged: (set) {
                      HapticFeedback.selectionClick();
                      final selected = set.first;
                      ref.read(chartPeriodProvider.notifier).state = selected;
                      final config = ref.read(customizationProvider);
                      final profile = config.charts
                          .profileFor(ChartContextId.assetDetail)
                          .copyWith(
                            useGlobalDefaults: false,
                            periodKey: selected.name,
                          );
                      ref.read(customizationProvider.notifier).updateCharts(
                            ChartContextProfiles.updateProfile(
                              config.charts,
                              ChartContextId.assetDetail,
                              profile,
                            ),
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ChartCaptureBoundary(
                captureKey: _chartKey,
                child: CustomChartView(
                  contextId: ChartContextId.assetDetail,
                  overrideType: useCandles ? ChartTypeId.candlestick : null,
                  input: ChartRenderInput(
                    points: detail.history,
                    candles: detail.candles,
                    currencySymbol: currencySymbol,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _InfoRow(
                label: l10n.assetType,
                value: _typeLabel(widget.asset.type, l10n),
              ),
              _InfoRow(label: l10n.assetCurrency, value: widget.asset.currency),
              _InfoRow(
                label: l10n.assetSource,
                value: _sourceLabel(widget.asset.type),
              ),
              const SizedBox(height: 20),
              AssetNoteField(assetKey: watchlistKey(widget.asset)),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

/// Приватный метод [_typeLabel] класса [_AssetDetailScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  String _typeLabel(AssetType type, AppLocalizations l10n) => switch (type) {
        AssetType.crypto => l10n.assetTypeCrypto,
        AssetType.stockRu => l10n.assetTypeStockRu,
        AssetType.stockUs => l10n.assetTypeStockUs,
        AssetType.bondRu => l10n.assetTypeBondRu,
      };

/// Приватный метод [_sourceLabel] класса [_AssetDetailScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  String _sourceLabel(AssetType type) => switch (type) {
        AssetType.crypto => 'CoinGecko',
        AssetType.stockRu => 'MOEX ISS',
        AssetType.stockUs => 'Finnhub',
        AssetType.bondRu => 'MOEX ISS',
      };
}

/// Приватный класс [_InfoRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class _InfoRow extends StatelessWidget {
/// Создаёт [_InfoRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  const _InfoRow({required this.label, required this.value});

/// Поле [label] класса [_InfoRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final String label;
/// Поле [value] класса [_InfoRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  final String value;

/// Отрисовывает UI [_InfoRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: palette.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Функция [sourceLabelForAsset] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
String sourceLabelForAsset(MarketAsset asset) => switch (asset.type) {
      AssetType.crypto => 'CoinGecko',
      AssetType.stockRu => 'MOEX',
      AssetType.stockUs => 'Finnhub',
      AssetType.bondRu => 'MOEX',
    };

/// Функция [sourceLabelForCurrency] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
String sourceLabelForCurrency({required bool isRub}) =>
    isRub ? 'MOEX' : 'Frankfurter';
