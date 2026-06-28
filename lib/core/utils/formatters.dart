// =============================================================================
// EcoPulse · lib/core/utils/formatters.dart
// Автор: Цымбал Е. В.
// Дата: 05.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: formatters.
// =============================================================================

import 'package:intl/intl.dart';

/// Класс [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class Formatters {
/// Поле [_currency] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  static final _currency = NumberFormat('#,##0.00', 'en_US');
/// Поле [_percent] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  static final _percent = NumberFormat('#,##0.##');
/// Поле [_compact] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  static final _compact = NumberFormat.compact(locale: 'en_US');

/// Метод [price] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  static String price(double value, {String symbol = '\$'}) {
    if (value >= 1000) {
      return '$symbol${_currency.format(value)}';
    }
    return '$symbol${value.toStringAsFixed(value < 1 ? 4 : 2)}';
  }

/// Метод [rub] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  static String rub(double value) => '${_currency.format(value)} ₽';

/// Метод [percent] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  static String percent(double? value) {
    if (value == null) return '—';
    final sign = value >= 0 ? '+' : '';
    return '$sign${_percent.format(value)}%';
  }

  /// Цена облигации в % от номинала.
  static String bondPrice(double price) => '${_percent.format(price)}%';

/// Метод [bondYield] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  static String bondYield(double? yield) =>
      yield == null ? '—' : '${_percent.format(yield)}% YTM';

/// Метод [compact] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  static String compact(double value) => _compact.format(value);

/// Метод [date] класса [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  static String date(DateTime date) => DateFormat('dd MMM yyyy').format(date);
}
