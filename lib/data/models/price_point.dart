// =============================================================================
// EcoPulse · lib/data/models/price_point.dart
// Автор: Цымбал Е. В.
// Дата: 05.05.2026
// Модели данных (DTO, immutable классы). Файл: price_point.
// =============================================================================

/// Класс [PricePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class PricePoint {
/// Создаёт [PricePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  const PricePoint({required this.date, required this.value});

/// Поле [date] класса [PricePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final DateTime date;
/// Поле [value] класса [PricePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  final double value;
}
