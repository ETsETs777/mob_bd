// =============================================================================
// EcoPulse · lib/core/constants/market_catalog.dart
// Автор: Цымбал Е. В.
// Дата: 30.04.2026
// Константы и каталоги (API, рынки, облигации). Файл: market_catalog.
// =============================================================================

/// Каталоги тикеров и валют — единый источник для репозиториев и UI.

import '../../data/models/market_asset.dart';

/// Enum [CurrencyGroup] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
/// Значение enum [moex].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [major].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
/// Значение enum [europe].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Значение enum [asia].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
/// Значение enum [em].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
/// Значение enum [americas].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [americas].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
/// Значение enum [em].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Значение enum [asia].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
/// Значение enum [europe].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
/// Значение enum [major].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [moex].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
enum CurrencyGroup { moex, major, europe, asia, em, americas }

/// Класс [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class CurrencyCatalogEntry {
/// Создаёт [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  const CurrencyCatalogEntry({
    required this.code,
    required this.nameRu,
    required this.nameEn,
    required this.group,
    this.withHistory = false,
  });

/// Поле [code] класса [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final String code;
/// Поле [nameRu] класса [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final String nameRu;
/// Поле [nameEn] класса [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String nameEn;
/// Поле [group] класса [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final CurrencyGroup group;
/// Поле [withHistory] класса [CurrencyCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  final bool withHistory;
}

/// Класс [MoexCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
class MoexCatalogEntry {
/// Создаёт [MoexCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  const MoexCatalogEntry({
    required this.ticker,
    required this.sector,
    this.isIndex = false,
  });

/// Поле [ticker] класса [MoexCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String ticker;
/// Поле [sector] класса [MoexCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String sector;
/// Поле [isIndex] класса [MoexCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  final bool isIndex;
}

/// Класс [UsCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
class UsCatalogEntry {
/// Создаёт [UsCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  const UsCatalogEntry({
    required this.ticker,
    this.sector = 'us',
    this.isEtf = false,
  });

/// Поле [ticker] класса [UsCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String ticker;
/// Поле [sector] класса [UsCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String sector;
/// Поле [isEtf] класса [UsCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  final bool isEtf;
}

/// Класс [MoexRubPairEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
class MoexRubPairEntry {
/// Создаёт [MoexRubPairEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  const MoexRubPairEntry({
    required this.code,
    required this.security,
    this.withHistory = false,
  });

/// Поле [code] класса [MoexRubPairEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String code;
/// Поле [security] класса [MoexRubPairEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String security;
/// Поле [withHistory] класса [MoexRubPairEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  final bool withHistory;
}

