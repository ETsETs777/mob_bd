import '../../data/models/market_asset.dart';

/// Тик с Binance miniTicker stream.
class LiveCryptoTick {
  const LiveCryptoTick({
    required this.symbol,
    required this.price,
    required this.changePercent24h,
    required this.updatedAt,
  });

  final String symbol;
  final double price;
  final double changePercent24h;
  final DateTime updatedAt;
}

/// Парсинг Binance combined stream / miniTicker payload.
LiveCryptoTick? parseBinanceMiniTicker(Map<String, dynamic> json) {
  final data = json['data'] as Map<String, dynamic>? ?? json;
  final event = data['e'] as String?;
  if (event != null && event != '24hrMiniTicker') return null;

  final pair = data['s'] as String?;
  if (pair == null || !pair.endsWith('USDT')) return null;

  final price = double.tryParse(data['c']?.toString() ?? '');
  if (price == null) return null;

  final change = double.tryParse(data['P']?.toString() ?? '') ?? 0;

  return LiveCryptoTick(
    symbol: pair.substring(0, pair.length - 4),
    price: price,
    changePercent24h: change,
    updatedAt: DateTime.now().toUtc(),
  );
}

List<MarketAsset> applyLiveCryptoPrices(
  List<MarketAsset> assets,
  Map<String, LiveCryptoTick> liveBySymbol,
) {
  if (liveBySymbol.isEmpty) return assets;

  return assets.map((asset) {
    if (asset.type != AssetType.crypto) return asset;
    final tick = liveBySymbol[asset.symbol];
    if (tick == null) return asset;
    return asset.copyWith(
      price: tick.price,
      changePercent: tick.changePercent24h,
    );
  }).toList();
}

String binanceUsdtPair(String symbol) => '${symbol.toUpperCase()}USDT';
