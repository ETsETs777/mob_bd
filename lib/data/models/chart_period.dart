// =============================================================================
// EcoPulse · lib/data/models/chart_period.dart
// Автор: Цымбал Е. В.
// Дата: 01.05.2026
// Модели данных (DTO, immutable классы). Файл: chart_period.
// =============================================================================

/// Класс [AssetDetailRequest].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
class AssetDetailRequest {
/// Создаёт [AssetDetailRequest].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  const AssetDetailRequest({required this.assetKey, required this.days});

/// Поле [assetKey] класса [AssetDetailRequest].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String assetKey;
/// Поле [days] класса [AssetDetailRequest].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final int days;

/// Метод [==] класса [AssetDetailRequest].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  @override
  bool operator ==(Object other) =>
      other is AssetDetailRequest &&
      other.assetKey == assetKey &&
      other.days == days;

  @override
  int get hashCode => Object.hash(assetKey, days);
}

/// Enum [ChartPeriod] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
enum ChartPeriod {
/// Значение enum [d7].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  d7(7, '7Д'),
/// Значение enum [d30].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  d30(30, '30Д'),
/// Значение enum [y1].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  y1(365, '1Г');

  const ChartPeriod(this.days, this.label);
  final int days;
  final String label;
}
