// =============================================================================
// EcoPulse · lib/providers/admin_provider.dart
// Автор: Цымбал Е. В.
// Дата: 17.05.2026
// Riverpod state: провайдеры и notifiers. Файл: admin_provider.
// =============================================================================

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_config.dart';
import '../core/constants/market_catalog.dart';
import '../data/services/api_client.dart';
import '../data/services/cache_service.dart';
import 'app_providers.dart';

/// Класс [ApiPingResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
class ApiPingResult {
/// Создаёт [ApiPingResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  const ApiPingResult({
    required this.name,
    required this.ok,
    this.latencyMs,
    this.detail,
  });

/// Поле [name] класса [ApiPingResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  final String name;
/// Поле [ok] класса [ApiPingResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  final bool ok;
/// Поле [latencyMs] класса [ApiPingResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final int? latencyMs;
/// Поле [detail] класса [ApiPingResult].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final String? detail;
}

/// Класс [CacheEntryInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
class CacheEntryInfo {
/// Создаёт [CacheEntryInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  const CacheEntryInfo({
    required this.key,
    required this.age,
    required this.fresh,
    this.itemCount,
  });

/// Поле [key] класса [CacheEntryInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  final String key;
/// Поле [age] класса [CacheEntryInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final Duration? age;
/// Поле [fresh] класса [CacheEntryInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final bool fresh;
/// Поле [itemCount] класса [CacheEntryInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final int? itemCount;
}

/// Класс [AdminSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class AdminSnapshot {
/// Создаёт [AdminSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  const AdminSnapshot({
    required this.pings,
    required this.cacheEntries,
    required this.catalog,
  });

/// Поле [pings] класса [AdminSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
  final List<ApiPingResult> pings;
/// Поле [cacheEntries] класса [AdminSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final List<CacheEntryInfo> cacheEntries;
/// Поле [catalog] класса [AdminSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final Map<String, int> catalog;
}

/// Top-level переменная [_cacheKeys].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
const _cacheKeys = [
  ('currency_rates', ApiConfig.cacheCurrencyMinutes),
  ('crypto_markets', ApiConfig.cacheCryptoMinutes),
  ('stock_markets', ApiConfig.cacheStockMinutes),
  ('correlation_30d', 120),
];

/// Riverpod-провайдер [adminSnapshotProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final adminSnapshotProvider = FutureProvider.autoDispose<AdminSnapshot>((ref) async {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(cacheServiceProvider);

  final pings = await Future.wait([
    _ping(dio, 'Frankfurter', '${ApiConfig.frankfurterBase}/latest?base=USD&symbols=EUR'),
    _ping(dio, 'MOEX ISS', '${ApiConfig.moexBase}/engines/stock/markets/shares/boards/TQBR/securities/SBER.json?iss.only=marketdata&iss.meta=off'),
    _ping(dio, 'CoinGecko', '${ApiConfig.coinGeckoBase}/ping', headers: coinGeckoHeaders()),
  ]);

  final cacheEntries = _cacheKeys.map((entry) {
    final key = entry.$1;
    final ttlMinutes = entry.$2;
    final at = cache.cachedAt(key);
    final age = at == null ? null : DateTime.now().difference(at);
    final fresh = cache.isFresh(key, Duration(minutes: ttlMinutes));
    return CacheEntryInfo(
      key: key,
      age: age,
      fresh: fresh,
      itemCount: _estimateCount(cache, key),
    );
  }).toList();

  return AdminSnapshot(
    pings: pings,
    cacheEntries: cacheEntries,
    catalog: {
      'moex': MoexCatalog.tickers.length,
      'us': UsCatalog.tickers.length,
      'fx': CurrencyCatalog.fxCodes.length + CurrencyCatalog.moexRubPairs.length + 1,
      'crypto': CryptoCatalog.targetCount,
    },
  );
});

/// Приватная функция [_ping].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.05.2026
Future<ApiPingResult> _ping(
  Dio dio,
  String name,
  String url, {
  Map<String, String> headers = const {},
}) async {
  final started = DateTime.now();
  try {
    final response = await dio.get<dynamic>(
      url,
      options: Options(headers: headers, receiveTimeout: const Duration(seconds: 10)),
    );
    final ms = DateTime.now().difference(started).inMilliseconds;
    return ApiPingResult(
      name: name,
      ok: response.statusCode != null && response.statusCode! < 400,
      latencyMs: ms,
      detail: '${response.statusCode}',
    );
  } catch (e) {
    return ApiPingResult(
      name: name,
      ok: false,
      detail: e.toString().split('\n').first,
    );
  }
}

/// Приватная функция [_estimateCount].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
int? _estimateCount(CacheService cache, String key) {
  final raw = cache.getString(key);
  if (raw == null) return null;
  try {
    final decoded = raw.startsWith('[') ? raw : null;
    if (decoded != null) {
      return decoded.split('{').length - 1;
    }
  } catch (_) {}
  return raw.length > 2 ? 1 : null;
}
