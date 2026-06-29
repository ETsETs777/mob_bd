// =============================================================================
// EcoPulse · lib/data/repositories/market_repository.dart
// Автор: Цымбал Е. В.
// Дата: 14.05.2026
// Репозитории: загрузка и кэширование из API. Файл: market_repository.
// =============================================================================

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/api_config.dart';
import '../../core/constants/market_catalog.dart';
import '../models/candle_point.dart';
import '../models/market_asset.dart';
import '../models/price_point.dart';
import '../services/api_client.dart';
import '../services/cache_service.dart';
import '../utils/moex_parser.dart';

/// Репозиторий [MarketRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
class MarketRepository {
/// Создаёт [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  MarketRepository(this._dio, this._cache);

/// Поле [_dio] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final Dio _dio;
/// Поле [_cache] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final CacheService _cache;

/// Поле [_cryptoCacheKey] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static const _cryptoCacheKey = 'crypto_markets';
/// Поле [_stockCacheKey] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static const _stockCacheKey = 'stock_markets';
/// Поле [_bondCacheKey] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static const _bondCacheKey = 'bond_markets';
/// Поле [_moexTopTickersKey] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static const _moexTopTickersKey = 'moex_top_tickers';
/// Поле [_indicesCacheKey] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static const _indicesCacheKey = 'us_indices';

/// Метод [fetchCrypto] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<List<MarketAsset>> fetchCrypto({bool force = false, int pages = 1}) async {
    final targetPages = pages.clamp(1, CryptoCatalog.pages);

    if (!force &&
        targetPages >= CryptoCatalog.pages &&
        _cache.isFresh(
          _cryptoCacheKey,
          Duration(minutes: ApiConfig.cacheCryptoMinutes),
        )) {
      final cached = _cache.getList(_cryptoCacheKey, _cryptoFromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    if (!force && targetPages == 1) {
      final cached = _cache.getList(_cryptoCacheKey, _cryptoFromJson);
      if (cached != null && cached.length >= CryptoCatalog.perPage) {
        return cached.take(CryptoCatalog.perPage).toList();
      }
    }

    final assets = <MarketAsset>[];
    for (var page = 1; page <= targetPages; page++) {
      assets.addAll(await fetchCryptoPage(page));
    }

    if (targetPages >= CryptoCatalog.pages) {
      await _cache.set(_cryptoCacheKey, assets.map(_cryptoToJson).toList());
      await _cache.markFresh(_cryptoCacheKey);
    }
    return assets;
  }

/// Метод [fetchCryptoPage] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<List<MarketAsset>> fetchCryptoPage(int page) async {
    final response = await _dio.get<List<dynamic>>(
      '${ApiConfig.coinGeckoBase}/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': CryptoCatalog.perPage,
        'page': page,
        'sparkline': true,
        'price_change_percentage': '24h',
      },
      options: Options(headers: coinGeckoHeaders()),
    );

    return (response.data ?? []).map((item) {
      final map = item as Map<String, dynamic>;
      final sparkline =
          (map['sparkline_in_7d']?['price'] as List<dynamic>? ?? [])
              .map((e) => (e as num).toDouble())
              .toList();

      return MarketAsset(
        id: map['id'] as String,
        symbol: (map['symbol'] as String).toUpperCase(),
        name: map['name'] as String,
        price: (map['current_price'] as num?)?.toDouble() ?? 0,
        changePercent:
            (map['price_change_percentage_24h'] as num?)?.toDouble() ?? 0,
        type: AssetType.crypto,
        sparkline: sparkline,
        imageUrl: map['image'] as String?,
      );
    }).toList();
  }