/// Класс [CurrencyCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
abstract final class CurrencyCatalog {
/// Поле [entries] класса [CurrencyCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static const entries = [
    CurrencyCatalogEntry(
      code: 'EUR',
      nameRu: 'Евро',
      nameEn: 'Euro',
      group: CurrencyGroup.major,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'GBP',
      nameRu: 'Фунт',
      nameEn: 'British Pound',
      group: CurrencyGroup.major,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'CHF',
      nameRu: 'Франк',
      nameEn: 'Swiss Franc',
      group: CurrencyGroup.europe,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'JPY',
      nameRu: 'Иена',
      nameEn: 'Japanese Yen',
      group: CurrencyGroup.asia,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'CNY',
      nameRu: 'Юань',
      nameEn: 'Chinese Yuan',
      group: CurrencyGroup.asia,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'TRY',
      nameRu: 'Лира',
      nameEn: 'Turkish Lira',
      group: CurrencyGroup.em,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'INR',
      nameRu: 'Рупия',
      nameEn: 'Indian Rupee',
      group: CurrencyGroup.asia,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'KRW',
      nameRu: 'Вона',
      nameEn: 'Korean Won',
      group: CurrencyGroup.asia,
    ),
    CurrencyCatalogEntry(
      code: 'SGD',
      nameRu: 'Синг. доллар',
      nameEn: 'Singapore Dollar',
      group: CurrencyGroup.asia,
    ),
    CurrencyCatalogEntry(
      code: 'HKD',
      nameRu: 'HKD',
      nameEn: 'Hong Kong Dollar',
      group: CurrencyGroup.asia,
    ),
    CurrencyCatalogEntry(
      code: 'THB',
      nameRu: 'Бат',
      nameEn: 'Thai Baht',
      group: CurrencyGroup.asia,
    ),
    CurrencyCatalogEntry(
      code: 'IDR',
      nameRu: 'Рупия ID',
      nameEn: 'Indonesian Rupiah',
      group: CurrencyGroup.asia,
    ),
    CurrencyCatalogEntry(
      code: 'MYR',
      nameRu: 'Рингgit',
      nameEn: 'Malaysian Ringgit',
      group: CurrencyGroup.asia,
    ),
    CurrencyCatalogEntry(
      code: 'CAD',
      nameRu: 'Кан. доллар',
      nameEn: 'Canadian Dollar',
      group: CurrencyGroup.americas,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'BRL',
      nameRu: 'Реал',
      nameEn: 'Brazilian Real',
      group: CurrencyGroup.americas,
    ),
    CurrencyCatalogEntry(
      code: 'MXN',
      nameRu: 'Песо',
      nameEn: 'Mexican Peso',
      group: CurrencyGroup.americas,
    ),
    CurrencyCatalogEntry(
      code: 'PLN',
      nameRu: 'Злотый',
      nameEn: 'Polish Zloty',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'CZK',
      nameRu: 'Крона CZ',
      nameEn: 'Czech Koruna',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'HUF',
      nameRu: 'Форинт',
      nameEn: 'Hungarian Forint',
      group: CurrencyGroup.em,
    ),
    CurrencyCatalogEntry(
      code: 'RON',
      nameRu: 'Лей',
      nameEn: 'Romanian Leu',
      group: CurrencyGroup.em,
    ),
    CurrencyCatalogEntry(
      code: 'ZAR',
      nameRu: 'Rand',
      nameEn: 'South African Rand',
      group: CurrencyGroup.em,
    ),
    CurrencyCatalogEntry(
      code: 'AUD',
      nameRu: 'Австр. доллар',
      nameEn: 'Australian Dollar',
      group: CurrencyGroup.americas,
    ),
    CurrencyCatalogEntry(
      code: 'NZD',
      nameRu: 'NZD',
      nameEn: 'New Zealand Dollar',
      group: CurrencyGroup.americas,
    ),
    CurrencyCatalogEntry(
      code: 'SEK',
      nameRu: 'Крона SE',
      nameEn: 'Swedish Krona',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'NOK',
      nameRu: 'Крона NO',
      nameEn: 'Norwegian Krone',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'DKK',
      nameRu: 'Крона DK',
      nameEn: 'Danish Krone',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'BGN',
      nameRu: 'Лев',
      nameEn: 'Bulgarian Lev',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'ISK',
      nameRu: 'Исландская крона',
      nameEn: 'Icelandic Krona',
      group: CurrencyGroup.europe,
    ),
    CurrencyCatalogEntry(
      code: 'ILS',
      nameRu: 'Шекель',
      nameEn: 'Israeli Shekel',
      group: CurrencyGroup.em,
      withHistory: true,
    ),
    CurrencyCatalogEntry(
      code: 'PHP',
      nameRu: 'Песо PH',
      nameEn: 'Philippine Peso',
      group: CurrencyGroup.asia,
    ),
  ];

  /// Пары MOEX (RUB) — загружаются отдельно от Frankfurter.
  static const moexRubPairs = [
    MoexRubPairEntry(code: 'EUR', security: 'EUR_RUB__TOM', withHistory: true),
    MoexRubPairEntry(code: 'GBP', security: 'GBP_RUB__TOM', withHistory: true),
    MoexRubPairEntry(code: 'CNY', security: 'CNY_RUB__TOM', withHistory: true),
    MoexRubPairEntry(code: 'CHF', security: 'CHF_RUB__TOM'),
    MoexRubPairEntry(code: 'TRY', security: 'TRY_RUB__TOM', withHistory: true),
    MoexRubPairEntry(code: 'HKD', security: 'HKD_RUB__TOM'),
    MoexRubPairEntry(code: 'JPY', security: 'JPY_RUB__TOM'),
    MoexRubPairEntry(code: 'KZT', security: 'KZT_RUB__TOM'),
    MoexRubPairEntry(code: 'BYN', security: 'BYN_RUB__TOM'),
    MoexRubPairEntry(code: 'AMD', security: 'AMD_RUB__TOM'),
    MoexRubPairEntry(code: 'AZN', security: 'AZN_RUB__TOM'),
    MoexRubPairEntry(code: 'UZS', security: 'UZS_RUB__TOM'),
    MoexRubPairEntry(code: 'AED', security: 'AED_RUB__TOM'),
    MoexRubPairEntry(code: 'SGD', security: 'SGD_RUB__TOM'),
  ];

