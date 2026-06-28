// =============================================================================
// EcoPulse · lib/data/models/key_rate_point.dart
// Автор: Цымбал Е. В.
// Дата: 03.05.2026
// Модели данных (DTO, immutable классы). Файл: key_rate_point.
// =============================================================================

/// Класс [KeyRatePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class KeyRatePoint {
/// Создаёт [KeyRatePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  const KeyRatePoint({required this.date, required this.rate});

/// Поле [date] класса [KeyRatePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final DateTime date;
/// Поле [rate] класса [KeyRatePoint].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final double rate;
}

/// Класс [KeyRateSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class KeyRateSnapshot {
/// Создаёт [KeyRateSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const KeyRateSnapshot({
    required this.current,
    required this.history,
    required this.updatedAt,
  });

/// Поле [current] класса [KeyRateSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final double current;
/// Поле [history] класса [KeyRateSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final List<KeyRatePoint> history;
/// Поле [updatedAt] класса [KeyRateSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final DateTime updatedAt;

/// Getter [changePercent] класса [KeyRateSnapshot].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  double? get changePercent {
    if (history.length < 2) return null;
    final first = history.first.rate;
    final last = history.last.rate;
    if (first == 0) return null;
    return ((last - first) / first) * 100;
  }
}