/// Метод [fetchStocks] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<List<MarketAsset>> fetchStocks({bool force = false}) async {
    if (!force &&
        _cache.isFresh(
          _stockCacheKey,
          Duration(minutes: ApiConfig.cacheStockMinutes),
        )) {
      final cached = _cache.getList(_stockCacheKey, _stockFromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final assets = <MarketAsset>[];

    final extraTickers = await _fetchMoexTopSecids(limit: 25);
    final moexTickers = {
      ...MoexCatalog.tickers,
      ...extraTickers,
    }.toList();
    final moexResults = await _fetchMoexBatch(moexTickers);
    assets.addAll(moexResults);

    if (ApiConfig.finnhubKey.isNotEmpty) {
      final usResults = await _fetchUsBatch(UsCatalog.tickers);
      assets.addAll(usResults);
    }

    await _cache.set(_stockCacheKey, assets.map(_stockToJson).toList());
    await _cache.markFresh(_stockCacheKey);
    return assets;
  }

/// Метод [fetchBonds] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<List<MarketAsset>> fetchBonds({bool force = false}) async {
    if (!force &&
        _cache.isFresh(
          _bondCacheKey,
          Duration(minutes: ApiConfig.cacheStockMinutes),
        )) {
      final cached = _cache.getList(_bondCacheKey, _bondFromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final assets = await _fetchMoexBondBatch(BondCatalog.secids);
    if (assets.isNotEmpty) {
      await _cache.set(_bondCacheKey, assets.map(_bondToJson).toList());
      await _cache.markFresh(_bondCacheKey);
    }
    return assets;
  }

/// Приватный метод [_fetchMoexBondBatch] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<List<MarketAsset>> _fetchMoexBondBatch(List<String> secids) async {
    const chunkSize = 5;
    final results = <MarketAsset>[];
    for (var i = 0; i < secids.length; i += chunkSize) {
      final end = (i + chunkSize > secids.length) ? secids.length : i + chunkSize;
      final chunk = secids.sublist(i, end);
      final batch = await Future.wait(
        chunk.map((id) async {
          try {
            return await _fetchMoexBond(id);
          } catch (_) {
            return null;
          }
        }),
      );
      results.addAll(batch.whereType<MarketAsset>());
    }
    return results;
  }

/// Приватный метод [_fetchMoexBond] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<MarketAsset> _fetchMoexBond(String secid) async {
    final catalog = BondCatalog.bySecid(secid);
    final path =
        '${ApiConfig.moexBase}/engines/stock/markets/bonds/boards/TQOB/securities/$secid.json';

    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {'iss.only': 'marketdata,securities', 'iss.meta': 'off'},
    );

    final marketData = response.data?['marketdata'] as Map<String, dynamic>?;
    final securities = response.data?['securities'] as Map<String, dynamic>?;
    final mColumns =
        (marketData?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
    final sColumns =
        (securities?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
    final mRow =
        (marketData?['data'] as List<dynamic>?)?.firstOrNull as List<dynamic>?;
    final sRow =
        (securities?['data'] as List<dynamic>?)?.firstOrNull as List<dynamic>?;

    double? cell(List<dynamic>? row, List<String> cols, String name) {
      if (row == null) return null;
      final idx = cols.indexOf(name);
      if (idx < 0) return null;
      return (row[idx] as num?)?.toDouble();
    }

    String? cellStr(List<dynamic>? row, List<String> cols, String name) {
      if (row == null) return null;
      final idx = cols.indexOf(name);
      if (idx < 0) return null;
      return row[idx]?.toString();
    }

    final last = cell(mRow, mColumns, 'LAST') ?? cell(mRow, mColumns, 'LCURRENTPRICE') ?? 0;
    final change = cell(mRow, mColumns, 'LASTCHANGEPRCNT') ?? 0;
    final yieldPct = cell(mRow, mColumns, 'YIELD') ?? cell(mRow, mColumns, 'YIELDATWAPRICE');
    final shortName = cellStr(sRow, sColumns, 'SHORTNAME') ?? catalog?.labelRu ?? secid;
    final coupon = cell(sRow, sColumns, 'COUPONPERCENT');
    final face = cell(sRow, sColumns, 'FACEVALUE') ?? 1000;
    final matStr = cellStr(sRow, sColumns, 'MATDATE');
    DateTime? maturity;
    if (matStr != null && matStr.length >= 10) {
      maturity = DateTime.tryParse(matStr.substring(0, 10));
    }
    final nextCouponStr =
        cellStr(sRow, sColumns, 'NEXTCOUPON') ?? cellStr(sRow, sColumns, 'BUYBACKDATE');
    DateTime? nextCoupon;
    if (nextCouponStr != null && nextCouponStr.length >= 10) {
      nextCoupon = DateTime.tryParse(nextCouponStr.substring(0, 10));
    }
    final couponValue = cell(sRow, sColumns, 'COUPONVALUE');
    final couponPeriod = cell(sRow, sColumns, 'COUPONPERIOD')?.round();

    final sparkline = await _fetchMoexBondCandles(secid);

    return MarketAsset(
      id: secid,
      symbol: secid,
      name: shortName,
      price: last,
      changePercent: change,
      type: AssetType.bondRu,
      sparkline: sparkline,
      currency: 'RUB',
      yieldPercent: yieldPct,
      couponPercent: coupon,
      maturityDate: maturity,
      bondCategory: catalog?.category ?? BondCategory.corporate,
      faceValue: face,
      nextCouponDate: nextCoupon,
      couponValueRub: couponValue,
      couponPeriodDays: couponPeriod,
    );
  }

  /// Топ ликвидных акций TQBR, которых нет в статическом каталоге.
  Future<List<String>> _fetchMoexTopSecids({int limit = 25}) async {
    const cacheFresh = Duration(hours: 24);
    if (_cache.isFresh(_moexTopTickersKey, cacheFresh)) {
      final cached = _readStringListCache(_moexTopTickersKey);
      if (cached != null) return cached;
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/stock/markets/shares/boards/TQBR/securities.json',
        queryParameters: {
          'iss.only': 'marketdata',
          'marketdata.columns': 'SECID,VALTODAY',
          'iss.meta': 'off',
        },
      );
      final block = response.data?['marketdata'] as Map<String, dynamic>?;
      final columns = (block?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
      final rows = block?['data'] as List<dynamic>? ?? [];
      final secIdx = columns.indexOf('SECID');
      final valIdx = columns.indexOf('VALTODAY');
      if (secIdx < 0 || valIdx < 0) return [];

      final catalogSet = MoexCatalog.tickers.toSet();
      final ranked = <({String secid, double val})>[];
      for (final row in rows) {
        final list = row as List<dynamic>;
        final secid = list[secIdx]?.toString();
        final val = (list[valIdx] as num?)?.toDouble() ?? 0;
        if (secid == null || secid.isEmpty || catalogSet.contains(secid)) continue;
        if (val <= 0) continue;
        ranked.add((secid: secid, val: val));
      }
      ranked.sort((a, b) => b.val.compareTo(a.val));
      final result = ranked.take(limit).map((e) => e.secid).toList();
      if (result.isNotEmpty) {
        await _cache.set(_moexTopTickersKey, result);
        await _cache.markFresh(_moexTopTickersKey);
      }
      return result;
    } catch (_) {
      return _readStringListCache(_moexTopTickersKey) ?? [];
    }
  }

/// Приватный метод [_readStringListCache] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  List<String>? _readStringListCache(String key) {
    final raw = _cache.getString(key);
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as List<dynamic>).map((e) => e.toString()).toList();
    } catch (_) {
      return null;
    }
  }

