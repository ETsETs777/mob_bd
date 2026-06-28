// =============================================================================
// EcoPulse · lib/providers/watchlist_provider.dart
// Автор: Цымбал Е. В.
// Дата: 25.05.2026
// Riverpod state: провайдеры и notifiers. Файл: watchlist_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/candle_point.dart';
import '../data/models/chart_period.dart';
import '../data/models/market_asset.dart';
import '../data/services/cache_service.dart';

/// Функция [watchlistKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
String watchlistKey(MarketAsset asset) => '${asset.type.name}:${asset.id}';

/// Функция [assetHeroTitleTag] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
String assetHeroTitleTag(MarketAsset asset) => 'asset-title-${watchlistKey(asset)}';

/// Функция [assetHeroIconTag] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
String assetHeroIconTag(MarketAsset asset) => 'asset-icon-${watchlistKey(asset)}';

/// Функция [assetFromKey] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
MarketAsset? assetFromKey(String key, List<MarketAsset> all) {
  try {
    return all.firstWhere((a) => watchlistKey(a) == key);
  } catch (_) {
    return null;
  }
}

/// Riverpod: избранные активы watchlist.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final watchlistProvider =
    NotifierProvider<WatchlistNotifier, List<String>>(WatchlistNotifier.new);

/// Riverpod AsyncNotifier [WatchlistNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class WatchlistNotifier extends Notifier<List<String>> {
/// Поле [_cacheKey] класса [WatchlistNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  static const _cacheKey = 'watchlist';

/// Отрисовывает UI [WatchlistNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  @override
  List<String> build() {
    final raw = CacheService.instance.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<String>();
    } catch (_) {
      return [];
    }
  }

/// Метод [contains] класса [WatchlistNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  bool contains(MarketAsset asset) => state.contains(watchlistKey(asset));

/// Метод [toggle] класса [WatchlistNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> toggle(MarketAsset asset) async {
    final key = watchlistKey(asset);
    if (state.contains(key)) {
      state = state.where((k) => k != key).toList();
    } else {
      state = [...state, key];
    }
    await _persist();
  }

/// Метод [restoreKey] класса [WatchlistNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  Future<void> restoreKey(String key) async {
    if (state.contains(key)) return;
    state = [...state, key];
    await _persist();
  }

/// Приватный метод [_persist] класса [WatchlistNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  Future<void> _persist() async {
    await CacheService.instance.putString(_cacheKey, jsonEncode(state));
  }
}

/// Riverpod-провайдер [marketSearchQueryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
final marketSearchQueryProvider = StateProvider<String>((ref) => '');

/// Riverpod-провайдер [chartPeriodProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
final chartPeriodProvider = StateProvider<ChartPeriod>((ref) => ChartPeriod.d30);

/// Riverpod-провайдер [chartDisplayModeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final chartDisplayModeProvider =
    StateProvider<ChartDisplayMode>((ref) => ChartDisplayMode.line);

/// Функция [filterAssets] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
List<MarketAsset> filterAssets(List<MarketAsset> assets, String query) {
  if (query.trim().isEmpty) return assets;
  final q = query.toLowerCase();
  return assets
      .where(
        (a) =>
            a.symbol.toLowerCase().contains(q) ||
            a.name.toLowerCase().contains(q),
      )
      .toList();
}

/// Riverpod-провайдер [showWatchlistOnlyProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
final showWatchlistOnlyProvider = StateProvider<bool>((ref) => false);
