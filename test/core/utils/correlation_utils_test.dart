// =============================================================================
// EcoPulse · test/correlation_utils_test.dart
// Автор: Цымбал Е. В.
// Дата: 24.06.2026
// Unit/widget тест: correlation_utils_test.
// =============================================================================

import 'package:ecopulse/core/utils/correlation_utils.dart';
import 'package:ecopulse/data/models/price_point.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
void main() {
  test('pearsonCorrelation detects positive link', () {
    final a = [0.01, 0.02, -0.01, 0.03, 0.01];
    final b = [0.012, 0.018, -0.008, 0.028, 0.011];
    expect(pearsonCorrelation(a, b), closeTo(0.99, 0.05));
  });

  test('pearsonCorrelation detects negative link', () {
    final a = [0.01, 0.02, 0.03, 0.04, 0.05];
    final b = [-0.01, -0.02, -0.03, -0.04, -0.05];
    expect(pearsonCorrelation(a, b), closeTo(-1, 0.01));
  });

  test('buildCorrelationSnapshot builds matrix', () {
    final history = List.generate(
      10,
      (i) => PricePoint(date: DateTime(2024, 1, i + 1), value: 100 + i.toDouble()),
    );
    final inverse = List.generate(
      10,
      (i) => PricePoint(date: DateTime(2024, 1, i + 1), value: 200 - i.toDouble()),
    );

    final snapshot = buildCorrelationSnapshot(
      days: 30,
      assets: [
        CorrelationAsset(id: 'a', label: 'A', history: history),
        CorrelationAsset(id: 'b', label: 'B', history: history),
        CorrelationAsset(id: 'c', label: 'C', history: inverse),
      ],
    );

    expect(snapshot!.pair('a', 'b'), closeTo(1, 0.01));
    expect(snapshot.pair('a', 'a'), 1);
  });

  test('changeFromSparkline computes percent change', () {
    expect(changeFromSparkline([100, 110]), closeTo(10, 0.01));
    expect(changeFromSparkline([100]), isNull);
  });
}
