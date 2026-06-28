// =============================================================================
// EcoPulse · lib/data/repositories/commodities_repository.dart
// Автор: Цымбал Е. В.
// Дата: 13.05.2026
// Репозитории: загрузка и кэширование из API. Файл: commodities_repository.
// =============================================================================

import 'package:dio/dio.dart';

import '../../core/constants/api_config.dart';
import '../models/commodity_quote.dart';
import '../services/cache_service.dart';
import '../utils/moex_parser.dart';

/// Репозиторий [CommoditiesRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
class CommoditiesRepository {
/// Создаёт [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  CommoditiesRepository(this._dio, this._cache);

/// Поле [_dio] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final Dio _dio;
/// Поле [_cache] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final CacheService _cache;

/// Поле [_cacheKey] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static const _cacheKey = 'commodities';
/// Поле [_fngCacheKey] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static const _fngCacheKey = 'fear_greed';

/// Метод [fetchCommodities] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<List<CommodityQuote>> fetchCommodities({bool force = false}) async {
    if (!force &&
        _cache.isFresh(_cacheKey, const Duration(hours: 1))) {
      final cached = _cache.getList(_cacheKey, _fromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final items = <CommodityQuote>[];
    final brent = await _fetchBrentFutures();
    if (brent != null) items.add(brent);
    final wti = await _fetchWtiFutures();
    if (wti != null) items.add(wti);
    final gold = await _fetchGoldRub();
    if (gold != null) items.add(gold);

    if (items.isNotEmpty) {
      await _cache.set(_cacheKey, items.map(_toJson).toList());
      await _cache.markFresh(_cacheKey);
    }
    return items;
  }

/// Метод [fetchFearGreed] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<FearGreedIndex?> fetchFearGreed({bool force = false}) async {
    if (!force &&
        _cache.isFresh(_fngCacheKey, const Duration(hours: 6))) {
      final cached = _cache.get(_fngCacheKey, _fngFromJson);
      if (cached != null) return cached;
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.alternative.me/fng/',
        queryParameters: {'limit': 1},
      );
      final data = (response.data?['data'] as List<dynamic>?)?.firstOrNull
          as Map<String, dynamic>?;
      if (data == null) return null;

      final result = FearGreedIndex(
        value: int.tryParse(data['value'] as String? ?? '') ?? 0,
        label: _fngLabel(data['value_classification'] as String? ?? ''),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          (int.tryParse(data['timestamp'] as String? ?? '0') ?? 0) * 1000,
        ),
      );

      await _cache.set(_fngCacheKey, _fngToJson(result));
      await _cache.markFresh(_fngCacheKey);
      return result;
    } catch (_) {
      return _cache.get(_fngCacheKey, _fngFromJson);
    }
  }

/// Приватный метод [_fetchBrentFutures] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<CommodityQuote?> _fetchBrentFutures() async {
    try {
      final listResp = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/futures/markets/forts/securities.json',
        queryParameters: {
          'iss.only': 'securities',
          'iss.meta': 'off',
          'securities.columns': 'SECID,SHORTNAME',
          'limit': 50,
        },
      );

      final sec = listResp.data?['securities'] as Map<String, dynamic>?;
      final cols = MoexParser.columns(sec);
      final rows = sec?['data'] as List<dynamic>? ?? [];
      final secidIdx = cols.indexOf('SECID');
      final nameIdx = cols.indexOf('SHORTNAME');

      String? contract;
      String? name;
      for (final row in rows) {
        final r = row as List<dynamic>;
        final id = r[secidIdx] as String? ?? '';
        if (id.startsWith('BR') && id.length <= 6 && !id.contains('-')) {
          contract = id;
          name = r[nameIdx] as String? ?? 'Brent';
          break;
        }
      }

      contract ??= 'BRF6';
      name ??= 'Brent (MOEX)';

      final mdResp = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/futures/markets/forts/securities/$contract.json',
        queryParameters: {'iss.only': 'marketdata', 'iss.meta': 'off'},
      );

      final md = mdResp.data?['marketdata'] as Map<String, dynamic>?;
      final price = MoexParser.nullableDoubleAt(md, 'LAST') ??
          MoexParser.nullableDoubleAt(md, 'SETTLEPRICE') ??
          0;
      if (price == 0) return null;

      final change = MoexParser.nullableDoubleAt(md, 'LASTCHANGEPRCNT');
      final sparkline = await _fetchFuturesSparkline(contract);

      return CommodityQuote(
        id: 'brent',
        name: name,
        price: price,
        unit: '₽/барр.',
        changePercent: change,
        sparkline: sparkline,
        source: 'MOEX',
      );
    } catch (_) {
      return null;
    }
  }

