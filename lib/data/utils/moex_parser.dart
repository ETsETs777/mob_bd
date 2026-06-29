// =============================================================================
// EcoPulse · lib/data/utils/moex_parser.dart
// Автор: Цымбал Е. В.
// Дата: 12.05.2026
// Модуль EcoPulse. Файл: moex_parser.
// =============================================================================

import '../models/candle_point.dart';

/// Парсинг табличных ответов MOEX ISS.
class MoexParser {
/// Создаёт [MoexParser] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  const MoexParser._();

/// Метод [columns] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static List<String> columns(Map<String, dynamic>? block) {
    return (block?['columns'] as List<dynamic>?)?.cast<String>() ?? [];
  }

/// Метод [firstRow] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static List<dynamic>? firstRow(Map<String, dynamic>? block) {
    final rows = block?['data'] as List<dynamic>?;
    if (rows == null || rows.isEmpty) return null;
    return rows.first as List<dynamic>;
  }

/// Метод [nullableDoubleAt] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static double? nullableDoubleAt(Map<String, dynamic>? block, String column) {
    final cols = columns(block);
    final row = firstRow(block);
    final idx = cols.indexOf(column);
    if (row == null || idx < 0 || row[idx] == null) return null;
    return (row[idx] as num).toDouble();
  }

/// Метод [doubleAt] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  static double? doubleAt(
    Map<String, dynamic>? block,
    String column, {
    double? defaultValue,
  }) {
    final value = nullableDoubleAt(block, column);
    if (value != null) return value;
    return defaultValue;
  }

/// Метод [stringAt] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  static String? stringAt(Map<String, dynamic>? block, String column) {
    final cols = columns(block);
    final row = firstRow(block);
    final idx = cols.indexOf(column);
    if (row == null || idx < 0) return null;
    return row[idx] as String?;
  }

/// Метод [candleOhlc] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static List<CandlePoint> candleOhlc(Map<String, dynamic>? candlesBlock) {
    final cols = columns(candlesBlock);
    final rows = candlesBlock?['data'] as List<dynamic>? ?? [];
    final beginIdx = cols.indexOf('begin');
    final openIdx = cols.indexOf('open');
    final highIdx = cols.indexOf('high');
    final lowIdx = cols.indexOf('low');
    final closeIdx = cols.indexOf('close');
    final volumeIdx = cols.indexOf('volume');
    if (beginIdx < 0 ||
        openIdx < 0 ||
        highIdx < 0 ||
        lowIdx < 0 ||
        closeIdx < 0) {
      return [];
    }

    return rows.map((row) {
      final r = row as List<dynamic>;
      final volume = volumeIdx >= 0 && r[volumeIdx] != null
          ? (r[volumeIdx] as num).toDouble()
          : 0.0;
      return CandlePoint(
        date: DateTime.parse(r[beginIdx] as String),
        open: (r[openIdx] as num).toDouble(),
        high: (r[highIdx] as num).toDouble(),
        low: (r[lowIdx] as num).toDouble(),
        close: (r[closeIdx] as num).toDouble(),
        volume: volume,
      );
    }).toList();
  }

/// Метод [candleRows] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static List<PriceRow> candleRows(Map<String, dynamic>? candlesBlock) {
    final cols = columns(candlesBlock);
    final rows = candlesBlock?['data'] as List<dynamic>? ?? [];
    final beginIdx = cols.indexOf('begin');
    final closeIdx = cols.indexOf('close');
    if (beginIdx < 0 || closeIdx < 0) return [];

    return rows.map((row) {
      final r = row as List<dynamic>;
      return PriceRow(
        date: DateTime.parse(r[beginIdx] as String),
        value: (r[closeIdx] as num).toDouble(),
      );
    }).toList();
  }

/// Метод [candleCloses] класса [MoexParser].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  static List<double> candleCloses(Map<String, dynamic>? candlesBlock) {
    final cols = columns(candlesBlock);
    final rows = candlesBlock?['data'] as List<dynamic>? ?? [];
    final closeIdx = cols.indexOf('close');
    if (closeIdx < 0) return [];

    return rows
        .map((row) => ((row as List<dynamic>)[closeIdx] as num).toDouble())
        .toList();
  }
}

/// Класс [PriceRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
class PriceRow {
/// Создаёт [PriceRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  const PriceRow({required this.date, required this.value});

/// Поле [date] класса [PriceRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  final DateTime date;
/// Поле [value] класса [PriceRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  final double value;
}
