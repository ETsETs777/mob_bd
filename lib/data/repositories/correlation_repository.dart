// =============================================================================
// EcoPulse · lib/data/repositories/correlation_repository.dart
// Автор: Цымбал Е. В.
// Дата: 13.05.2026
// Репозитории: загрузка и кэширование из API. Файл: correlation_repository.
// =============================================================================

import 'package:dio/dio.dart';

import '../../core/constants/api_config.dart';
import '../../core/utils/correlation_utils.dart';
import '../models/price_point.dart';
import '../services/api_client.dart';
import '../services/cache_service.dart';
import '../utils/moex_parser.dart';

/// Репозиторий [CorrelationRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
class CorrelationRepository {
/// Создаёт [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  CorrelationRepository(this._dio, this._cache);

/// Поле [_dio] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final Dio _dio;
/// Поле [_cache] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final CacheService _cache;

/// Поле [_cacheKey] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static const _cacheKey = 'correlation_30d';

/// Метод [fetchCorrelation] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<CorrelationSnapshot?> fetchCorrelation({
    bool force = false,
    int days = 30,
  }) async {
    if (!force &&
        _cache.isFresh(_cacheKey, const Duration(hours: 2))) {
      final cached = _cache.get(_cacheKey, _fromJson);
      if (cached != null) return cached;
    }

    final results = await Future.wait([
      _fetchBtcHistory(days),
      _fetchUsdRubHistory(days),
      _fetchImoexHistory(days),
    ]);

    final snapshot = buildCorrelationSnapshot(
      days: days,
      assets: [
        CorrelationAsset(id: 'btc', label: 'BTC', history: results[0]),
        CorrelationAsset(id: 'usdRub', label: 'USD/RUB', history: results[1]),
        CorrelationAsset(id: 'imoex', label: 'IMOEX', history: results[2]),
      ],
    );

    if (snapshot != null) {
      await _cache.set(_cacheKey, _toJson(snapshot));
      await _cache.markFresh(_cacheKey);
    }
    return snapshot ?? _readCache();
  }

/// Приватный метод [_readCache] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  CorrelationSnapshot? _readCache() {
    try {
      return _cache.get(_cacheKey, (json) => _fromJson(json)!);
    } catch (_) {
      return null;
    }
  }

/// Приватный метод [_fetchBtcHistory] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<List<PricePoint>> _fetchBtcHistory(int days) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.coinGeckoBase}/coins/bitcoin/market_chart',
        queryParameters: {'vs_currency': 'usd', 'days': days.clamp(7, 90)},
        options: Options(headers: coinGeckoHeaders()),
      );
      final prices = response.data?['prices'] as List<dynamic>? ?? [];
      return prices.map((p) {
        final pair = p as List<dynamic>;
        return PricePoint(
          date: DateTime.fromMillisecondsSinceEpoch((pair[0] as num).toInt()),
          value: (pair[1] as num).toDouble(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_fetchUsdRubHistory] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<List<PricePoint>> _fetchUsdRubHistory(int days) async {
    return _fetchMoexCandles(
      'USD000UTSTOM',
      engine: 'currency',
      market: 'selt',
    );
  }

/// Приватный метод [_fetchImoexHistory] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  Future<List<PricePoint>> _fetchImoexHistory(int days) async {
    return _fetchMoexCandles(
      'IMOEX',
      engine: 'stock',
      market: 'index',
      isIndex: true,
    );
  }

/// Приватный метод [_fetchMoexCandles] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<List<PricePoint>> _fetchMoexCandles(
    String security, {
    required String engine,
    required String market,
    bool isIndex = false,
  }) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 30));
    final path = isIndex
        ? '${ApiConfig.moexBase}/engines/$engine/markets/$market/securities/$security/candles.json'
        : '${ApiConfig.moexBase}/engines/$engine/markets/$market/securities/$security/candles.json';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {
          'from': _dateFmt(from),
          'till': _dateFmt(till),
          'interval': 24,
        },
      );
      return MoexParser.candleRows(response.data?['candles'] as Map<String, dynamic>?)
          .map((r) => PricePoint(date: r.date, value: r.value))
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_dateFmt] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  String _dateFmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Приватный метод [_toJson] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static Map<String, dynamic> _toJson(CorrelationSnapshot s) => {
        'days': s.days,
        'assets': s.assets
            .map(
              (a) => {
                'id': a.id,
                'label': a.label,
                'history': a.history
                    .map((p) => {'date': p.date.toIso8601String(), 'value': p.value})
                    .toList(),
              },
            )
            .toList(),
        'matrix': s.matrix,
      };

/// Приватный метод [_fromJson] класса [CorrelationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static CorrelationSnapshot? _fromJson(Map<String, dynamic> json) {
    final assetsRaw = json['assets'] as List<dynamic>? ?? [];
    if (assetsRaw.isEmpty) return null;
    final assets = assetsRaw.map((raw) {
      final map = raw as Map<String, dynamic>;
      return CorrelationAsset(
        id: map['id'] as String,
        label: map['label'] as String,
        history: (map['history'] as List<dynamic>? ?? [])
            .map(
              (e) => PricePoint(
                date: DateTime.parse(e['date'] as String),
                value: (e['value'] as num).toDouble(),
              ),
            )
            .toList(),
      );
    }).toList();

    final matrixRaw = json['matrix'] as Map<String, dynamic>? ?? {};
    final matrix = matrixRaw.map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
    );

    return CorrelationSnapshot(
      assets: assets,
      matrix: matrix,
      days: json['days'] as int? ?? 30,
    );
  }
}