/// Приватный метод [_fetchWtiFutures] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  Future<CommodityQuote?> _fetchWtiFutures() async {
    try {
      final listResp = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/futures/markets/forts/securities.json',
        queryParameters: {
          'iss.only': 'securities',
          'iss.meta': 'off',
          'securities.columns': 'SECID,SHORTNAME',
          'limit': 80,
        },
      );

      final sec = listResp.data?['securities'] as Map<String, dynamic>?;
      final cols = MoexParser.columns(sec);
      final rows = sec?['data'] as List<dynamic>? ?? [];
      final secidIdx = cols.indexOf('SECID');
      final nameIdx = cols.indexOf('SHORTNAME');

      String? contract;
      String? name;
      for (final row in rows) {
        final r = row as List<dynamic>;
        final id = r[secidIdx] as String? ?? '';
        if (id.startsWith('CL') && id.length <= 6 && !id.contains('-')) {
          contract = id;
          name = r[nameIdx] as String? ?? 'WTI';
          break;
        }
      }

      contract ??= 'CLF6';
      name ??= 'WTI (MOEX)';

      final mdResp = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/futures/markets/forts/securities/$contract.json',
        queryParameters: {'iss.only': 'marketdata', 'iss.meta': 'off'},
      );

      final md = mdResp.data?['marketdata'] as Map<String, dynamic>?;
      final price = MoexParser.nullableDoubleAt(md, 'LAST') ??
          MoexParser.nullableDoubleAt(md, 'SETTLEPRICE') ??
          0;
      if (price == 0) return null;

      final change = MoexParser.nullableDoubleAt(md, 'LASTCHANGEPRCNT');
      final sparkline = await _fetchFuturesSparkline(contract);

      return CommodityQuote(
        id: 'wti',
        name: name,
        price: price,
        unit: '₽/барр.',
        changePercent: change,
        sparkline: sparkline,
        source: 'MOEX',
      );
    } catch (_) {
      return null;
    }
  }

/// Приватный метод [_fetchGoldRub] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<CommodityQuote?> _fetchGoldRub() async {
    try {
      const security = 'GLDRUB_TOM';
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/currency/markets/selt/boards/CETS/securities/$security.json',
        queryParameters: {'iss.only': 'marketdata', 'iss.meta': 'off'},
      );

      final md = response.data?['marketdata'] as Map<String, dynamic>?;
      final price = MoexParser.nullableDoubleAt(md, 'LAST') ?? 0;
      if (price == 0) return null;

      final change = MoexParser.nullableDoubleAt(md, 'LASTCHANGEPRCNT');
      final sparkline = await _fetchGoldSparkline(security);

      return CommodityQuote(
        id: 'gold',
        name: 'Золото',
        price: price,
        unit: '₽/г',
        changePercent: change,
        sparkline: sparkline,
        source: 'MOEX',
      );
    } catch (_) {
      return null;
    }
  }

/// Приватный метод [_fetchFuturesSparkline] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<List<double>> _fetchFuturesSparkline(String secid) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 14));
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/futures/markets/forts/securities/$secid/candles.json',
        queryParameters: {
          'from': _dateFmt(from),
          'till': _dateFmt(till),
          'interval': 24,
        },
      );
      return MoexParser.candleCloses(response.data?['candles'] as Map<String, dynamic>?);
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_fetchGoldSparkline] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<List<double>> _fetchGoldSparkline(String security) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 14));
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/currency/markets/selt/securities/$security/candles.json',
        queryParameters: {
          'from': _dateFmt(from),
          'till': _dateFmt(till),
          'interval': 24,
        },
      );
      return MoexParser.candleCloses(response.data?['candles'] as Map<String, dynamic>?);
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_dateFmt] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  String _dateFmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Приватный метод [_fngLabel] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  String _fngLabel(String en) => switch (en.toLowerCase()) {
        'extreme fear' => 'Крайний страх',
        'fear' => 'Страх',
        'neutral' => 'Нейтрально',
        'greed' => 'Жадность',
        'extreme greed' => 'Крайняя жадность',
        _ => en,
      };

/// Приватный метод [_toJson] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static Map<String, dynamic> _toJson(CommodityQuote q) => {
        'id': q.id,
        'name': q.name,
        'price': q.price,
        'unit': q.unit,
        'changePercent': q.changePercent,
        'sparkline': q.sparkline,
        'source': q.source,
      };

/// Приватный метод [_fromJson] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static CommodityQuote _fromJson(Map<String, dynamic> json) => CommodityQuote(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        unit: json['unit'] as String,
        changePercent: (json['changePercent'] as num?)?.toDouble(),
        sparkline: (json['sparkline'] as List<dynamic>? ?? [])
            .map((e) => (e as num).toDouble())
            .toList(),
        source: json['source'] as String? ?? 'MOEX',
      );

/// Приватный метод [_fngToJson] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static Map<String, dynamic> _fngToJson(FearGreedIndex f) => {
        'value': f.value,
        'label': f.label,
        'updatedAt': f.updatedAt.toIso8601String(),
      };

/// Приватный метод [_fngFromJson] класса [CommoditiesRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static FearGreedIndex _fngFromJson(Map<String, dynamic> json) =>
      FearGreedIndex(
        value: json['value'] as int,
        label: json['label'] as String,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
