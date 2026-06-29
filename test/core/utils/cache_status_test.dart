// =============================================================================
// EcoPulse · test/cache_status_test.dart
// Автор: Цымбал Е. В.
// Дата: 23.06.2026
// Unit/widget тест: cache_status_test.
// =============================================================================

import 'package:ecopulse/core/utils/cache_status.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
void main() {
  test('formatDataAge formats minutes in Russian', () {
    expect(
      formatDataAge(const Duration(minutes: 15), ru: true),
      '15 мин назад',
    );
  });

  test('formatDataAge formats hours in English', () {
    expect(
      formatDataAge(const Duration(hours: 2), ru: false),
      '2 h ago',
    );
  });

  test('formatDataAge returns just now for recent data', () {
    expect(
      formatDataAge(const Duration(seconds: 20), ru: true),
      'только что',
    );
  });
}