/// Приватный метод [_fetchMoexBondCandles] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<List<double>> _fetchMoexBondCandles(String secid) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 7));
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/stock/markets/bonds/securities/$secid/candles.json',
        queryParameters: {
          'from': _dateFmt(from),
          'till': _dateFmt(till),
          'interval': 24,
        },
      );
      final candles = response.data?['candles'] as Map<String, dynamic>?;
      final columns = (candles?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
      final rows = candles?['data'] as List<dynamic>? ?? [];
      final closeIdx = columns.indexOf('close');
      if (closeIdx < 0) return [];
      return rows
          .map((row) => ((row as List<dynamic>)[closeIdx] as num).toDouble())
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Метод [fetchUsIndices] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<List<MarketAsset>> fetchUsIndices({bool force = false}) async {
    if (ApiConfig.finnhubKey.isEmpty) return [];

    if (!force &&
        _cache.isFresh(
          _indicesCacheKey,
          Duration(minutes: ApiConfig.cacheStockMinutes),
        )) {
      final cached = _cache.getList(_indicesCacheKey, _stockFromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final assets = <MarketAsset>[];
    for (final entry in UsIndicesCatalog.entries) {
      try {
        final asset = await _fetchFinnhubStock(entry.ticker);
        assets.add(
          MarketAsset(
            id: asset.id,
            symbol: asset.symbol,
            name: entry.displayName,
            price: asset.price,
            changePercent: asset.changePercent,
            type: asset.type,
            sparkline: asset.sparkline,
            currency: asset.currency,
          ),
        );
      } catch (_) {}
    }

    if (assets.isNotEmpty) {
      await _cache.set(_indicesCacheKey, assets.map(_stockToJson).toList());
      await _cache.markFresh(_indicesCacheKey);
    }
    return assets;
  }

/// Приватный метод [_fetchMoexBatch] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<List<MarketAsset>> _fetchMoexBatch(List<String> tickers) async {
    const chunkSize = 6;
    final results = <MarketAsset>[];
    for (var i = 0; i < tickers.length; i += chunkSize) {
      final end = (i + chunkSize > tickers.length) ? tickers.length : i + chunkSize;
      final chunk = tickers.sublist(i, end);
      final batch = await Future.wait(
        chunk.map((ticker) async {
          try {
            return await _fetchMoexStock(ticker);
          } catch (_) {
            return null;
          }
        }),
      );
      results.addAll(batch.whereType<MarketAsset>());
    }
    return results;
  }

/// Приватный метод [_fetchUsBatch] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<List<MarketAsset>> _fetchUsBatch(List<String> tickers) async {
    const chunkSize = 8;
    final results = <MarketAsset>[];
    for (var i = 0; i < tickers.length; i += chunkSize) {
      final end = (i + chunkSize > tickers.length) ? tickers.length : i + chunkSize;
      final chunk = tickers.sublist(i, end);
      final batch = await Future.wait(
        chunk.map((ticker) async {
          try {
            return await _fetchFinnhubStock(ticker);
          } catch (_) {
            return null;
          }
        }),
      );
      results.addAll(batch.whereType<MarketAsset>());
    }
    return results;
  }

/// Приватный метод [_fetchMoexStock] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<MarketAsset> _fetchMoexStock(String ticker) async {
    final entry = MoexCatalog.byTicker(ticker);
    final isIndex = entry?.isIndex ?? ticker == 'IMOEX' || ticker == 'RTSI';
    final isEtf = entry?.sector == 'etf';
    final path = isIndex
        ? '${ApiConfig.moexBase}/engines/stock/markets/index/securities/$ticker.json'
        : isEtf
            ? '${ApiConfig.moexBase}/engines/stock/markets/shares/boards/TQTF/securities/$ticker.json'
            : '${ApiConfig.moexBase}/engines/stock/markets/shares/boards/TQBR/securities/$ticker.json';

    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {'iss.only': 'marketdata,securities', 'iss.meta': 'off'},
    );

    final marketData = response.data?['marketdata'] as Map<String, dynamic>?;
    final securities = response.data?['securities'] as Map<String, dynamic>?;
    final mColumns =
        (marketData?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
    final sColumns =
        (securities?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
    final mRow =
        (marketData?['data'] as List<dynamic>?)?.firstOrNull as List<dynamic>?;
    final sRow =
        (securities?['data'] as List<dynamic>?)?.firstOrNull as List<dynamic>?;

    final lastIdx = mColumns.indexOf('LAST');
    final changeIdx = mColumns.indexOf('LASTCHANGEPRCNT');
    final nameIdx = sColumns.indexOf('SHORTNAME');

    final sparkline = await _fetchMoexCandles(
      ticker,
      isIndex: isIndex,
      isEtf: isEtf,
    );

    return MarketAsset(
      id: ticker,
      symbol: ticker,
      name: sRow != null && nameIdx >= 0
          ? sRow[nameIdx] as String? ?? ticker
          : ticker,
      price: mRow != null && lastIdx >= 0
          ? (mRow[lastIdx] as num?)?.toDouble() ?? 0
          : 0,
      changePercent: mRow != null && changeIdx >= 0
          ? (mRow[changeIdx] as num?)?.toDouble() ?? 0
          : 0,
      type: AssetType.stockRu,
      sparkline: sparkline,
      currency: 'RUB',
    );
  }

/// Приватный метод [_fetchMoexCandles] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<List<double>> _fetchMoexCandles(
    String ticker, {
    required bool isIndex,
    bool isEtf = false,
  }) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 7));
    final fmt = _dateFmt;

    final path = isIndex
        ? '${ApiConfig.moexBase}/engines/stock/markets/index/securities/$ticker/candles.json'
        : isEtf
            ? '${ApiConfig.moexBase}/engines/stock/markets/shares/securities/$ticker/candles.json'
            : '${ApiConfig.moexBase}/engines/stock/markets/shares/securities/$ticker/candles.json';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {
          'from': fmt(from),
          'till': fmt(till),
          'interval': 24,
        },
      );

      final candles = response.data?['candles'] as Map<String, dynamic>?;
      final columns = (candles?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
      final rows = candles?['data'] as List<dynamic>? ?? [];
      final closeIdx = columns.indexOf('close');

      return rows
          .map((row) => ((row as List<dynamic>)[closeIdx] as num).toDouble())
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_fetchFinnhubStock] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<MarketAsset> _fetchFinnhubStock(String ticker) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.finnhubBase}/quote',
      queryParameters: {
        'symbol': ticker,
        'token': ApiConfig.finnhubKey,
      },
    );

    final data = response.data ?? {};
    final price = (data['c'] as num?)?.toDouble() ?? 0;
    final changePercent = (data['dp'] as num?)?.toDouble() ?? 0;

    final sparkline = await _fetchFinnhubCandles(ticker);

    return MarketAsset(
      id: ticker,
      symbol: ticker,
      name: ticker,
      price: price,
      changePercent: changePercent,
      type: AssetType.stockUs,
      sparkline: sparkline,
      currency: 'USD',
    );
  }

