// =============================================================================
// EcoPulse · lib/providers/app_providers.dart
// Автор: Цымбал Е. В.
// Дата: 18.05.2026
// Глобальные Riverpod-провайдеры: валюты, инфляция, рынки, ключевая ставка.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/currency_rate.dart';
import '../../data/models/inflation_point.dart';
import '../../core/constants/market_catalog.dart';
import '../../data/models/crypto_feed.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/price_point.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/repositories/inflation_repository.dart';
import '../../data/repositories/market_repository.dart';
import '../../data/repositories/cbr_repository.dart';
import '../../data/demo/demo_fixtures.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/services/api_client.dart';
import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/app/demo_mode_provider.dart';

/// Riverpod-провайдер [cacheServiceProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService.instance;
});

/// Riverpod-провайдер [currencyRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  return CurrencyRepository(ref.watch(dioProvider), ref.watch(cacheServiceProvider));
});

/// Riverpod-провайдер [inflationRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final inflationRepositoryProvider = Provider<InflationRepository>((ref) {
  return InflationRepository(ref.watch(dioProvider), ref.watch(cacheServiceProvider));
});

/// Riverpod-провайдер [marketRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepository(ref.watch(dioProvider), ref.watch(cacheServiceProvider));
});

/// Riverpod-провайдер [cbrRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
final cbrRepositoryProvider = Provider<CbrRepository>((ref) {
  return CbrRepository(ref.watch(dioProvider), ref.watch(cacheServiceProvider));
});

/// Riverpod: ключевая ставка ЦБ РФ.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final keyRateProvider =
    AsyncNotifierProvider<KeyRateNotifier, KeyRateSnapshot>(
  KeyRateNotifier.new,
);

/// Riverpod AsyncNotifier [KeyRateNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class KeyRateNotifier extends AsyncNotifier<KeyRateSnapshot> {
/// Отрисовывает UI [KeyRateNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  Future<KeyRateSnapshot> build() => _load();

/// Перезагружает данные [KeyRateNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<KeyRateSnapshot>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [KeyRateNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<KeyRateSnapshot> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.keyRate);
    }
    return ref.read(cbrRepositoryProvider).fetchKeyRate(force: force);
  }
}

/// Riverpod: курсы валют (Frankfurter + MOEX).
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final currencyRatesProvider =
    AsyncNotifierProvider<CurrencyRatesNotifier, List<CurrencyRate>>(
  CurrencyRatesNotifier.new,
);

/// Riverpod AsyncNotifier [CurrencyRatesNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class CurrencyRatesNotifier extends AsyncNotifier<List<CurrencyRate>> {
/// Отрисовывает UI [CurrencyRatesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  Future<List<CurrencyRate>> build() => _load();

/// Перезагружает данные [CurrencyRatesNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<List<CurrencyRate>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [CurrencyRatesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<List<CurrencyRate>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.currencyRates);
    }
    return ref.read(currencyRepositoryProvider).fetchRates(force: force);
  }
}

/// Riverpod: инфляция CPI по странам (World Bank).
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final inflationProvider =
    AsyncNotifierProvider<InflationNotifier, List<InflationPoint>>(
  InflationNotifier.new,
);

/// Riverpod AsyncNotifier [InflationNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class InflationNotifier extends AsyncNotifier<List<InflationPoint>> {
/// Отрисовывает UI [InflationNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  Future<List<InflationPoint>> build() => _load();

/// Перезагружает данные [InflationNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<List<InflationPoint>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [InflationNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<List<InflationPoint>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.inflation);
    }
    return ref.read(inflationRepositoryProvider).fetchInflation(force: force);
  }
}

/// Riverpod-провайдер [cryptoProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final cryptoProvider =
    AsyncNotifierProvider<CryptoNotifier, CryptoFeed>(CryptoNotifier.new);

/// Riverpod AsyncNotifier [CryptoNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class CryptoNotifier extends AsyncNotifier<CryptoFeed> {
/// Отрисовывает UI [CryptoNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  Future<CryptoFeed> build() => _load(pages: 1);

/// Перезагружает данные [CryptoNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<CryptoFeed>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(pages: 1, force: force));
  }

/// Метод [loadMore] класса [CryptoNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.loadingMore ||
        !current.hasMore ||
        current.loadedPages >= CryptoCatalog.pages) {
      return;
    }

    state = AsyncData(current.copyWith(loadingMore: true));
    final nextPage = current.loadedPages + 1;

    try {
      final pageAssets = await ref
          .read(marketRepositoryProvider)
          .fetchCryptoPage(nextPage);
      final existingIds = current.assets.map((a) => a.id).toSet();
      final merged = [
        ...current.assets,
        ...pageAssets.where((a) => !existingIds.contains(a.id)),
      ];
      state = AsyncData(
        CryptoFeed(
          assets: merged,
          loadedPages: nextPage,
        ),
      );
    } catch (e, st) {
      state = AsyncValue<CryptoFeed>.error(e, st).copyWithPrevious(state);
    }
  }

