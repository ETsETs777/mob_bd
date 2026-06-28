// =============================================================================
// EcoPulse · lib/core/utils/market_list_utils.dart
// Автор: Цымбал Е. В.
// Дата: 09.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: market_list_utils.
// =============================================================================

import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../constants/market_catalog.dart';
import '../constants/moex_sectors.dart';

/// Значение enum [us].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
/// Значение enum [moex].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
/// Значение enum [all].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
/// Enum [StockMarketRegion] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
/// Значение enum [us].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
/// Значение enum [moex].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
/// Значение enum [all].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
enum StockMarketRegion { all, moex, us }

/// Функция [filterByStockRegion] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
List<MarketAsset> filterByStockRegion(
  List<MarketAsset> assets,
  StockMarketRegion region,
) {
  return switch (region) {
    StockMarketRegion.all => assets,
    StockMarketRegion.moex =>
      assets.where((a) => a.type == AssetType.stockRu).toList(),
    StockMarketRegion.us =>
      assets.where((a) => a.type == AssetType.stockUs).toList(),
  };
}

/// Класс [MarketListRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
class MarketListRow {
/// Создаёт [MarketListRow] (header).
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  const MarketListRow.header(this.title) : asset = null;
/// Создаёт [MarketListRow] (item).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  const MarketListRow.item(this.asset) : title = null;

/// Поле [title] класса [MarketListRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final String? title;
/// Поле [asset] класса [MarketListRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  final MarketAsset? asset;

/// Getter [isHeader] класса [MarketListRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  bool get isHeader => title != null;
}

/// Top-level переменная [_sectorOrder].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
const _sectorOrder = [
  'index',
  'finance',
  'energy',
  'metals',
  'it',
  'telecom',
  'consumer',
  'transport',
  'realestate',
  'chemicals',
  'etf',
  'tech',
  'auto',
  'health',
  'media',
  'industrial',
  'us',
  'other',
];

/// Группировка акций по секторам (удобно при пустом поиске).
List<MarketListRow> buildGroupedStockRows(
  List<MarketAsset> assets, {
  required String Function(String sectorKey) sectorLabel,
}) {
  if (assets.isEmpty) return [];

  final buckets = <String, List<MarketAsset>>{};
  for (final asset in assets) {
    final key = asset.type == AssetType.stockRu
        ? (moexSectorKey(asset.symbol) ??
            MoexCatalog.byTicker(asset.symbol)?.sector ??
            'other')
        : (UsCatalog.entries
                .where((e) => e.ticker == asset.symbol)
                .map((e) => e.sector)
                .firstOrNull ??
            'us');
    buckets.putIfAbsent(key, () => []).add(asset);
  }

  final rows = <MarketListRow>[];
  for (final sector in _sectorOrder) {
    final list = buckets.remove(sector);
    if (list == null || list.isEmpty) continue;
    rows.add(MarketListRow.header(sectorLabel(sector)));
    for (final asset in list) {
      rows.add(MarketListRow.item(asset));
    }
  }
  for (final entry in buckets.entries) {
    rows.add(MarketListRow.header(sectorLabel(entry.key)));
    for (final asset in entry.value) {
      rows.add(MarketListRow.item(asset));
    }
  }
  return rows;
}

/// Top-level переменная [_currencyGroupOrder].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
const _currencyGroupOrder = [
  CurrencyGroup.moex,
  CurrencyGroup.major,
  CurrencyGroup.europe,
  CurrencyGroup.asia,
  CurrencyGroup.em,
  CurrencyGroup.americas,
];

/// Функция [currencyGroupForRate] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
CurrencyGroup currencyGroupForRate(CurrencyRate rate) {
  if (rate.isRub || rate.base == 'RUB') return CurrencyGroup.moex;
  return CurrencyCatalog.byCode(rate.code)?.group ?? CurrencyGroup.major;
}

/// Группировка валют для экрана «Валюты».
List<({CurrencyGroup group, List<CurrencyRate> rates})> groupCurrencyRates(
  List<CurrencyRate> rates,
) {
  final buckets = <CurrencyGroup, List<CurrencyRate>>{};
  for (final rate in rates) {
    final group = currencyGroupForRate(rate);
    buckets.putIfAbsent(group, () => []).add(rate);
  }
  return [
    for (final group in _currencyGroupOrder)
      if (buckets[group]?.isNotEmpty ?? false)
        (group: group, rates: buckets.remove(group)!),
    for (final entry in buckets.entries) (group: entry.key, rates: entry.value),
  ];
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

/// Значение enum [corporate].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
/// Значение enum [ofz].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
/// Значение enum [all].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
/// Enum [BondMarketFilter] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
/// Значение enum [corporate].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
/// Значение enum [ofz].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
/// Значение enum [all].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
enum BondMarketFilter { all, ofz, corporate }

/// Функция [filterByBondCategory] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
List<MarketAsset> filterByBondCategory(
  List<MarketAsset> assets,
  BondMarketFilter filter,
) {
  return switch (filter) {
    BondMarketFilter.all => assets,
    BondMarketFilter.ofz =>
      assets.where((a) => a.bondCategory == BondCategory.ofz).toList(),
    BondMarketFilter.corporate =>
      assets.where((a) => a.bondCategory == BondCategory.corporate).toList(),
  };
}

/// Функция [buildGroupedBondRows] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
List<MarketListRow> buildGroupedBondRows(
  List<MarketAsset> assets, {
  required String ofzLabel,
  required String corporateLabel,
}) {
  if (assets.isEmpty) return [];

  final ofz = assets.where((a) => a.bondCategory == BondCategory.ofz).toList();
  final corp =
      assets.where((a) => a.bondCategory == BondCategory.corporate).toList();

  final rows = <MarketListRow>[];
  if (ofz.isNotEmpty) {
    rows.add(MarketListRow.header(ofzLabel));
    for (final a in ofz) {
      rows.add(MarketListRow.item(a));
    }
  }
  if (corp.isNotEmpty) {
    rows.add(MarketListRow.header(corporateLabel));
    for (final a in corp) {
      rows.add(MarketListRow.item(a));
    }
  }
  return rows;
}

/// Функция [bondSubtitle] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
String bondSubtitle(MarketAsset asset, {bool english = false}) {
  final parts = <String>[];
  if (asset.yieldPercent != null) {
    parts.add('YTM ${asset.yieldPercent!.toStringAsFixed(2)}%');
  }
  if (asset.couponPercent != null) {
    parts.add(
      english
          ? 'coupon ${asset.couponPercent!.toStringAsFixed(1)}%'
          : 'купон ${asset.couponPercent!.toStringAsFixed(1)}%',
    );
  }
  if (asset.maturityDate != null) {
    final d = asset.maturityDate!;
    parts.add(
      english
          ? 'maturity ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
          : 'до ${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}',
    );
  }
  return parts.join(' · ');
}
