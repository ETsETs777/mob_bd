// =============================================================================
// EcoPulse · test/widget_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit/widget тест: widget_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/formatters.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
void main() {
  test('Formatters.percent adds sign', () {
    expect(Formatters.percent(5.5), '+5.5%');
    expect(Formatters.percent(-2.3), '-2.3%');
  });

  test('Formatters.rub formats currency', () {
    expect(Formatters.rub(79.26), contains('₽'));
  });
}
