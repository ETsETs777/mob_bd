// =============================================================================
// EcoPulse · test/watchlist_hero_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit/widget тест: watchlist_hero_test.
// =============================================================================

import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/providers/watchlist_provider.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
void main() {
  test('watchlistKey is unique per asset type', () {
    const bond = MarketAsset(
      id: 'SU26238',
      symbol: 'SU26238',
      name: 'ОФЗ',
      price: 100,
      changePercent: 0,
      currency: 'RUB',
      type: AssetType.bondRu,
    );
    const stock = MarketAsset(
      id: 'SU26238',
      symbol: 'SBER',
      name: 'Sber',
      price: 100,
      changePercent: 0,
      currency: 'RUB',
      type: AssetType.stockRu,
    );

    expect(watchlistKey(bond), isNot(watchlistKey(stock)));
    expect(assetHeroTitleTag(bond), 'asset-title-bondRu:SU26238');
    expect(assetHeroIconTag(stock), 'asset-icon-stockRu:SU26238');
  });
}
