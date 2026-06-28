// =============================================================================
// EcoPulse · lib/data/repositories/currency_repository.dart
// Автор: Цымбал Е. В.
// Дата: 13.05.2026
// Репозитории: загрузка и кэширование из API. Файл: currency_repository.
// =============================================================================

import 'package:dio/dio.dart';

import '../../core/constants/api_config.dart';
import '../../core/constants/market_catalog.dart';
import '../models/currency_rate.dart';
import '../models/price_point.dart';
import '../services/cache_service.dart';
import '../utils/moex_parser.dart';

/// Репозиторий [CurrencyRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
class CurrencyRepository {
/// Создаёт [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  CurrencyRepository(this._dio, this._cache);

/// Поле [_dio] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final Dio _dio;
/// Поле [_cache] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final CacheService _cache;

/// Поле [_cacheKey] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static const _cacheKey = 'currency_rates';

/// Метод [fetchRates] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<List<CurrencyRate>> fetchRates({bool force = false}) async {
    if (!force &&
        _cache.isFresh(_cacheKey, const Duration(minutes: ApiConfig.cacheCurrencyMinutes))) {
      final cached = _cache.getList(_cacheKey, _rateFromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final fxRates = await _fetchFrankfurterBatch();
    final moexRubRates = await _fetchMoexRubPairs();
    final rates = [
      await _fetchUsdRub(),
      ...moexRubRates,
      ...fxRates,
    ];

    await _cache.set(_cacheKey, rates.map(_rateToJson).toList());
    await _cache.markFresh(_cacheKey);
    return rates;
  }

/// Приватный метод [_fetchUsdRub] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<CurrencyRate> _fetchUsdRub() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.moexBase}/engines/currency/markets/selt/boards/CETS/securities/USD000UTSTOM.json',
      queryParameters: {'iss.only': 'marketdata', 'iss.meta': 'off'},
    );

    final marketData = response.data?['marketdata'] as Map<String, dynamic>?;
    final rate = MoexParser.doubleAt(marketData, 'LAST', defaultValue: 0) ?? 0.0;
    final change = MoexParser.nullableDoubleAt(marketData, 'LASTCHANGEPRCNT');

    final history = await _fetchMoexCurrencyHistory('USD000UTSTOM');

    return CurrencyRate(
      code: 'RUB',
      rate: rate,
      base: 'USD',
      changePercent: change,
      history: history,
      isRub: true,
      date: DateTime.now(),
    );
  }

/// Приватный метод [_fetchMoexRubPair] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<CurrencyRate> _fetchMoexRubPair(MoexRubPairEntry entry) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.moexBase}/engines/currency/markets/selt/boards/CETS/securities/${entry.security}.json',
      queryParameters: {'iss.only': 'marketdata', 'iss.meta': 'off'},
    );

    final marketData = response.data?['marketdata'] as Map<String, dynamic>?;
    final rate = MoexParser.doubleAt(marketData, 'LAST', defaultValue: 0) ?? 0.0;
    final change = MoexParser.nullableDoubleAt(marketData, 'LASTCHANGEPRCNT');
    final history = entry.withHistory
        ? await _fetchMoexCurrencyHistory(entry.security)
        : const <PricePoint>[];

    return CurrencyRate(
      code: entry.code,
      rate: rate,
      base: 'RUB',
      changePercent: change == 0 && rate == 0 ? null : change,
      history: history,
      date: DateTime.now(),
    );
  }

/// Приватный метод [_fetchMoexRubPairs] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<List<CurrencyRate>> _fetchMoexRubPairs() async {
    final pairs = CurrencyCatalog.moexRubPairs;
    final results = await Future.wait(
      pairs.map((entry) async {
        try {
          return await _fetchMoexRubPair(entry);
        } catch (_) {
          return null;
        }
      }),
    );
    return results.whereType<CurrencyRate>().toList();
  }