/// Приватный метод [_fetchFinnhubCandles] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<List<double>> _fetchFinnhubCandles(String ticker) async {
    final till = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final from = till - 7 * 24 * 3600;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.finnhubBase}/stock/candle',
        queryParameters: {
          'symbol': ticker,
          'resolution': 'D',
          'from': from,
          'to': till,
          'token': ApiConfig.finnhubKey,
        },
      );

      final closes = response.data?['c'] as List<dynamic>? ?? [];
      return closes.map((e) => (e as num).toDouble()).toList();
    } catch (_) {
      return [];
    }
  }

/// Метод [fetchAssetDetail] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<AssetDetail> fetchAssetDetail(MarketAsset asset, {int days = 30}) async {
    if (asset.type == AssetType.crypto) {
      return _fetchCryptoDetail(asset, days: days);
    }
    if (asset.type == AssetType.bondRu) {
      return _fetchMoexBondDetail(asset, days: days);
    }
    if (asset.type == AssetType.stockRu) {
      return _fetchMoexDetail(asset, days: days);
    }
    return _fetchFinnhubDetail(asset, days: days);
  }

  /// Подгрузка более старых свечей при pan влево на графике.
  Future<List<CandlePoint>> fetchOlderCandles(
    MarketAsset asset, {
    required DateTime before,
    int days = 30,
  }) async {
    if (asset.type == AssetType.crypto) return [];
    if (asset.type == AssetType.bondRu) {
      return _fetchMoexBondCandlesRange(asset, before: before, days: days);
    }
    if (asset.type == AssetType.stockRu) {
      return _fetchMoexStockCandlesRange(asset, before: before, days: days);
    }
    if (ApiConfig.finnhubKey.isEmpty) return [];
    return _fetchFinnhubCandlesRange(asset, before: before, days: days);
  }

  Future<List<CandlePoint>> _fetchMoexStockCandlesRange(
    MarketAsset asset, {
    required DateTime before,
    required int days,
  }) async {
    final till = before.subtract(const Duration(days: 1));
    final from = till.subtract(Duration(days: days));
    final isIndex = asset.symbol == 'IMOEX' || asset.symbol == 'RTSI';
    final path = isIndex
        ? '${ApiConfig.moexBase}/engines/stock/markets/index/securities/${asset.symbol}/candles.json'
        : '${ApiConfig.moexBase}/engines/stock/markets/shares/securities/${asset.symbol}/candles.json';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {
          'from': _dateFmt(from),
          'till': _dateFmt(till),
          'interval': 24,
        },
      );
      return MoexParser.candleOhlc(response.data?['candles'] as Map<String, dynamic>?);
    } catch (_) {
      return [];
    }
  }

  Future<List<CandlePoint>> _fetchMoexBondCandlesRange(
    MarketAsset asset, {
    required DateTime before,
    required int days,
  }) async {
    final till = before.subtract(const Duration(days: 1));
    final from = till.subtract(Duration(days: days));
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/stock/markets/bonds/securities/${asset.symbol}/candles.json',
        queryParameters: {
          'from': _dateFmt(from),
          'till': _dateFmt(till),
          'interval': 24,
        },
      );
      return MoexParser.candleOhlc(response.data?['candles'] as Map<String, dynamic>?);
    } catch (_) {
      return [];
    }
  }

  Future<List<CandlePoint>> _fetchFinnhubCandlesRange(
    MarketAsset asset, {
    required DateTime before,
    required int days,
  }) async {
    final till = before.subtract(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;
    final from = till - days * 24 * 3600;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.finnhubBase}/stock/candle',
        queryParameters: {
          'symbol': asset.symbol,
          'resolution': 'D',
          'from': from,
          'to': till,
          'token': ApiConfig.finnhubKey,
        },
      );

      final timestamps = response.data?['t'] as List<dynamic>? ?? [];
      final opens = response.data?['o'] as List<dynamic>? ?? [];
      final highs = response.data?['h'] as List<dynamic>? ?? [];
      final lows = response.data?['l'] as List<dynamic>? ?? [];
      final closes = response.data?['c'] as List<dynamic>? ?? [];

      final candles = <CandlePoint>[];
      for (var i = 0; i < timestamps.length; i++) {
        candles.add(CandlePoint(
          date: DateTime.fromMillisecondsSinceEpoch(
            (timestamps[i] as num).toInt() * 1000,
          ),
          open: (opens[i] as num).toDouble(),
          high: (highs[i] as num).toDouble(),
          low: (lows[i] as num).toDouble(),
          close: (closes[i] as num).toDouble(),
        ));
      }
      return candles;
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_fetchCryptoDetail] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<AssetDetail> _fetchCryptoDetail(MarketAsset asset, {required int days}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.coinGeckoBase}/coins/${asset.id}/market_chart',
      queryParameters: {'vs_currency': 'usd', 'days': days.clamp(1, 365)},
      options: Options(headers: coinGeckoHeaders()),
    );

    final prices = response.data?['prices'] as List<dynamic>? ?? [];
    final history = prices.map((p) {
      final pair = p as List<dynamic>;
      return PricePoint(
        date: DateTime.fromMillisecondsSinceEpoch((pair[0] as num).toInt()),
        value: (pair[1] as num).toDouble(),
      );
    }).toList();

    return AssetDetail(asset: asset, history: history);
  }

