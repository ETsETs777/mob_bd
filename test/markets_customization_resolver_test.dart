import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/markets_customization_resolver.dart';
import 'package:ecopulse/core/utils/market_list_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MarketsCustomizationResolver maps stock region keys', () {
    expect(
      MarketsCustomizationResolver.parseStockRegion('RU'),
      StockMarketRegion.moex,
    );
    expect(
      MarketsCustomizationResolver.parseStockRegion('US'),
      StockMarketRegion.us,
    );
    expect(
      MarketsCustomizationResolver.parseStockRegion('ALL'),
      StockMarketRegion.all,
    );
    expect(
      MarketsCustomizationResolver.parseStockRegion('unknown'),
      StockMarketRegion.all,
    );
  });

  test('MarketsCustomizationResolver resolves markets flags', () {
    final markets = CustomizationDefaults.create().markets.copyWith(
          groupStocksBySector: true,
          showSectorHeatmap: false,
          defaultStockRegion: 'US',
          listRowCompact: true,
        );

    final resolved = MarketsCustomizationResolver.resolve(markets);

    expect(resolved.groupStocksBySector, isTrue);
    expect(resolved.showSectorHeatmap, isFalse);
    expect(resolved.defaultStockRegion, StockMarketRegion.us);
    expect(resolved.listRowCompact, isTrue);
  });

  test('updateDefaultStockRegion mutates config', () {
    final updated = MarketsCustomizationResolver.updateDefaultStockRegion(
      CustomizationDefaults.create().markets,
      StockMarketRegion.moex,
    );

    expect(updated.defaultStockRegion, 'RU');
  });
}