/// Приватный метод [_fetchMoexCurrencyHistory] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  Future<List<PricePoint>> _fetchMoexCurrencyHistory(String security) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 30));
    final fmt = _dateFmt;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.moexBase}/engines/currency/markets/selt/securities/$security/candles.json',
        queryParameters: {
          'from': fmt(from),
          'till': fmt(till),
          'interval': 24,
        },
      );

      final candles = response.data?['candles'] as Map<String, dynamic>?;
      return MoexParser.candleRows(candles)
          .map((r) => PricePoint(date: r.date, value: r.value))
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_fetchFrankfurterBatch] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<List<CurrencyRate>> _fetchFrankfurterBatch() async {    final codes = CurrencyCatalog.fxCodes;
    if (codes.isEmpty) return [];

    try {
      final latest = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.frankfurterBase}/latest',
        queryParameters: {'from': 'USD', 'to': codes.join(',')},
      );
      final ratesMap =
          latest.data?['rates'] as Map<String, dynamic>? ?? {};
      final date = DateTime.tryParse(latest.data?['date'] as String? ?? '');

      final historyCodes = CurrencyCatalog.historyCodes;
      final histories = await Future.wait(
        historyCodes.map(_fetchFrankfurterHistory),
      );
      final historyByCode = {
        for (var i = 0; i < historyCodes.length; i++)
          historyCodes[i]: histories[i],
      };

      return codes.map((code) {
        final rate = (ratesMap[code] as num?)?.toDouble() ?? 0;
        final history = historyByCode[code] ?? const <PricePoint>[];
        double? changePercent;
        if (history.length >= 2) {
          final first = history.first.value;
          final last = history.last.value;
          if (first != 0) changePercent = ((last - first) / first) * 100;
        }
        return CurrencyRate(
          code: code,
          rate: rate,
          base: 'USD',
          changePercent: changePercent,
          history: history,
          date: date,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

/// Приватный метод [_fetchFrankfurterHistory] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<List<PricePoint>> _fetchFrankfurterHistory(String code) async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 30));
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.frankfurterBase}/${_dateFmt(from)}..${_dateFmt(till)}',
        queryParameters: {'from': 'USD', 'to': code},
      );
      final historyMap =
          response.data?['rates'] as Map<String, dynamic>? ?? {};
      return historyMap.entries.map((e) {
        final dayRates = e.value as Map<String, dynamic>;
        return PricePoint(
          date: DateTime.parse(e.key),
          value: (dayRates[code] as num).toDouble(),
        );
      }).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (_) {
      return [];
    }
  }

/// Метод [convert] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<double> convert({
    required double amount,
    required String from,
    required String to,
    required List<CurrencyRate> rates,
  }) async {
    if (from == to) return amount;

    double toUsd(String code, double value) {
      if (code == 'USD') return value;
      if (code == 'RUB') {
        final rub = rates.firstWhere((r) => r.isRub);
        return value / rub.rate;
      }
      final rate = rates.firstWhere((r) => r.code == code);
      return value / rate.rate;
    }

    double fromUsd(String code, double usd) {
      if (code == 'USD') return usd;
      if (code == 'RUB') {
        final rub = rates.firstWhere((r) => r.isRub);
        return usd * rub.rate;
      }
      final rate = rates.firstWhere((r) => r.code == code);
      return usd * rate.rate;
    }

    return fromUsd(to, toUsd(from, amount));
  }

/// Приватный метод [_dateFmt] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  String _dateFmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Приватный метод [_rateToJson] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static Map<String, dynamic> _rateToJson(CurrencyRate r) => {
        'code': r.code,
        'rate': r.rate,
        'base': r.base,
        'changePercent': r.changePercent,
        'isRub': r.isRub,
        'date': r.date?.toIso8601String(),
        'history': r.history
            .map((p) => {'date': p.date.toIso8601String(), 'value': p.value})
            .toList(),
      };

/// Приватный метод [_rateFromJson] класса [CurrencyRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static CurrencyRate _rateFromJson(Map<String, dynamic> json) => CurrencyRate(
        code: json['code'] as String,
        rate: (json['rate'] as num).toDouble(),
        base: json['base'] as String,
        changePercent: (json['changePercent'] as num?)?.toDouble(),
        isRub: json['isRub'] as bool? ?? false,
        date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
        history: (json['history'] as List<dynamic>? ?? [])
            .map((e) => PricePoint(
                  date: DateTime.parse(e['date'] as String),
                  value: (e['value'] as num).toDouble(),
                ))
            .toList(),
      );
}