/// Приватный метод [_fetchMoexDetail] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<AssetDetail> _fetchMoexDetail(MarketAsset asset, {required int days}) async {
    final isIndex = asset.symbol == 'IMOEX' || asset.symbol == 'RTSI';
    final isEtf = MoexCatalog.byTicker(asset.symbol)?.sector == 'etf';
    final till = DateTime.now();
    final from = till.subtract(Duration(days: days));
    final path = isIndex
        ? '${ApiConfig.moexBase}/engines/stock/markets/index/securities/${asset.symbol}/candles.json'
        : '${ApiConfig.moexBase}/engines/stock/markets/shares/securities/${asset.symbol}/candles.json';

    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {
        'from': _dateFmt(from),
        'till': _dateFmt(till),
        'interval': 24,
      },
    );

    final candlesBlock = response.data?['candles'] as Map<String, dynamic>?;
    final history = MoexParser.candleRows(candlesBlock)
        .map((r) => PricePoint(date: r.date, value: r.value))
        .toList();
    final candles = MoexParser.candleOhlc(candlesBlock);

    return AssetDetail(asset: asset, history: history, candles: candles);
  }

/// Приватный метод [_fetchMoexBondDetail] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<AssetDetail> _fetchMoexBondDetail(MarketAsset asset, {required int days}) async {
    final till = DateTime.now();
    final from = till.subtract(Duration(days: days));
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.moexBase}/engines/stock/markets/bonds/securities/${asset.symbol}/candles.json',
      queryParameters: {
        'from': _dateFmt(from),
        'till': _dateFmt(till),
        'interval': 24,
      },
    );

    final candlesBlock = response.data?['candles'] as Map<String, dynamic>?;
    final history = MoexParser.candleRows(candlesBlock)
        .map((r) => PricePoint(date: r.date, value: r.value))
        .toList();
    final candles = MoexParser.candleOhlc(candlesBlock);

    return AssetDetail(asset: asset, history: history, candles: candles);
  }

