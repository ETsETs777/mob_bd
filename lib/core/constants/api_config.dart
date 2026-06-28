// =============================================================================
// EcoPulse · lib/core/constants/api_config.dart
// Автор: Цымбал Е. В.
// Дата: 29.04.2026
// Константы и каталоги (API, рынки, облигации). Файл: api_config.
// =============================================================================

import '../constants/api_keys_store.dart';

/// Класс [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
class ApiConfig {
/// Поле [frankfurterBase] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static const frankfurterBase = 'https://api.frankfurter.dev/v1';
/// Поле [moexBase] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static const moexBase = 'https://iss.moex.com/iss';
/// Поле [worldBankBase] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static const worldBankBase = 'https://api.worldbank.org/v2';
/// Поле [coinGeckoBase] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  static const coinGeckoBase = 'https://api.coingecko.com/api/v3';
/// Поле [finnhubBase] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static const finnhubBase = 'https://finnhub.io/api/v1';

/// Getter [coingeckoDemoKey] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static String get coingeckoDemoKey => ApiKeysStore.instance.coingeckoKey;
/// Getter [finnhubKey] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static String get finnhubKey => ApiKeysStore.instance.finnhubKey;

/// Поле [cacheCurrencyMinutes] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static const cacheCurrencyMinutes = 15;
/// Поле [cacheInflationHours] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  static const cacheInflationHours = 24;
/// Поле [cacheCryptoMinutes] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static const cacheCryptoMinutes = 5;
/// Поле [cacheStockMinutes] класса [ApiConfig].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static const cacheStockMinutes = 3;
}
