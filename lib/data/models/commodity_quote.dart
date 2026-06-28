// =============================================================================
// EcoPulse · lib/data/models/commodity_quote.dart
// Автор: Цымбал Е. В.
// Дата: 01.05.2026
// Модели данных (DTO, immutable классы). Файл: commodity_quote.
// =============================================================================

/// Класс [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
class CommodityQuote {
/// Создаёт [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  const CommodityQuote({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    this.changePercent,
    this.sparkline = const [],
    this.source = 'MOEX',
  });

/// Поле [id] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String id;
/// Поле [name] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String name;
/// Поле [price] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final double price;
/// Поле [unit] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final String unit;
/// Поле [changePercent] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final double? changePercent;
/// Поле [sparkline] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final List<double> sparkline;
/// Поле [source] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String source;

/// Getter [symbol] класса [CommodityQuote].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  String get symbol => id.toUpperCase();
}

/// Класс [FearGreedIndex].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
class FearGreedIndex {
/// Создаёт [FearGreedIndex].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  const FearGreedIndex({
    required this.value,
    required this.label,
    required this.updatedAt,
  });

/// Поле [value] класса [FearGreedIndex].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final int value;
/// Поле [label] класса [FearGreedIndex].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String label;
/// Поле [updatedAt] класса [FearGreedIndex].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final DateTime updatedAt;
}