/// Приватный метод [_fetchFinnhubDetail] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<AssetDetail> _fetchFinnhubDetail(MarketAsset asset, {required int days}) async {
    final till = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final from = till - days * 24 * 3600;

    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.finnhubBase}/stock/candle',
      queryParameters: {
        'symbol': asset.symbol,
        'resolution': 'D',
        'from': from,
        'to': till,
        'token': ApiConfig.finnhubKey,
      },
    );

    final timestamps = response.data?['t'] as List<dynamic>? ?? [];
    final opens = response.data?['o'] as List<dynamic>? ?? [];
    final highs = response.data?['h'] as List<dynamic>? ?? [];
    final lows = response.data?['l'] as List<dynamic>? ?? [];
    final closes = response.data?['c'] as List<dynamic>? ?? [];

    final history = <PricePoint>[];
    final candles = <CandlePoint>[];
    for (var i = 0; i < timestamps.length; i++) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        (timestamps[i] as num).toInt() * 1000,
      );
      final close = (closes[i] as num).toDouble();
      history.add(PricePoint(date: date, value: close));
      candles.add(CandlePoint(
        date: date,
        open: (opens[i] as num).toDouble(),
        high: (highs[i] as num).toDouble(),
        low: (lows[i] as num).toDouble(),
        close: close,
      ));
    }

    return AssetDetail(asset: asset, history: history, candles: candles);
  }