/// Getter [fxCodes] класса [CurrencyCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static List<String> get fxCodes => entries.map((e) => e.code).toList();

/// Getter [historyCodes] класса [CurrencyCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  static List<String> get historyCodes =>
      entries.where((e) => e.withHistory).map((e) => e.code).toList();

/// Метод [byCode] класса [CurrencyCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static CurrencyCatalogEntry? byCode(String code) {
    for (final e in entries) {
      if (e.code == code) return e;
    }
    return null;
  }
}

/// Класс [MoexCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
abstract final class MoexCatalog {
/// Поле [entries] класса [MoexCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static const entries = [
    MoexCatalogEntry(ticker: 'IMOEX', sector: 'index', isIndex: true),
    MoexCatalogEntry(ticker: 'RTSI', sector: 'index', isIndex: true),
    MoexCatalogEntry(ticker: 'SBER', sector: 'finance'),
    MoexCatalogEntry(ticker: 'VTBR', sector: 'finance'),
    MoexCatalogEntry(ticker: 'MOEX', sector: 'finance'),
    MoexCatalogEntry(ticker: 'CBOM', sector: 'finance'),
    MoexCatalogEntry(ticker: 'GAZP', sector: 'energy'),
    MoexCatalogEntry(ticker: 'LKOH', sector: 'energy'),
    MoexCatalogEntry(ticker: 'ROSN', sector: 'energy'),
    MoexCatalogEntry(ticker: 'NVTK', sector: 'energy'),
    MoexCatalogEntry(ticker: 'TATN', sector: 'energy'),
    MoexCatalogEntry(ticker: 'SNGS', sector: 'energy'),
    MoexCatalogEntry(ticker: 'GMKN', sector: 'metals'),
    MoexCatalogEntry(ticker: 'ALRS', sector: 'metals'),
    MoexCatalogEntry(ticker: 'CHMF', sector: 'metals'),
    MoexCatalogEntry(ticker: 'NLMK', sector: 'metals'),
    MoexCatalogEntry(ticker: 'MAGN', sector: 'metals'),
    MoexCatalogEntry(ticker: 'PLZL', sector: 'metals'),
    MoexCatalogEntry(ticker: 'YDEX', sector: 'it'),
    MoexCatalogEntry(ticker: 'VKCO', sector: 'it'),
    MoexCatalogEntry(ticker: 'OZON', sector: 'it'),
    MoexCatalogEntry(ticker: 'MTSS', sector: 'telecom'),
    MoexCatalogEntry(ticker: 'RTKM', sector: 'telecom'),
    MoexCatalogEntry(ticker: 'MGNT', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'FIVE', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'AFLT', sector: 'transport'),
    MoexCatalogEntry(ticker: 'PIKK', sector: 'realestate'),
    MoexCatalogEntry(ticker: 'SMLT', sector: 'realestate'),
    MoexCatalogEntry(ticker: 'PHOR', sector: 'chemicals'),
    MoexCatalogEntry(ticker: 'AFKS', sector: 'telecom'),
    MoexCatalogEntry(ticker: 'BSPB', sector: 'finance'),
    MoexCatalogEntry(ticker: 'SFIN', sector: 'finance'),
    MoexCatalogEntry(ticker: 'SPBE', sector: 'finance'),
    MoexCatalogEntry(ticker: 'LENT', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'MVID', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'BELU', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'AQUA', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'MTLR', sector: 'metals'),
    MoexCatalogEntry(ticker: 'RUAL', sector: 'metals'),
    MoexCatalogEntry(ticker: 'SELG', sector: 'metals'),
    MoexCatalogEntry(ticker: 'TRNFP', sector: 'energy'),
    MoexCatalogEntry(ticker: 'IRAO', sector: 'energy'),
    MoexCatalogEntry(ticker: 'HYDR', sector: 'energy'),
    MoexCatalogEntry(ticker: 'FEES', sector: 'energy'),
    MoexCatalogEntry(ticker: 'ENPG', sector: 'energy'),
    MoexCatalogEntry(ticker: 'SIBN', sector: 'energy'),
    MoexCatalogEntry(ticker: 'UPRO', sector: 'energy'),
    MoexCatalogEntry(ticker: 'HEAD', sector: 'it'),
    MoexCatalogEntry(ticker: 'WUSH', sector: 'it'),
    MoexCatalogEntry(ticker: 'POSI', sector: 'it'),
    MoexCatalogEntry(ticker: 'SBERP', sector: 'finance'),
    MoexCatalogEntry(ticker: 'TATNP', sector: 'energy'),
    MoexCatalogEntry(ticker: 'SNGSP', sector: 'energy'),
    MoexCatalogEntry(ticker: 'RNFT', sector: 'energy'),
    MoexCatalogEntry(ticker: 'LEAS', sector: 'finance'),
    MoexCatalogEntry(ticker: 'RENI', sector: 'finance'),
    MoexCatalogEntry(ticker: 'SVCB', sector: 'finance'),
    MoexCatalogEntry(ticker: 'RASP', sector: 'metals'),
    MoexCatalogEntry(ticker: 'TRMK', sector: 'metals'),
    MoexCatalogEntry(ticker: 'SGZH', sector: 'metals'),
    MoexCatalogEntry(ticker: 'VSMO', sector: 'metals'),
    MoexCatalogEntry(ticker: 'NKNC', sector: 'chemicals'),
    MoexCatalogEntry(ticker: 'NKNCP', sector: 'chemicals'),
    MoexCatalogEntry(ticker: 'FLOT', sector: 'transport'),
    MoexCatalogEntry(ticker: 'NMTP', sector: 'transport'),
    MoexCatalogEntry(ticker: 'KMAZ', sector: 'industrial'),
    MoexCatalogEntry(ticker: 'UWGN', sector: 'industrial'),
    MoexCatalogEntry(ticker: 'CARM', sector: 'auto'),
    MoexCatalogEntry(ticker: 'ASTR', sector: 'it'),
    MoexCatalogEntry(ticker: 'MDMG', sector: 'health'),
    MoexCatalogEntry(ticker: 'MRKC', sector: 'energy'),
    MoexCatalogEntry(ticker: 'MSNG', sector: 'energy'),
    MoexCatalogEntry(ticker: 'T', sector: 'finance'),
    // ETF (борд TQTF)
    MoexCatalogEntry(ticker: 'TMOS', sector: 'etf'),
    MoexCatalogEntry(ticker: 'SBMX', sector: 'etf'),
    MoexCatalogEntry(ticker: 'FXRL', sector: 'etf'),
    MoexCatalogEntry(ticker: 'FXUS', sector: 'etf'),
    MoexCatalogEntry(ticker: 'FXGD', sector: 'etf'),
    MoexCatalogEntry(ticker: 'TPAY', sector: 'etf'),
    MoexCatalogEntry(ticker: 'TBRU', sector: 'etf'),
    MoexCatalogEntry(ticker: 'SBGB', sector: 'etf'),
    // Доп. ликвидные акции
    MoexCatalogEntry(ticker: 'X5', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'FIXP', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'DOMRF', sector: 'realestate'),
    MoexCatalogEntry(ticker: 'MTLRP', sector: 'metals'),
    MoexCatalogEntry(ticker: 'AKRN', sector: 'chemicals'),
    MoexCatalogEntry(ticker: 'LSNG', sector: 'energy'),
    MoexCatalogEntry(ticker: 'LSNGP', sector: 'energy'),
    MoexCatalogEntry(ticker: 'AGRO', sector: 'consumer'),
    MoexCatalogEntry(ticker: 'MBNK', sector: 'finance'),
    MoexCatalogEntry(ticker: 'FESH', sector: 'transport'),
    MoexCatalogEntry(ticker: 'EUTR', sector: 'transport'),
    MoexCatalogEntry(ticker: 'GLTR', sector: 'metals'),
    MoexCatalogEntry(ticker: 'RBCM', sector: 'finance'),
    MoexCatalogEntry(ticker: 'ZAYM', sector: 'finance'),
    MoexCatalogEntry(ticker: 'LSRG', sector: 'realestate'),
    MoexCatalogEntry(ticker: 'OKEY', sector: 'consumer'),
  ];

