// =============================================================================
// EcoPulse · lib/core/constants/app_constants.dart
// Автор: Цымбал Е. В.
// Дата: 29.04.2026
// Константы и каталоги (API, рынки, облигации). Файл: app_constants.
// =============================================================================

import 'market_catalog.dart';

/// Класс [AppConstants].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
class AppConstants {
/// Getter [frankfurterCurrencies] класса [AppConstants].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static List<String> get frankfurterCurrencies => CurrencyCatalog.fxCodes;
/// Getter [moexStocks] класса [AppConstants].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static List<String> get moexStocks => MoexCatalog.tickers;
/// Getter [finnhubStocks] класса [AppConstants].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static List<String> get finnhubStocks => UsCatalog.tickers;

/// Поле [inflationCountries] класса [AppConstants].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.04.2026
  static const inflationCountries = {
    'RU': 'Россия',
    'US': 'США',
    'CN': 'Китай',
    'DE': 'Германия',
    'TR': 'Турция',
    'BR': 'Бразилия',
    'IN': 'Индия',
    'JP': 'Япония',
  };

  /// Текущий календарный год для диапазонов API.
  static int get currentYear => DateTime.now().year;

  /// С какого года тянем историю инфляции World Bank.
  static const inflationHistoryFromYear = 2015;

  /// Базовый год для chip «покупательная способность» на карточках инфляции.
  static const purchasingPowerBaseYear = 2020;
}
