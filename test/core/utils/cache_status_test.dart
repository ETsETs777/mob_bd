// =============================================================================
// EcoPulse · test/cache_status_test.dart
// Автор: Цымбал Е. В.
// Дата: 23.06.2026
// Unit/widget тест: cache_status_test.
// =============================================================================

import 'package:ecopulse/core/utils/cache_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatDataAge formats minutes in Russian', () {
    expect(
      formatDataAge(const Duration(minutes: 15), languageCode: 'ru'),
      '15 мин назад',
    );
  });

  test('formatDataAge formats hours in English', () {
    expect(
      formatDataAge(const Duration(hours: 2), languageCode: 'en'),
      '2 h ago',
    );
  });

  test('formatDataAge formats minutes in German', () {
    expect(
      formatDataAge(const Duration(minutes: 15), languageCode: 'de'),
      'vor 15 Min.',
    );
  });

  test('formatDataAge formats minutes in Italian', () {
    expect(
      formatDataAge(const Duration(minutes: 15), languageCode: 'it'),
      '15 min fa',
    );
  });

  test('formatDataAge returns just now for recent data', () {
    expect(
      formatDataAge(const Duration(seconds: 20), languageCode: 'ru'),
      'только что',
    );
  });
}
