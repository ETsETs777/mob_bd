// =============================================================================
// EcoPulse · test/core/utils/candle_history_utils_test.dart
// =============================================================================

import 'package:ecopulse/core/utils/candle_history_utils.dart';
import 'package:ecopulse/data/models/candle_point.dart';
import 'package:ecopulse/data/models/price_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mergeCandleHistory dedupes by day and sorts ascending', () {
    final existing = [
      CandlePoint(
        date: DateTime(2026, 6, 2),
        open: 10,
        high: 11,
        low: 9,
        close: 10.5,
      ),
      CandlePoint(
        date: DateTime(2026, 6, 3),
        open: 10.5,
        high: 12,
        low: 10,
        close: 11,
      ),
    ];
    final older = [
      CandlePoint(
        date: DateTime(2026, 6, 1),
        open: 9,
        high: 10,
        low: 8,
        close: 9.5,
      ),
      CandlePoint(
        date: DateTime(2026, 6, 2),
        open: 99,
        high: 99,
        low: 99,
        close: 99,
      ),
    ];

    final merged = mergeCandleHistory(existing, older);
    expect(merged, hasLength(3));
    expect(merged.first.date.day, 1);
    expect(merged.last.date.day, 3);
    expect(merged[1].close, 10.5);
  });

  test('mergePriceHistory merges older points', () {
    final existing = [
      PricePoint(date: DateTime(2026, 6, 2), value: 100),
    ];
    final older = [
      PricePoint(date: DateTime(2026, 6, 1), value: 95),
    ];
    final merged = mergePriceHistory(existing, older);
    expect(merged, hasLength(2));
    expect(merged.first.value, 95);
  });
}
