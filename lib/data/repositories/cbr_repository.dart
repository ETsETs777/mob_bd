// =============================================================================
// EcoPulse · lib/data/repositories/cbr_repository.dart
// Автор: Цымбал Е. В.
// Дата: 13.05.2026
// Репозитории: загрузка и кэширование из API. Файл: cbr_repository.
// =============================================================================

import 'package:dio/dio.dart';

import '../../core/errors/api_exception.dart';
import '../models/key_rate_point.dart';
import '../services/cache_service.dart';

/// Репозиторий [CbrRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
class CbrRepository {
/// Создаёт [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  CbrRepository(this._dio, this._cache);

/// Поле [_dio] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  final Dio _dio;
/// Поле [_cache] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final CacheService _cache;

/// Поле [_cacheKey] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static const _cacheKey = 'cbr_key_rate';

/// Метод [fetchKeyRate] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  Future<KeyRateSnapshot> fetchKeyRate({bool force = false}) async {
    if (!force &&
        _cache.isFresh(_cacheKey, const Duration(hours: 6))) {
      final cached = _cache.get(_cacheKey, _fromJson);
      if (cached != null) return cached;
    }

    final snapshot = await guardApi(_fetchFromCbr);
    await _cache.set(_cacheKey, _toJson(snapshot));
    await _cache.markFresh(_cacheKey);
    return snapshot;
  }

/// Приватный метод [_fetchFromCbr] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<KeyRateSnapshot> _fetchFromCbr() async {
    final till = DateTime.now();
    final from = till.subtract(const Duration(days: 365));

    final response = await _dio.get<String>(
      'https://www.cbr.ru/scripts/XML_keyRate.asp',
      queryParameters: {
        'date_req1': _cbrDate(from),
        'date_req2': _cbrDate(till),
      },
      options: Options(responseType: ResponseType.plain),
    );

    final xml = response.data ?? '';
    final recordPattern = RegExp(
      r'<Record\s+Date="(\d{2}\.\d{2}\.\d{4})"\s+Rate="([\d.]+)"\s*/>',
    );

    final history = <KeyRatePoint>[];
    for (final match in recordPattern.allMatches(xml)) {
      final dateParts = match.group(1)!.split('.');
      final date = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );
      history.add(KeyRatePoint(
        date: date,
        rate: double.parse(match.group(2)!),
      ));
    }

    history.sort((a, b) => a.date.compareTo(b.date));

    if (history.isEmpty) {
      throw const ApiException(
        message: 'Не удалось получить ключевую ставку ЦБ',
        type: ApiErrorType.parse,
      );
    }

    return KeyRateSnapshot(
      current: history.last.rate,
      history: history,
      updatedAt: DateTime.now(),
    );
  }

/// Приватный метод [_cbrDate] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  String _cbrDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

/// Приватный метод [_toJson] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  static Map<String, dynamic> _toJson(KeyRateSnapshot s) => {
        'current': s.current,
        'updatedAt': s.updatedAt.toIso8601String(),
        'history': s.history
            .map((p) => {
                  'date': p.date.toIso8601String(),
                  'rate': p.rate,
                })
            .toList(),
      };

/// Приватный метод [_fromJson] класса [CbrRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static KeyRateSnapshot _fromJson(Map<String, dynamic> json) =>
      KeyRateSnapshot(
        current: (json['current'] as num).toDouble(),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        history: (json['history'] as List<dynamic>)
            .map((e) => KeyRatePoint(
                  date: DateTime.parse(e['date'] as String),
                  rate: (e['rate'] as num).toDouble(),
                ))
            .toList(),
      );
}
