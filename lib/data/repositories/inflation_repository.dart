// =============================================================================
// EcoPulse · lib/data/repositories/inflation_repository.dart
// Автор: Цымбал Е. В.
// Дата: 14.05.2026
// Репозитории: загрузка и кэширование из API. Файл: inflation_repository.
// =============================================================================

import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/api_config.dart';
import '../models/inflation_point.dart';
import '../services/cache_service.dart';

/// Репозиторий [InflationRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
class InflationRepository {
/// Создаёт [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  InflationRepository(this._dio, this._cache);

/// Поле [_dio] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final Dio _dio;
/// Поле [_cache] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final CacheService _cache;

/// Поле [_cacheKey] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static const _cacheKey = 'inflation_data_v2';

/// Метод [fetchInflation] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<List<InflationPoint>> fetchInflation({bool force = false}) async {
    if (!force &&
        _cache.isFresh(
          _cacheKey,
          Duration(hours: ApiConfig.cacheInflationHours),
        )) {
      final cached = _cache.getList(_cacheKey, _fromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final countryCodes = AppConstants.inflationCountries.keys.join(';');
    final endYear = AppConstants.currentYear;
    final response = await _dio.get<List<dynamic>>(
      '${ApiConfig.worldBankBase}/country/$countryCodes/indicator/FP.CPI.TOTL.ZG',
      queryParameters: {
        'format': 'json',
        'per_page': 250,
        'date': '${AppConstants.inflationHistoryFromYear}:$endYear',
      },
    );

    final rows = response.data?[1] as List<dynamic>? ?? [];
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final row in rows) {
      final map = row as Map<String, dynamic>;
      final code = map['country']?['id'] as String?;
      if (code == null) continue;
      grouped.putIfAbsent(code, () => []).add(map);
    }

    final result = <InflationPoint>[];
    for (final entry in AppConstants.inflationCountries.entries) {
      final code = entry.key;
      final name = entry.value;
      final countryRows = grouped[code] ?? [];

      final history = _dedupeHistoryByYear(countryRows
          .where((r) => r['value'] != null)
          .map((r) => YearValue(
                year: int.parse(r['date'] as String),
                value: (r['value'] as num).toDouble(),
              ))
          .toList()
        ..sort((a, b) => a.year.compareTo(b.year)));

      if (history.isEmpty) continue;

      final latest = history.last;
      result.add(InflationPoint(
        countryCode: code,
        countryName: name,
        year: latest.year,
        value: latest.value,
        history: history,
      ));
    }

    result.sort((a, b) => b.value.compareTo(a.value));

    await _cache.set(_cacheKey, result.map(_toJson).toList());
    await _cache.markFresh(_cacheKey);
    return result;
  }

/// Метод [fetchCountry] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<InflationPoint?> fetchCountry(String code, {bool force = false}) async {
    final all = await fetchInflation(force: force);
    try {
      return all.firstWhere((p) => p.countryCode == code);
    } catch (_) {
      return null;
    }
  }

/// Приватный метод [_toJson] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static Map<String, dynamic> _toJson(InflationPoint p) => {
        'countryCode': p.countryCode,
        'countryName': p.countryName,
        'year': p.year,
        'value': p.value,
        'history': p.history
            .map((h) => {'year': h.year, 'value': h.value})
            .toList(),
      };

/// Приватный метод [_fromJson] класса [InflationRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  static InflationPoint _fromJson(Map<String, dynamic> json) => InflationPoint(
        countryCode: json['countryCode'] as String,
        countryName: json['countryName'] as String,
        year: json['year'] as int,
        value: (json['value'] as num).toDouble(),
        history: _dedupeHistoryByYear(
          (json['history'] as List<dynamic>? ?? [])
              .map((e) => YearValue(
                    year: e['year'] as int,
                    value: (e['value'] as num).toDouble(),
                  ))
              .toList(),
        ),
      );

  /// World Bank иногда отдаёт дубликаты года — оставляем последнее значение.
  static List<YearValue> _dedupeHistoryByYear(List<YearValue> rows) {
    if (rows.length < 2) return rows;
    final byYear = <int, YearValue>{};
    for (final row in rows) {
      byYear[row.year] = row;
    }
    return byYear.values.toList()..sort((a, b) => a.year.compareTo(b.year));
  }
}