/// Метод [loadAll] класса [CryptoNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> loadAll({bool force = false}) async {
    state = await AsyncValue.guard(
      () => _load(pages: CryptoCatalog.pages, force: force),
    );
  }

/// Приватный метод [_load] класса [CryptoNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<CryptoFeed> _load({required int pages, bool force = false}) async {
    if (ref.read(demoModeProvider)) {
      return DemoFixtures.cryptoFeed;
    }
    final assets = await ref.read(marketRepositoryProvider).fetchCrypto(
          force: force,
          pages: pages,
        );
    return CryptoFeed(
      assets: assets,
      loadedPages: pages.clamp(1, CryptoCatalog.pages),
    );
  }
}

/// Riverpod-провайдер [stocksProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final stocksProvider =
    AsyncNotifierProvider<StocksNotifier, List<MarketAsset>>(StocksNotifier.new);

/// Riverpod AsyncNotifier [StocksNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class StocksNotifier extends AsyncNotifier<List<MarketAsset>> {
/// Отрисовывает UI [StocksNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  @override
  Future<List<MarketAsset>> build() => _load();

/// Перезагружает данные [StocksNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<List<MarketAsset>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [StocksNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<List<MarketAsset>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.stocks);
    }
    return ref.read(marketRepositoryProvider).fetchStocks(force: force);
  }
}

/// Riverpod-провайдер [bondsProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final bondsProvider =
    AsyncNotifierProvider<BondsNotifier, List<MarketAsset>>(BondsNotifier.new);

/// Riverpod AsyncNotifier [BondsNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class BondsNotifier extends AsyncNotifier<List<MarketAsset>> {
/// Отрисовывает UI [BondsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  @override
  Future<List<MarketAsset>> build() => _load();

/// Перезагружает данные [BondsNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<List<MarketAsset>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [BondsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<List<MarketAsset>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.bonds);
    }
    return ref.read(marketRepositoryProvider).fetchBonds(force: force);
  }
}

/// Класс [AssetDetailParams].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
class AssetDetailParams {
/// Создаёт [AssetDetailParams].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  const AssetDetailParams({required this.asset, required this.days});

/// Поле [asset] класса [AssetDetailParams].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final MarketAsset asset;
/// Поле [days] класса [AssetDetailParams].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final int days;

/// Метод [==] класса [AssetDetailParams].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  @override
  bool operator ==(Object other) =>
      other is AssetDetailParams &&
      other.asset.id == asset.id &&
      other.asset.type == asset.type &&
      other.days == days;

  @override
  int get hashCode => Object.hash(asset.id, asset.type, days);
}

/// Riverpod-провайдер [assetDetailProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final assetDetailProvider =
    FutureProvider.family<AssetDetail, AssetDetailParams>(
  (ref, params) async {
    if (ref.read(demoModeProvider)) {
      final spark = params.asset.sparkline;
      final history = spark.isEmpty
          ? <PricePoint>[]
          : spark.asMap().entries.map((e) {
              return PricePoint(
                date: DateTime.now().subtract(
                  Duration(days: spark.length - e.key),
                ),
                value: e.value,
              );
            }).toList();
      return AssetDetail(asset: params.asset, history: history);
    }
    return ref
        .read(marketRepositoryProvider)
        .fetchAssetDetail(params.asset, days: params.days);
  },
);

/// Riverpod-провайдер [converterAmountProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
final converterAmountProvider = StateProvider<double>((ref) => 1);
/// Riverpod-провайдер [converterFeeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
final converterFeeProvider = StateProvider<double>((ref) => 0);
/// Riverpod-провайдер [converterFromProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final converterFromProvider = StateProvider<String>((ref) => 'USD');
/// Riverpod-провайдер [converterToProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
final converterToProvider = StateProvider<String>((ref) => 'RUB');


/// Riverpod: индекс активного таба shell (0–5).
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final navigationIndexProvider = StateProvider<int>((ref) {
  final raw = CacheService.instance.getString('default_tab');
  if (raw == null) return 0;
  final index = int.tryParse(raw);
  if (index == null || index < 0) return 0;
  if (index > 5) return index == 6 ? 5 : 0;
  return index;
});

/// Подвкладка «Сообщество» при переходе из профиля (0 — чаты, 1 — статьи).
final communityInitialTabProvider = StateProvider<int>((ref) => 0);
