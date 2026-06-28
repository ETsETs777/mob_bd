// =============================================================================
// EcoPulse · lib/core/utils/formatters.dart
// Автор: Цымбал Е. В.
// Дата: 05.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: formatters.
// =============================================================================

import '../customization/display_formatters.dart';

/// Класс [Formatters].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class Formatters {
  static DisplayFormatters _engine = DisplayFormatters.defaults();

  /// Тестовый доступ к текущему движку форматирования.
  static DisplayFormatters get engine => _engine;

  /// Подключить [DisplayFormatters] из кастомизации.
  static void bind(DisplayFormatters engine) => _engine = engine;

  static String price(double value, {String symbol = '\$'}) =>
      _engine.price(value, symbol: symbol);

  static String rub(double value) => _engine.rub(value);

  static String percent(double? value) => _engine.percent(value);

  static String bondPrice(double price) => _engine.bondPrice(price);

  static String bondYield(double? yield) => _engine.bondYield(yield);

  static String compact(double value) => _engine.compact(value);

  static String date(DateTime date) => _engine.date(date);

  static String formatDateTime(DateTime value, {bool includeDate = true}) =>
      _engine.formatDateTime(value, includeDate: includeDate);

  static String formatJournalPreview(DateTime value) =>
      _engine.formatJournalPreview(value);

  static String formatJournalFull(DateTime value) =>
      _engine.formatJournalFull(value);
}
