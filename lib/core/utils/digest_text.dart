// =============================================================================
// EcoPulse · lib/core/utils/digest_text.dart
// Автор: Цымбал Е. В.
// Дата: 08.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: digest_text.
// =============================================================================

import '../../features/home/economic_brief.dart';

/// Форматирует brief-строки в текст для push-уведомления (до ~200 символов).
String formatDigestBody(List<BriefLine> lines, {int maxLines = 4}) {
  if (lines.isEmpty) return 'Откройте EcoPulse — сводка рынков';

  final parts = lines.take(maxLines).map((line) {
    final arrow = switch (line.isPositive) {
      true => '↑',
      false => '↓',
      null => '',
    };
    return '${line.label} $arrow ${line.text.split(' · ').lastOrNull ?? line.text}';
  });

  return parts.join(' · ');
}

/// Extension [_LastOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
extension _LastOrNull on List<String> {
  String? get lastOrNull => isEmpty ? null : last;
}
