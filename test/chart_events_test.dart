// =============================================================================
// EcoPulse · test/chart_events_test.dart
// Автор: Цымбал Е. В.
// Дата: 23.06.2026
// Unit/widget тест: chart_events_test.
// =============================================================================

import 'package:ecopulse/core/utils/chart_events.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
void main() {
  test('keyRateChangeEvents detects rate changes', () {
    final events = keyRateChangeEvents(
      dates: [
        DateTime(2024, 1, 1),
        DateTime(2024, 2, 1),
        DateTime(2024, 3, 1),
      ],
      rates: [16, 16, 18],
    );

    expect(events.length, 1);
    expect(events.first.index, 2);
    expect(events.first.label, '18.00%');
  });
}
