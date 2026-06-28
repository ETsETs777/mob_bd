// =============================================================================
// EcoPulse · lib/data/models/inflation_point.dart
// Автор: Цымбал Е. В.
// Дата: 03.05.2026
// Модели данных (DTO, immutable классы). Файл: inflation_point.
// =============================================================================

/// Класс [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class InflationPoint {
/// Создаёт [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  const InflationPoint({
    required this.countryCode,
    required this.countryName,
    required this.year,
    required this.value,
    this.history = const [],
  });

/// Поле [countryCode] класса [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String countryCode;
/// Поле [countryName] класса [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String countryName;
/// Поле [year] класса [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final int year;
/// Поле [value] класса [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double value;
/// Поле [history] класса [InflationPoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final List<YearValue> history;
}

/// Класс [YearValue].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class YearValue {
/// Создаёт [YearValue].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  const YearValue({required this.year, required this.value});

/// Поле [year] класса [YearValue].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final int year;
/// Поле [value] класса [YearValue].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double value;
}
