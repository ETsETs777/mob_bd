// =============================================================================
// EcoPulse · test/moex_candles_test.dart
// Автор: Цымбал Е. В.
// Дата: 26.06.2026
// Unit/widget тест: moex_candles_test.
// =============================================================================

import 'package:ecopulse/data/utils/moex_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 27.06.2026
void main() {
  test('MoexParser.candleOhlc parses MOEX candle block', () {
    final candles = MoexParser.candleOhlc({
      'columns': ['begin', 'open', 'high', 'low', 'close'],
      'data': [
        ['2024-01-02', 100.0, 105.0, 99.0, 103.0],
        ['2024-01-03', 103.0, 108.0, 102.0, 101.0],
      ],
    });

    expect(candles, hasLength(2));
    expect(candles.first.open, 100);
    expect(candles.first.close, 103);
    expect(candles.first.isBullish, isTrue);
    expect(candles.last.isBullish, isFalse);
  });
}
