// =============================================================================
// EcoPulse · lib/data/repositories/news_repository.dart
// Автор: Цымбал Е. В.
// Дата: 14.05.2026
// Репозитории: загрузка и кэширование из API. Файл: news_repository.
// =============================================================================

import 'package:dio/dio.dart';

import '../../core/constants/api_config.dart';
import '../models/macro_event.dart';
import '../models/news_item.dart';
import '../services/cache_service.dart';

/// Репозиторий [NewsRepository] — API и Hive-кэш.
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
class NewsRepository {
/// Создаёт [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  NewsRepository(this._dio, this._cache);

/// Поле [_dio] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final Dio _dio;
/// Поле [_cache] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final CacheService _cache;

/// Поле [_newsCacheKey] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static const _newsCacheKey = 'market_news';
/// Поле [_macroCacheKey] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static const _macroCacheKey = 'macro_calendar';

/// Метод [fetchNews] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  Future<List<NewsItem>> fetchNews({bool force = false}) async {
    if (ApiConfig.finnhubKey.isEmpty) return [];

    if (!force &&
        _cache.isFresh(_newsCacheKey, const Duration(minutes: 30))) {
      final cached = _cache.getList(_newsCacheKey, NewsItem.fromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final response = await _dio.get<List<dynamic>>(
      '${ApiConfig.finnhubBase}/news',
      queryParameters: {
        'category': 'general',
        'token': ApiConfig.finnhubKey,
      },
    );

    final items = (response.data ?? [])
        .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
        .where((n) => n.headline.isNotEmpty)
        .take(20)
        .toList();

    if (items.isNotEmpty) {
      await _cache.set(_newsCacheKey, items.map((n) => n.toJson()).toList());
      await _cache.markFresh(_newsCacheKey);
    }
    return items;
  }

/// Метод [fetchMacroCalendar] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  Future<List<MacroEvent>> fetchMacroCalendar({bool force = false}) async {
    if (ApiConfig.finnhubKey.isEmpty) return [];

    if (!force &&
        _cache.isFresh(_macroCacheKey, const Duration(hours: 6))) {
      final cached = _cache.getList(_macroCacheKey, MacroEvent.fromJson);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final now = DateTime.now();
    final to = now.add(const Duration(days: 7));
    final fromStr = _dateOnly(now);
    final toStr = _dateOnly(to);

    final response = await _dio.get<List<dynamic>>(
      '${ApiConfig.finnhubBase}/calendar/economic',
      queryParameters: {
        'from': fromStr,
        'to': toStr,
        'token': ApiConfig.finnhubKey,
      },
    );

    final events = (response.data ?? [])
        .map((e) => MacroEvent.fromJson(e as Map<String, dynamic>))
        .where((e) => e.event.isNotEmpty)
        .toList()
      ..sort((a, b) {
        final ad = a.date;
        final bd = b.date;
        final cmp = ad.compareTo(bd);
        if (cmp != 0) return cmp;
        return (a.time ?? '').compareTo(b.time ?? '');
      });

    if (events.isNotEmpty) {
      await _cache.set(
        _macroCacheKey,
        events.map((e) => e.toJson()).toList(),
      );
      await _cache.markFresh(_macroCacheKey);
    }
    return events;
  }

/// Приватный метод [_dateOnly] класса [NewsRepository].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  String _dateOnly(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
