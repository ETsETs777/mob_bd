// =============================================================================
// EcoPulse · lib/core/utils/cache_status.dart
// Автор: Цымбал Е. В.
// Дата: 06.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: cache_status.
// =============================================================================

import '../../data/services/cache_service.dart';
import '../../features/shared/app_actions.dart';
import '../constants/api_config.dart';

/// Значение enum [offline].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
/// Значение enum [cache].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
/// Значение enum [fresh].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
/// Enum [DataStatusKind] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
/// Значение enum [offline].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
/// Значение enum [cache].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
/// Значение enum [fresh].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
enum DataStatusKind { fresh, cache, offline }

/// Класс [DataStatusInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
class DataStatusInfo {
/// Создаёт [DataStatusInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  const DataStatusInfo({
    required this.kind,
    this.cachedAt,
  });

/// Поле [kind] класса [DataStatusInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final DataStatusKind kind;
/// Поле [cachedAt] класса [DataStatusInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final DateTime? cachedAt;

/// Getter [age] класса [DataStatusInfo].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  Duration? get age {
    if (cachedAt == null) return null;
    return DateTime.now().difference(cachedAt!);
  }
}

/// Typedef [CacheScopeEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
typedef CacheScopeEntry = ({String key, Duration ttl});

/// Функция [cacheEntriesFor] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
List<CacheScopeEntry> cacheEntriesFor(RefreshScope scope) {
  return switch (scope) {
    RefreshScope.currency => [
      (key: 'currency_rates', ttl: const Duration(minutes: ApiConfig.cacheCurrencyMinutes)),
    ],
    RefreshScope.inflation => [
      (key: 'inflation_data', ttl: const Duration(hours: ApiConfig.cacheInflationHours)),
    ],
    RefreshScope.markets => [
      (key: 'crypto_markets', ttl: const Duration(minutes: ApiConfig.cacheCryptoMinutes)),
      (key: 'stock_markets', ttl: const Duration(minutes: ApiConfig.cacheStockMinutes)),
    ],
    RefreshScope.cbr => [
      (key: 'cbr_key_rate', ttl: const Duration(hours: 6)),
    ],
    RefreshScope.global => [
      (key: 'currency_rates', ttl: const Duration(minutes: ApiConfig.cacheCurrencyMinutes)),
      (key: 'inflation_data', ttl: const Duration(hours: ApiConfig.cacheInflationHours)),
      (key: 'crypto_markets', ttl: const Duration(minutes: ApiConfig.cacheCryptoMinutes)),
      (key: 'stock_markets', ttl: const Duration(minutes: ApiConfig.cacheStockMinutes)),
      (key: 'cbr_key_rate', ttl: const Duration(hours: 6)),
      (key: 'commodities', ttl: const Duration(hours: 1)),
    ],
  };
}

/// Функция [resolveDataStatus] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
DataStatusInfo resolveDataStatus(
  RefreshScope scope, {
  required CacheService cache,
  bool hasLoadError = false,
}) {
  final entries = cacheEntriesFor(scope);
  DateTime? oldest;
  var anyStale = false;

  for (final entry in entries) {
    final ts = cache.cachedAt(entry.key);
    if (ts == null) continue;
    if (!cache.isFresh(entry.key, entry.ttl)) anyStale = true;
    if (oldest == null || ts.isBefore(oldest)) oldest = ts;
  }

  if (hasLoadError) {
    return DataStatusInfo(kind: DataStatusKind.offline, cachedAt: oldest);
  }
  if (anyStale) {
    return DataStatusInfo(kind: DataStatusKind.cache, cachedAt: oldest);
  }
  return DataStatusInfo(kind: DataStatusKind.fresh, cachedAt: oldest);
}

/// Функция [formatDataAge] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
String formatDataAge(Duration age, {required bool ru}) {
  if (age.inMinutes < 1) return ru ? 'только что' : 'just now';
  if (age.inMinutes < 60) {
    return ru ? '${age.inMinutes} мин назад' : '${age.inMinutes} min ago';
  }
  if (age.inHours < 24) {
    return ru ? '${age.inHours} ч назад' : '${age.inHours} h ago';
  }
  return ru ? '${age.inDays} д назад' : '${age.inDays} d ago';
}
