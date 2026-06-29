// =============================================================================
// EcoPulse · lib/data/models/candle_point.dart
// Автор: Цымбал Е. В.
// Дата: 30.04.2026
// Модели данных (DTO, immutable классы). Файл: candle_point.
// =============================================================================

/// Класс [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
class CandlePoint {
/// Создаёт [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  const CandlePoint({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume = 0,
  });

/// Поле [date] класса [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final DateTime date;
/// Поле [open] класса [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double open;
/// Поле [high] класса [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  final double high;
/// Поле [low] класса [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final double low;
/// Поле [close] класса [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final double close;
  final double volume;

/// Getter [isBullish] класса [CandlePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  bool get isBullish => close >= open;
}

/// Значение enum [candlestick].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
/// Значение enum [line].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
/// Enum [ChartDisplayMode] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
/// Значение enum [candlestick].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
/// Значение enum [line].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
enum ChartDisplayMode { line, candlestick }
