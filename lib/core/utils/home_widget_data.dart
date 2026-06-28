// =============================================================================
// EcoPulse · lib/core/utils/home_widget_data.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Разрешение метрик для Android home widget (2×2 / 4×1).
// =============================================================================

import '../../core/utils/formatters.dart';
import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/inflation_point.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import '../../providers/widget_config_provider.dart';

/// Данные одного слота виджета.
class HomeWidgetSlotData {
  const HomeWidgetSlotData({
    required this.label,
    required this.value,
    required this.change,
  });

  final String label;
  final String value;
  final String change;
}

/// Снимок всех слотов для записи в home_widget.
class HomeWidgetPayload {
  const HomeWidgetPayload({
    required this.layout,
    required this.slots,
    required this.updatedAt,
  });

  final WidgetLayout layout;
  final List<HomeWidgetSlotData> slots;
  final DateTime updatedAt;

  bool get isExpanded =>
      layout == WidgetLayout.expanded ||
      (layout == WidgetLayout.auto && slots.length > 2);
}

/// Разрешает метрику в label/value/change для виджета.
HomeWidgetSlotData resolveHomeWidgetMetric(
  WidgetMetric metric, {
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
  List<CommodityQuote>? commodities,
  KeyRateSnapshot? keyRate,
  PortfolioSnapshot? portfolio,
  List<InflationPoint>? inflation,
}) {
  switch (metric) {
    case WidgetMetric.usdRub:
      final usd = _firstOrNull(
        rates?.where((r) => r.isRub && r.code == 'USD'),
      );
      return HomeWidgetSlotData(
        label: metric.label,
        value: usd != null ? Formatters.rub(usd.rate) : '—',
        change: usd?.changePercent != null
            ? Formatters.percent(usd!.changePercent)
            : '',
      );
    case WidgetMetric.eurRub:
      final eur = _firstOrNull(
        rates?.where((r) => r.base == 'RUB' && r.code == 'EUR'),
      );
      return HomeWidgetSlotData(
        label: metric.label,
        value: eur != null ? Formatters.rub(eur.rate) : '—',
        change: eur?.changePercent != null
            ? Formatters.percent(eur!.changePercent)
            : '',
      );
    case WidgetMetric.btc:
      final btc = _firstOrNull(crypto?.where((a) => a.symbol == 'BTC'));
      return HomeWidgetSlotData(
        label: metric.label,
        value: btc != null ? Formatters.price(btc.price) : '—',
        change: btc != null ? Formatters.percent(btc.changePercent) : '',
      );
    case WidgetMetric.eth:
      final eth = _firstOrNull(crypto?.where((a) => a.symbol == 'ETH'));
      return HomeWidgetSlotData(
        label: metric.label,
        value: eth != null ? Formatters.price(eth.price) : '—',
        change: eth != null ? Formatters.percent(eth.changePercent) : '',
      );
    case WidgetMetric.keyRate:
      return HomeWidgetSlotData(
        label: metric.label,
        value: keyRate != null
            ? '${keyRate.current.toStringAsFixed(2)}%'
            : '—',
        change: '',
      );
    case WidgetMetric.brent:
      final brent = _firstOrNull(commodities?.where((c) => c.id == 'brent'));
      return HomeWidgetSlotData(
        label: metric.label,
        value: brent != null ? brent.price.toStringAsFixed(0) : '—',
        change: brent?.changePercent != null
            ? Formatters.percent(brent!.changePercent)
            : '',
      );
    case WidgetMetric.wti:
      final wti = _firstOrNull(commodities?.where((c) => c.id == 'wti'));
      return HomeWidgetSlotData(
        label: metric.label,
        value: wti != null ? wti.price.toStringAsFixed(0) : '—',
        change: wti?.changePercent != null
            ? Formatters.percent(wti!.changePercent)
            : '',
      );
    case WidgetMetric.imoex:
      final imoex = _firstOrNull(stocks?.where((a) => a.symbol == 'IMOEX'));
      return HomeWidgetSlotData(
        label: metric.label,
        value: imoex != null ? imoex.price.toStringAsFixed(0) : '—',
        change: imoex != null ? Formatters.percent(imoex.changePercent) : '',
      );
    case WidgetMetric.portfolioPnl:
      if (portfolio == null) {
        return const HomeWidgetSlotData(
          label: 'Portfolio',
          value: '—',
          change: '',
        );
      }
      return HomeWidgetSlotData(
        label: metric.label,
        value: Formatters.rub(portfolio.totalValueRub),
        change: Formatters.percent(portfolio.pnlPercent),
      );
    case WidgetMetric.inflationRu:
      final ru = _firstOrNull(
        inflation?.where((p) => p.countryCode == 'RU'),
      );
      return HomeWidgetSlotData(
        label: metric.label,
        value: ru != null ? '${ru.value.toStringAsFixed(1)}%' : '—',
        change: ru != null ? '${ru.year}' : '',
      );
  }
}

/// Список слотов по конфигу (2 для compact, 4 для expanded).
List<HomeWidgetSlotData> buildHomeWidgetSlots({
  required WidgetConfig config,
  List<CurrencyRate>? rates,
  List<MarketAsset>? crypto,
  List<MarketAsset>? stocks,
  List<CommodityQuote>? commodities,
  KeyRateSnapshot? keyRate,
  PortfolioSnapshot? portfolio,
  List<InflationPoint>? inflation,
}) {
  final metrics = config.activeMetrics;
  return [
    for (final m in metrics)
      resolveHomeWidgetMetric(
        m,
        rates: rates,
        crypto: crypto,
        stocks: stocks,
        commodities: commodities,
        keyRate: keyRate,
        portfolio: portfolio,
        inflation: inflation,
      ),
  ];
}

T? _firstOrNull<T>(Iterable<T>? items) {
  if (items == null) return null;
  final iterator = items.iterator;
  if (!iterator.moveNext()) return null;
  return iterator.current;
}