/// Приватный метод [_dateFmt] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  String _dateFmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Приватный метод [_cryptoToJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static Map<String, dynamic> _cryptoToJson(MarketAsset a) => _assetToJson(a);
/// Приватный метод [_stockToJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static Map<String, dynamic> _stockToJson(MarketAsset a) => _assetToJson(a);

/// Приватный метод [_assetToJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static Map<String, dynamic> _assetToJson(MarketAsset a) => {
        'id': a.id,
        'symbol': a.symbol,
        'name': a.name,
        'price': a.price,
        'changePercent': a.changePercent,
        'type': a.type.name,
        'sparkline': a.sparkline,
        'currency': a.currency,
        'imageUrl': a.imageUrl,
        if (a.yieldPercent != null) 'yieldPercent': a.yieldPercent,
        if (a.couponPercent != null) 'couponPercent': a.couponPercent,
        if (a.maturityDate != null)
          'maturityDate': a.maturityDate!.toIso8601String(),
        if (a.bondCategory != null) 'bondCategory': a.bondCategory!.name,
        if (a.faceValue != null) 'faceValue': a.faceValue,
        if (a.nextCouponDate != null)
          'nextCouponDate': a.nextCouponDate!.toIso8601String(),
        if (a.couponValueRub != null) 'couponValueRub': a.couponValueRub,
        if (a.couponPeriodDays != null) 'couponPeriodDays': a.couponPeriodDays,
      };

/// Приватный метод [_cryptoFromJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static MarketAsset _cryptoFromJson(Map<String, dynamic> json) =>
      _assetFromJson(json);
/// Приватный метод [_stockFromJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static MarketAsset _stockFromJson(Map<String, dynamic> json) =>
      _assetFromJson(json);
/// Приватный метод [_bondFromJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static MarketAsset _bondFromJson(Map<String, dynamic> json) =>
      _assetFromJson(json);
/// Приватный метод [_bondToJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static Map<String, dynamic> _bondToJson(MarketAsset a) => _assetToJson(a);

/// Приватный метод [_assetFromJson] класса [MarketRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static MarketAsset _assetFromJson(Map<String, dynamic> json) {
    final maturityRaw = json['maturityDate'] as String?;
    final bondCatRaw = json['bondCategory'] as String?;
    final nextCouponRaw = json['nextCouponDate'] as String?;
    return MarketAsset(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      type: AssetType.values.byName(json['type'] as String),
      sparkline: (json['sparkline'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      currency: json['currency'] as String? ?? 'USD',
      imageUrl: json['imageUrl'] as String?,
      yieldPercent: (json['yieldPercent'] as num?)?.toDouble(),
      couponPercent: (json['couponPercent'] as num?)?.toDouble(),
      maturityDate:
          maturityRaw == null ? null : DateTime.tryParse(maturityRaw),
      bondCategory: bondCatRaw == null
          ? null
          : BondCategory.values.byName(bondCatRaw),
      faceValue: (json['faceValue'] as num?)?.toDouble(),
      nextCouponDate:
          nextCouponRaw == null ? null : DateTime.tryParse(nextCouponRaw),
      couponValueRub: (json['couponValueRub'] as num?)?.toDouble(),
      couponPeriodDays: (json['couponPeriodDays'] as num?)?.toInt(),
    );
  }
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