/// Getter [tickers] класса [MoexCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static List<String> get tickers => entries.map((e) => e.ticker).toList();

/// Метод [byTicker] класса [MoexCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  static MoexCatalogEntry? byTicker(String ticker) {
    for (final e in entries) {
      if (e.ticker == ticker) return e;
    }
    return null;
  }
}

/// Класс [UsIndexEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
class UsIndexEntry {
/// Создаёт [UsIndexEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  const UsIndexEntry({required this.ticker, required this.displayName});

/// Поле [ticker] класса [UsIndexEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final String ticker;
/// Поле [displayName] класса [UsIndexEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String displayName;
}

/// Класс [UsIndicesCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
abstract final class UsIndicesCatalog {
/// Поле [entries] класса [UsIndicesCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static const entries = [
    UsIndexEntry(ticker: 'SPY', displayName: 'S&P 500'),
    UsIndexEntry(ticker: 'QQQ', displayName: 'NASDAQ 100'),
  ];

/// Getter [tickers] класса [UsIndicesCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static List<String> get tickers => entries.map((e) => e.ticker).toList();
}

/// Класс [UsCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
abstract final class UsCatalog {
/// Поле [entries] класса [UsCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static const entries = [
    UsCatalogEntry(ticker: 'SPY', sector: 'etf', isEtf: true),
    UsCatalogEntry(ticker: 'QQQ', sector: 'etf', isEtf: true),
    UsCatalogEntry(ticker: 'DIA', sector: 'etf', isEtf: true),
    UsCatalogEntry(ticker: 'IWM', sector: 'etf', isEtf: true),
    UsCatalogEntry(ticker: 'AAPL', sector: 'tech'),
    UsCatalogEntry(ticker: 'MSFT', sector: 'tech'),
    UsCatalogEntry(ticker: 'GOOGL', sector: 'tech'),
    UsCatalogEntry(ticker: 'AMZN', sector: 'tech'),
    UsCatalogEntry(ticker: 'NVDA', sector: 'tech'),
    UsCatalogEntry(ticker: 'META', sector: 'tech'),
    UsCatalogEntry(ticker: 'TSLA', sector: 'auto'),
    UsCatalogEntry(ticker: 'AMD', sector: 'tech'),
    UsCatalogEntry(ticker: 'NFLX', sector: 'tech'),
    UsCatalogEntry(ticker: 'CRM', sector: 'tech'),
    UsCatalogEntry(ticker: 'INTC', sector: 'tech'),
    UsCatalogEntry(ticker: 'JPM', sector: 'finance'),
    UsCatalogEntry(ticker: 'BAC', sector: 'finance'),
    UsCatalogEntry(ticker: 'V', sector: 'finance'),
    UsCatalogEntry(ticker: 'MA', sector: 'finance'),
    UsCatalogEntry(ticker: 'UNH', sector: 'health'),
    UsCatalogEntry(ticker: 'JNJ', sector: 'health'),
    UsCatalogEntry(ticker: 'XOM', sector: 'energy'),
    UsCatalogEntry(ticker: 'PG', sector: 'consumer'),
    UsCatalogEntry(ticker: 'HD', sector: 'consumer'),
    UsCatalogEntry(ticker: 'WMT', sector: 'consumer'),
    UsCatalogEntry(ticker: 'COST', sector: 'consumer'),
    UsCatalogEntry(ticker: 'DIS', sector: 'media'),
    UsCatalogEntry(ticker: 'BA', sector: 'industrial'),
    UsCatalogEntry(ticker: 'GOOG', sector: 'tech'),
    UsCatalogEntry(ticker: 'LLY', sector: 'health'),
    UsCatalogEntry(ticker: 'AVGO', sector: 'tech'),
    UsCatalogEntry(ticker: 'ORCL', sector: 'tech'),
    UsCatalogEntry(ticker: 'ADBE', sector: 'tech'),
    UsCatalogEntry(ticker: 'PEP', sector: 'consumer'),
    UsCatalogEntry(ticker: 'KO', sector: 'consumer'),
    UsCatalogEntry(ticker: 'TMO', sector: 'health'),
    UsCatalogEntry(ticker: 'ABBV', sector: 'health'),
    UsCatalogEntry(ticker: 'MRK', sector: 'health'),
    UsCatalogEntry(ticker: 'PFE', sector: 'health'),
    UsCatalogEntry(ticker: 'CVX', sector: 'energy'),
    UsCatalogEntry(ticker: 'COP', sector: 'energy'),
    UsCatalogEntry(ticker: 'GS', sector: 'finance'),
    UsCatalogEntry(ticker: 'MS', sector: 'finance'),
    UsCatalogEntry(ticker: 'WFC', sector: 'finance'),
    UsCatalogEntry(ticker: 'PYPL', sector: 'finance'),
    UsCatalogEntry(ticker: 'COIN', sector: 'finance'),
    UsCatalogEntry(ticker: 'PLTR', sector: 'tech'),
    UsCatalogEntry(ticker: 'UBER', sector: 'tech'),
    UsCatalogEntry(ticker: 'ABNB', sector: 'tech'),
    UsCatalogEntry(ticker: 'NKE', sector: 'consumer'),
    UsCatalogEntry(ticker: 'MCD', sector: 'consumer'),
    UsCatalogEntry(ticker: 'SBUX', sector: 'consumer'),
    UsCatalogEntry(ticker: 'LIN', sector: 'industrial'),
    UsCatalogEntry(ticker: 'CAT', sector: 'industrial'),
    UsCatalogEntry(ticker: 'GE', sector: 'industrial'),
    UsCatalogEntry(ticker: 'BRK.B', sector: 'finance'),
    UsCatalogEntry(ticker: 'C', sector: 'finance'),
    UsCatalogEntry(ticker: 'AXP', sector: 'finance'),
    UsCatalogEntry(ticker: 'SCHW', sector: 'finance'),
    UsCatalogEntry(ticker: 'BLK', sector: 'finance'),
    UsCatalogEntry(ticker: 'NOW', sector: 'tech'),
    UsCatalogEntry(ticker: 'QCOM', sector: 'tech'),
    UsCatalogEntry(ticker: 'TXN', sector: 'tech'),
    UsCatalogEntry(ticker: 'AMAT', sector: 'tech'),
    UsCatalogEntry(ticker: 'MRVL', sector: 'tech'),
    UsCatalogEntry(ticker: 'PANW', sector: 'tech'),
    UsCatalogEntry(ticker: 'CRWD', sector: 'tech'),
    UsCatalogEntry(ticker: 'SNOW', sector: 'tech'),
    UsCatalogEntry(ticker: 'SHOP', sector: 'tech'),
    UsCatalogEntry(ticker: 'SQ', sector: 'finance'),
    UsCatalogEntry(ticker: 'F', sector: 'auto'),
    UsCatalogEntry(ticker: 'GM', sector: 'auto'),
    UsCatalogEntry(ticker: 'RIVN', sector: 'auto'),
    UsCatalogEntry(ticker: 'TGT', sector: 'consumer'),
    UsCatalogEntry(ticker: 'LOW', sector: 'consumer'),
    UsCatalogEntry(ticker: 'DE', sector: 'industrial'),
    UsCatalogEntry(ticker: 'HON', sector: 'industrial'),
    UsCatalogEntry(ticker: 'UPS', sector: 'industrial'),
    UsCatalogEntry(ticker: 'AMGN', sector: 'health'),
    UsCatalogEntry(ticker: 'GILD', sector: 'health'),
    UsCatalogEntry(ticker: 'BMY', sector: 'health'),
    UsCatalogEntry(ticker: 'VZ', sector: 'telecom'),
    UsCatalogEntry(ticker: 'T', sector: 'telecom'),
    UsCatalogEntry(ticker: 'TMUS', sector: 'telecom'),
    UsCatalogEntry(ticker: 'CMCSA', sector: 'media'),
    UsCatalogEntry(ticker: 'SLB', sector: 'energy'),
    UsCatalogEntry(ticker: 'EOG', sector: 'energy'),
    UsCatalogEntry(ticker: 'MU', sector: 'tech'),
    UsCatalogEntry(ticker: 'LRCX', sector: 'tech'),
    UsCatalogEntry(ticker: 'KLAC', sector: 'tech'),
    UsCatalogEntry(ticker: 'ARM', sector: 'tech'),
    UsCatalogEntry(ticker: 'SMCI', sector: 'tech'),
  ];

