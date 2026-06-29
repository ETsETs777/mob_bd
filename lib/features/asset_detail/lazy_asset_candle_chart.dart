import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/candle_history_utils.dart';
import '../../data/models/candle_point.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/price_point.dart';
import '../../providers/app_providers.dart';
import '../shared/widgets/custom_chart_view.dart';
import '../../core/customization/chart_registry.dart';
import '../../data/models/user_customization.dart';

/// График актива с lazy-load свечей при pan влево.
class LazyAssetCandleChart extends ConsumerStatefulWidget {
  const LazyAssetCandleChart({
    super.key,
    required this.asset,
    required this.initialCandles,
    required this.initialHistory,
    required this.currencySymbol,
    required this.contextId,
  });

  final MarketAsset asset;
  final List<CandlePoint> initialCandles;
  final List<PricePoint> initialHistory;
  final String currencySymbol;
  final ChartContextId contextId;

  @override
  ConsumerState<LazyAssetCandleChart> createState() =>
      _LazyAssetCandleChartState();
}

class _LazyAssetCandleChartState extends ConsumerState<LazyAssetCandleChart> {
  static const _maxCandles = 365;
  static const _chunkDays = 30;

  late List<CandlePoint> _candles;
  late List<PricePoint> _history;
  bool _loadingMore = false;
  bool _exhausted = false;

  @override
  void initState() {
    super.initState();
    _candles = List<CandlePoint>.from(widget.initialCandles);
    _history = List<PricePoint>.from(widget.initialHistory);
  }

  @override
  void didUpdateWidget(LazyAssetCandleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCandles != widget.initialCandles ||
        oldWidget.initialHistory != widget.initialHistory) {
      _candles = List<CandlePoint>.from(widget.initialCandles);
      _history = List<PricePoint>.from(widget.initialHistory);
      _exhausted = false;
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _exhausted || _candles.length < 2) return;
    if (_candles.length >= _maxCandles) {
      setState(() => _exhausted = true);
      return;
    }

    setState(() => _loadingMore = true);
    try {
      final oldest = _candles.first.date;
      final older = await ref.read(marketRepositoryProvider).fetchOlderCandles(
            widget.asset,
            before: oldest,
            days: _chunkDays,
          );
      if (!mounted) return;
      if (older.isEmpty) {
        setState(() => _exhausted = true);
        return;
      }

      final mergedCandles = mergeCandleHistory(_candles, older);
      final olderPoints = older
          .map((c) => PricePoint(date: c.date, value: c.close))
          .toList();
      setState(() {
        _candles = mergedCandles;
        _history = mergePriceHistory(_history, olderPoints);
        if (mergedCandles.length >= _maxCandles) _exhausted = true;
      });
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomChartView(
      contextId: widget.contextId,
      overrideType: ChartTypeId.candlestick,
      input: ChartRenderInput(
        points: _history,
        candles: _candles,
        currencySymbol: widget.currencySymbol,
        onLoadMoreCandles: _exhausted ? null : _loadMore,
      ),
    );
  }
}
