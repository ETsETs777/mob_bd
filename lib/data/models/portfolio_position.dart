// =============================================================================
// EcoPulse · lib/data/models/portfolio_position.dart
// Автор: Цымбал Е. В.
// Дата: 04.05.2026
// Модели данных (DTO, immutable классы). Файл: portfolio_position.
// =============================================================================

import 'market_asset.dart';

/// Класс [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
class PortfolioPosition {
/// Создаёт [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  const PortfolioPosition({
    required this.assetKey,
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.buyPrice,
    required this.currency,
    required this.costRub,
    required this.boughtAt,
  });

/// Поле [assetKey] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String assetKey;
/// Поле [symbol] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final String symbol;
/// Поле [type] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final AssetType type;
/// Поле [quantity] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final double quantity;
/// Поле [buyPrice] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final double buyPrice;
/// Поле [currency] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String currency;
/// Поле [costRub] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final double costRub;
/// Поле [boughtAt] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final DateTime boughtAt;

/// Getter [costBasis] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  double get costBasis => quantity * buyPrice;

/// Метод [copyWith] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  PortfolioPosition copyWith({
    double? quantity,
    double? buyPrice,
    double? costRub,
  }) {
    return PortfolioPosition(
      assetKey: assetKey,
      symbol: symbol,
      type: type,
      quantity: quantity ?? this.quantity,
      buyPrice: buyPrice ?? this.buyPrice,
      currency: currency,
      costRub: costRub ?? this.costRub,
      boughtAt: boughtAt,
    );
  }

/// Метод [toJson] класса [PortfolioPosition].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  Map<String, dynamic> toJson() => {
        'assetKey': assetKey,
        'symbol': symbol,
        'type': type.name,
        'quantity': quantity,
        'buyPrice': buyPrice,
        'currency': currency,
        'costRub': costRub,
        'boughtAt': boughtAt.toIso8601String(),
      };

/// Создаёт [PortfolioPosition] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  factory PortfolioPosition.fromJson(Map<String, dynamic> json) =>
      PortfolioPosition(
        assetKey: json['assetKey'] as String,
        symbol: json['symbol'] as String,
        type: AssetType.values.byName(json['type'] as String),
        quantity: (json['quantity'] as num).toDouble(),
        buyPrice: (json['buyPrice'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        costRub: (json['costRub'] as num?)?.toDouble() ??
            (json['quantity'] as num).toDouble() *
                (json['buyPrice'] as num).toDouble(),
        boughtAt: DateTime.parse(json['boughtAt'] as String),
      );
}

/// Класс [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class PaperPortfolio {
/// Создаёт [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  const PaperPortfolio({
    this.initialCapitalRub = defaultCapital,
    this.cashRub = defaultCapital,
    this.positions = const [],
  });

/// Поле [defaultCapital] класса [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  static const defaultCapital = 100000.0;

/// Поле [initialCapitalRub] класса [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final double initialCapitalRub;
/// Поле [cashRub] класса [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final double cashRub;
/// Поле [positions] класса [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final List<PortfolioPosition> positions;

/// Метод [copyWith] класса [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  PaperPortfolio copyWith({
    double? initialCapitalRub,
    double? cashRub,
    List<PortfolioPosition>? positions,
  }) {
    return PaperPortfolio(
      initialCapitalRub: initialCapitalRub ?? this.initialCapitalRub,
      cashRub: cashRub ?? this.cashRub,
      positions: positions ?? this.positions,
    );
  }

/// Метод [toJson] класса [PaperPortfolio].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  Map<String, dynamic> toJson() => {
        'initialCapitalRub': initialCapitalRub,
        'cashRub': cashRub,
        'positions': positions.map((p) => p.toJson()).toList(),
      };

/// Создаёт [PaperPortfolio] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  factory PaperPortfolio.fromJson(Map<String, dynamic> json) => PaperPortfolio(
        initialCapitalRub:
            (json['initialCapitalRub'] as num?)?.toDouble() ?? defaultCapital,
        cashRub: (json['cashRub'] as num?)?.toDouble() ?? defaultCapital,
        positions: (json['positions'] as List<dynamic>? ?? [])
            .map((e) => PortfolioPosition.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// Класс [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
class PortfolioSnapshot {
/// Создаёт [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const PortfolioSnapshot({
    required this.portfolio,
    required this.totalValueRub,
    required this.investedRub,
    required this.pnlRub,
    required this.pnlPercent,
    required this.positions,
  });

/// Поле [portfolio] класса [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final PaperPortfolio portfolio;
/// Поле [totalValueRub] класса [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final double totalValueRub;
/// Поле [investedRub] класса [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final double investedRub;
/// Поле [pnlRub] класса [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final double pnlRub;
/// Поле [pnlPercent] класса [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double pnlPercent;
/// Поле [positions] класса [PortfolioSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final List<PositionSnapshot> positions;
}

/// Класс [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class PositionSnapshot {
/// Создаёт [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  const PositionSnapshot({
    required this.position,
    required this.currentPrice,
    required this.valueRub,
    required this.costRub,
    required this.pnlRub,
    required this.pnlPercent,
    this.liveAsset,
  });

/// Поле [position] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final PortfolioPosition position;
/// Поле [currentPrice] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double currentPrice;
/// Поле [valueRub] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final double valueRub;
/// Поле [costRub] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final double costRub;
/// Поле [pnlRub] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final double pnlRub;
/// Поле [pnlPercent] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final double pnlPercent;
/// Поле [liveAsset] класса [PositionSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final MarketAsset? liveAsset;
}
