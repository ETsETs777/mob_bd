import '../../core/utils/market_list_utils.dart';
import '../../data/models/user_customization.dart';

/// Эффективные настройки экрана «Рынки» из [MarketsCustomization].
class ResolvedMarkets {
  const ResolvedMarkets({
    required this.groupStocksBySector,
    required this.showSectorHeatmap,
    required this.defaultStockRegion,
    required this.listRowCompact,
  });

  final bool groupStocksBySector;
  final bool showSectorHeatmap;
  final StockMarketRegion defaultStockRegion;
  final bool listRowCompact;
}

/// Резолвер настроек рынков EcoPulse.
class MarketsCustomizationResolver {
  MarketsCustomizationResolver._();

  static const defaultRegionKeys = ['ALL', 'RU', 'US'];

  static ResolvedMarkets resolve(MarketsCustomization markets) {
    return ResolvedMarkets(
      groupStocksBySector: markets.groupStocksBySector,
      showSectorHeatmap: markets.showSectorHeatmap,
      defaultStockRegion: parseStockRegion(markets.defaultStockRegion),
      listRowCompact: markets.listRowCompact,
    );
  }

  static StockMarketRegion parseStockRegion(String raw) {
    return switch (raw.toUpperCase()) {
      'RU' || 'MOEX' => StockMarketRegion.moex,
      'US' => StockMarketRegion.us,
      _ => StockMarketRegion.all,
    };
  }

  static String stockRegionKey(StockMarketRegion region) {
    return switch (region) {
      StockMarketRegion.moex => 'RU',
      StockMarketRegion.us => 'US',
      StockMarketRegion.all => 'ALL',
    };
  }

  static MarketsCustomization updateDefaultStockRegion(
    MarketsCustomization markets,
    StockMarketRegion region,
  ) =>
      markets.copyWith(defaultStockRegion: stockRegionKey(region));
}
