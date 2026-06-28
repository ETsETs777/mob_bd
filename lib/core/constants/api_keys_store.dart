// =============================================================================
// EcoPulse · lib/core/constants/api_keys_store.dart
// Автор: Цымбал Е. В.
// Дата: 29.04.2026
// Константы и каталоги (API, рынки, облигации). Файл: api_keys_store.
// =============================================================================

/// Хранилище API-ключей: compile-time + runtime (Hive).
class ApiKeysStore {
/// Создаёт [ApiKeysStore] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  ApiKeysStore._();
/// Поле [instance] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static final instance = ApiKeysStore._();

/// Поле [_coingeckoEnv] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static const _coingeckoEnv = String.fromEnvironment(
    'COINGECKO_KEY',
    defaultValue: '',
  );
/// Поле [_finnhubEnv] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static const _finnhubEnv = String.fromEnvironment(
    'FINNHUB_KEY',
    defaultValue: '',
  );
/// Поле [_geminiEnv] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  static const _geminiEnv = String.fromEnvironment(
    'GEMINI_KEY',
    defaultValue: '',
  );

/// Поле [_coingeckoCacheKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static const _coingeckoCacheKey = 'api_key_coingecko';
/// Поле [_finnhubCacheKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static const _finnhubCacheKey = 'api_key_finnhub';
/// Поле [_geminiCacheKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static const _geminiCacheKey = 'api_key_gemini';

/// Поле [_coingecko] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  String _coingecko = _coingeckoEnv;
/// Поле [_finnhub] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  String _finnhub = _finnhubEnv;
/// Поле [_gemini] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  String _gemini = _geminiEnv;

/// Getter [coingeckoKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  String get coingeckoKey => _coingecko;
/// Getter [finnhubKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  String get finnhubKey => _finnhub;
/// Getter [geminiKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  String get geminiKey => _gemini;

/// Getter [hasCoingeckoKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  bool get hasCoingeckoKey => _coingecko.isNotEmpty;
/// Getter [hasFinnhubKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  bool get hasFinnhubKey => _finnhub.isNotEmpty;
/// Getter [hasGeminiKey] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  bool get hasGeminiKey => _gemini.isNotEmpty;

/// Метод [loadFromCache] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  Future<void> loadFromCache(
    Future<String?> Function(String key) read,
  ) async {
    final cg = await read(_coingeckoCacheKey);
    final fh = await read(_finnhubCacheKey);
    final gm = await read(_geminiCacheKey);
    if (cg != null && cg.isNotEmpty) _coingecko = cg;
    if (fh != null && fh.isNotEmpty) _finnhub = fh;
    if (gm != null && gm.isNotEmpty) _gemini = gm;
  }

/// Метод [setCoingecko] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  Future<void> setCoingecko(
    String key,
    Future<void> Function(String cacheKey, String value) write,
  ) async {
    _coingecko = key.trim();
    await write(_coingeckoCacheKey, _coingecko);
  }

/// Метод [setFinnhub] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  Future<void> setFinnhub(
    String key,
    Future<void> Function(String cacheKey, String value) write,
  ) async {
    _finnhub = key.trim();
    await write(_finnhubCacheKey, _finnhub);
  }

/// Метод [setGemini] класса [ApiKeysStore].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  Future<void> setGemini(
    String key,
    Future<void> Function(String cacheKey, String value) write,
  ) async {
    _gemini = key.trim();
    await write(_geminiCacheKey, _gemini);
  }
}
