// =============================================================================
// EcoPulse · lib/providers/api_keys_provider.dart
// Автор: Цымбал Е. В.
// Дата: 18.05.2026
// Riverpod state: провайдеры и notifiers. Файл: api_keys_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_keys_store.dart';
import '../../data/services/cache_service.dart';

/// Riverpod-провайдер [apiKeysProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final apiKeysProvider =
    NotifierProvider<ApiKeysNotifier, ApiKeysState>(ApiKeysNotifier.new);

/// Класс [ApiKeysState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class ApiKeysState {
/// Создаёт [ApiKeysState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  const ApiKeysState({
    required this.coingecko,
    required this.finnhub,
    required this.gemini,
    required this.tinkoffBroker,
  });

/// Поле [coingecko] класса [ApiKeysState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  final String coingecko;
/// Поле [finnhub] класса [ApiKeysState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  final String finnhub;
/// Поле [gemini] класса [ApiKeysState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final String gemini;
  final String tinkoffBroker;

  bool get hasCoingecko => coingecko.isNotEmpty;
  bool get hasFinnhub => finnhub.isNotEmpty;
  bool get hasGemini => gemini.isNotEmpty;
  bool get hasTinkoffBroker => tinkoffBroker.isNotEmpty;
}

/// Riverpod AsyncNotifier [ApiKeysNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
class ApiKeysNotifier extends Notifier<ApiKeysState> {
/// Отрисовывает UI [ApiKeysNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  @override
  ApiKeysState build() {
    final store = ApiKeysStore.instance;
    return ApiKeysState(
      coingecko: store.coingeckoKey,
      finnhub: store.finnhubKey,
      gemini: store.geminiKey,
      tinkoffBroker: store.tinkoffBrokerToken,
    );
  }

/// Метод [init] класса [ApiKeysNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> init() async {
    await ApiKeysStore.instance.loadFromCache(
      (key) async => CacheService.instance.getString(key),
    );
    _syncState();
  }

/// Метод [saveCoingecko] класса [ApiKeysNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> saveCoingecko(String key) async {
    await ApiKeysStore.instance.setCoingecko(
      key,
      (k, v) => CacheService.instance.putString(k, v),
    );
    _syncState();
  }

/// Метод [saveFinnhub] класса [ApiKeysNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> saveFinnhub(String key) async {
    await ApiKeysStore.instance.setFinnhub(
      key,
      (k, v) => CacheService.instance.putString(k, v),
    );
    _syncState();
  }

/// Метод [saveGemini] класса [ApiKeysNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  Future<void> saveGemini(String key) async {
    await ApiKeysStore.instance.setGemini(
      key,
      (k, v) => CacheService.instance.putString(k, v),
    );
    _syncState();
  }

  Future<void> saveTinkoffBroker(String key) async {
    await ApiKeysStore.instance.setTinkoffBroker(
      key,
      (k, v) => CacheService.instance.putString(k, v),
    );
    _syncState();
  }

  void _syncState() {
    final store = ApiKeysStore.instance;
    state = ApiKeysState(
      coingecko: store.coingeckoKey,
      finnhub: store.finnhubKey,
      gemini: store.geminiKey,
      tinkoffBroker: store.tinkoffBrokerToken,
    );
  }
}