/// Getter [tickers] класса [UsCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  static List<String> get tickers => entries.map((e) => e.ticker).toList();

/// Метод [byTicker] класса [UsCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static UsCatalogEntry? byTicker(String ticker) {
    for (final e in entries) {
      if (e.ticker == ticker) return e;
    }
    return null;
  }
}

/// Класс [CryptoCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
abstract final class CryptoCatalog {
/// Поле [perPage] класса [CryptoCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static const perPage = 50;
/// Поле [pages] класса [CryptoCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static const pages = 3;

/// Getter [targetCount] класса [CryptoCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  static int get targetCount => perPage * pages;
}

/// Класс [BondCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
abstract final class BondCatalog {
/// Поле [entries] класса [BondCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static const entries = [
    BondCatalogEntry(secid: 'SU26238', category: BondCategory.ofz, labelRu: 'ОФЗ 26238'),
    BondCatalogEntry(secid: 'SU26243', category: BondCategory.ofz, labelRu: 'ОФЗ 26243'),
    BondCatalogEntry(secid: 'SU26248', category: BondCategory.ofz, labelRu: 'ОФЗ 26248'),
    BondCatalogEntry(secid: 'SU26252', category: BondCategory.ofz, labelRu: 'ОФЗ 26252'),
    BondCatalogEntry(secid: 'SU26253', category: BondCategory.ofz, labelRu: 'ОФЗ 26253'),
    BondCatalogEntry(secid: 'SU29009', category: BondCategory.ofz, labelRu: 'ОФЗ 29009'),
    BondCatalogEntry(secid: 'SU29014', category: BondCategory.ofz, labelRu: 'ОФЗ 29014'),
    BondCatalogEntry(secid: 'SU29015', category: BondCategory.ofz, labelRu: 'ОФЗ 29015'),
    BondCatalogEntry(secid: 'SU29016', category: BondCategory.ofz, labelRu: 'ОФЗ 29016'),
    BondCatalogEntry(secid: 'SU29017', category: BondCategory.ofz, labelRu: 'ОФЗ 29017'),
    BondCatalogEntry(secid: 'SU29018', category: BondCategory.ofz, labelRu: 'ОФЗ 29018'),
    BondCatalogEntry(secid: 'RU000A105WS8', category: BondCategory.corporate, labelRu: 'Газпром'),
    BondCatalogEntry(secid: 'RU000A108397', category: BondCategory.corporate, labelRu: 'Сбербанк'),
    BondCatalogEntry(secid: 'RU000A1098T8', category: BondCategory.corporate, labelRu: 'ВТБ'),
    BondCatalogEntry(secid: 'RU000A107TT7', category: BondCategory.corporate, labelRu: 'Русал'),
    BondCatalogEntry(secid: 'RU000A107061', category: BondCategory.corporate, labelRu: 'РЖД'),
    BondCatalogEntry(secid: 'RU000A1069V1', category: BondCategory.corporate, labelRu: 'Лукойл'),
    BondCatalogEntry(secid: 'RU000A106760', category: BondCategory.corporate, labelRu: 'Роснефть'),
  ];

