// =============================================================================
// EcoPulse · test/quick_convert_test.dart
// Автор: Цымбал Е. В.
// Дата: 27.06.2026
// Unit/widget тест: quick_convert_test.
// =============================================================================

import 'package:ecopulse/providers/commodities_provider.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
void main() {
  group('parseQuickConvert', () {
    test('parses Russian format', () {
      final r = parseQuickConvert('100 USD в EUR');
      expect(r, isNotNull);
      expect(r!.amount, 100);
      expect(r.from, 'USD');
      expect(r.to, 'EUR');
    });

    test('parses English format', () {
      final r = parseQuickConvert('50 usd to rub');
      expect(r, isNotNull);
      expect(r!.amount, 50);
      expect(r.from, 'USD');
      expect(r.to, 'RUB');
    });

    test('parses arrow format', () {
      final r = parseQuickConvert('1000.5 EUR -> USD');
      expect(r, isNotNull);
      expect(r!.amount, 1000.5);
    });

    test('returns null for invalid input', () {
      expect(parseQuickConvert('hello'), isNull);
      expect(parseQuickConvert('100 dollars'), isNull);
    });
  });
}
