// =============================================================================
// EcoPulse · lib/data/models/currency_rate.dart
// Автор: Цымбал Е. В.
// Дата: 02.05.2026
// Модели данных (DTO, immutable классы). Файл: currency_rate.
// =============================================================================

import 'price_point.dart';

/// Класс [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class CurrencyRate {
/// Создаёт [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const CurrencyRate({
    required this.code,
    required this.rate,
    required this.base,
    this.date,
    this.changePercent,
    this.history = const [],
    this.isRub = false,
  });

/// Поле [code] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String code;
/// Поле [rate] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final double rate;
/// Поле [base] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final String base;
/// Поле [date] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final DateTime? date;
/// Поле [changePercent] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final double? changePercent;
/// Поле [history] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final List<PricePoint> history;
/// Поле [isRub] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final bool isRub;

/// Getter [pairLabel] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  String get pairLabel {
    if (isRub) return 'USD/RUB';
    if (base == 'RUB' && code == 'EUR') return 'EUR/RUB';
    return '$base/$code';
  }

/// Метод [copyWith] класса [CurrencyRate].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  CurrencyRate copyWith({
    double? rate,
    double? changePercent,
    List<PricePoint>? history,
    DateTime? date,
  }) {
    return CurrencyRate(
      code: code,
      rate: rate ?? this.rate,
      base: base,
      date: date ?? this.date,
      changePercent: changePercent ?? this.changePercent,
      history: history ?? this.history,
      isRub: isRub,
    );
  }
}
