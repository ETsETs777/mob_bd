// =============================================================================
// EcoPulse · lib/data/models/market_asset.dart
// Автор: Цымбал Е. В.
// Дата: 03.05.2026
// Модели данных (DTO, immutable классы). Файл: market_asset.
// =============================================================================

import 'price_point.dart';
import 'candle_point.dart';

/// Значение enum [bondRu].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Значение enum [stockUs].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
/// Значение enum [stockRu].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
/// Значение enum [crypto].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
/// Enum [AssetType] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
/// Значение enum [bondRu].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Значение enum [stockUs].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
/// Значение enum [stockRu].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
/// Значение enum [crypto].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
enum AssetType { crypto, stockRu, stockUs, bondRu }

/// Значение enum [corporate].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
/// Значение enum [ofz].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Enum [BondCategory] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
/// Значение enum [corporate].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
/// Значение enum [ofz].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
enum BondCategory { ofz, corporate }

/// Класс [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class MarketAsset {
/// Создаёт [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const MarketAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.type,
    this.sparkline = const [],
    this.currency = 'USD',
    this.imageUrl,
    this.yieldPercent,
    this.couponPercent,
    this.maturityDate,
    this.bondCategory,
    this.faceValue,
    this.nextCouponDate,
    this.couponValueRub,
    this.couponPeriodDays,
  });

/// Поле [id] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String id;
/// Поле [symbol] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String symbol;
/// Поле [name] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String name;
/// Поле [price] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final double price;
/// Поле [changePercent] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double changePercent;
/// Поле [type] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final AssetType type;
/// Поле [sparkline] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final List<double> sparkline;
/// Поле [currency] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String currency;
/// Поле [imageUrl] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final String? imageUrl;
  /// Доходность к погашению, % (облигации).
  final double? yieldPercent;
  /// Купон, % годовых (облигации).
  final double? couponPercent;
/// Поле [maturityDate] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final DateTime? maturityDate;
/// Поле [bondCategory] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final BondCategory? bondCategory;
  /// Номинал, ₽ (облигации; по умолчанию 1000).
  final double? faceValue;
  /// Ближайшая дата купона (MOEX NEXTCOUPON).
  final DateTime? nextCouponDate;
  /// Размер купона на 1 облигацию, ₽ (MOEX COUPONVALUE).
  final double? couponValueRub;
  /// Период купона, дней (MOEX COUPONPERIOD).
  final int? couponPeriodDays;

/// Getter [isPositive] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  bool get isPositive => changePercent >= 0;
/// Getter [isBond] класса [MarketAsset].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  bool get isBond => type == AssetType.bondRu;
}

/// Класс [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class AssetDetail {
/// Создаёт [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const AssetDetail({
    required this.asset,
    required this.history,
    this.candles = const [],
    this.marketCap,
    this.volume,
    this.high24h,
    this.low24h,
  });

/// Поле [asset] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final MarketAsset asset;
/// Поле [history] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final List<PricePoint> history;
/// Поле [candles] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final List<CandlePoint> candles;
/// Поле [marketCap] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final double? marketCap;
/// Поле [volume] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double? volume;
/// Поле [high24h] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final double? high24h;
/// Поле [low24h] класса [AssetDetail].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final double? low24h;
}
