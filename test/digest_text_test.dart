// =============================================================================
// EcoPulse · test/digest_text_test.dart
// Автор: Цымбал Е. В.
// Дата: 24.06.2026
// Unit/widget тест: digest_text_test.
// =============================================================================

import 'package:ecopulse/core/utils/digest_text.dart';
import 'package:ecopulse/features/home/economic_brief.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
void main() {
  test('formatDigestBody joins brief lines', () {
    final body = formatDigestBody([
      const BriefLine(
        label: 'USD/RUB',
        text: '89.50 ₽ · +0.3%',
        isPositive: true,
      ),
      const BriefLine(
        label: 'Bitcoin',
        text: '67 000 \$ · -1.2%',
        isPositive: false,
      ),
    ]);

    expect(body, contains('USD/RUB'));
    expect(body, contains('Bitcoin'));
    expect(body, contains('↑'));
    expect(body, contains('↓'));
  });

  test('formatDigestBody handles empty lines', () {
    expect(formatDigestBody([]), contains('EcoPulse'));
  });
}