/// Getter [secids] класса [BondCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static List<String> get secids => entries.map((e) => e.secid).toList();

/// Метод [bySecid] класса [BondCatalog].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static BondCatalogEntry? bySecid(String secid) {
    for (final e in entries) {
      if (e.secid == secid) return e;
    }
    return null;
  }
}

/// Класс [BondCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class BondCatalogEntry {
/// Создаёт [BondCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  const BondCatalogEntry({
    required this.secid,
    required this.category,
    required this.labelRu,
  });

/// Поле [secid] класса [BondCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final String secid;
/// Поле [category] класса [BondCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final BondCategory category;
/// Поле [labelRu] класса [BondCatalogEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String labelRu;
}

/// Класс [MarketCatalogStats].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
abstract final class MarketCatalogStats {
/// Getter [moexCount] класса [MarketCatalogStats].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  static int get moexCount => MoexCatalog.tickers.length;
/// Getter [usCount] класса [MarketCatalogStats].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  static int get usCount => UsCatalog.tickers.length;
/// Getter [bondCount] класса [MarketCatalogStats].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  static int get bondCount => BondCatalog.secids.length;
/// Getter [fxCount] класса [MarketCatalogStats].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  static int get fxCount =>
      CurrencyCatalog.fxCodes.length + CurrencyCatalog.moexRubPairs.length + 1;
/// Getter [cryptoCount] класса [MarketCatalogStats].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  static int get cryptoCount => CryptoCatalog.targetCount;
}
