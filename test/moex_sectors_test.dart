// =============================================================================
// EcoPulse · test/moex_sectors_test.dart
// Автор: Цымбал Е. В.
// Дата: 26.06.2026
// Unit/widget тест: moex_sectors_test.
// =============================================================================

import 'package:ecopulse/core/constants/moex_sectors.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 27.06.2026
void main() {
  test('averageChangeBySector groups tickers', () {
    final result = averageChangeBySector([
      (sector: 'finance', change: 2.0),
      (sector: 'finance', change: 4.0),
      (sector: 'energy', change: -1.0),
    ]);

    expect(result['finance'], 3.0);
    expect(result['energy'], -1.0);
  });

  test('moexSectorKey maps known tickers', () {
    expect(moexSectorKey('SBER'), 'finance');
    expect(moexSectorKey('GAZP'), 'energy');
    expect(moexSectorKey('UNKNOWN'), isNull);
  });
}
