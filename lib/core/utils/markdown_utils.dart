/// Утилиты для Markdown в статьях.
class MarkdownUtils {
  MarkdownUtils._();

  /// Короткий plain-text excerpt для карточки в ленте.
  static String previewExcerpt(String markdown, {int maxLength = 120}) {
    var text = markdown
        .replaceAll(RegExp(r'```[\s\S]*?```'), ' ')
        .replaceAllMapped(RegExp(r'`([^`]+)`'), (m) => m.group(1)!)
        .replaceAll(RegExp(r'!\[[^\]]*\]\([^)]+\)'), ' ')
        .replaceAllMapped(
          RegExp(r'\[([^\]]+)\]\([^)]+\)'),
          (m) => m.group(1)!,
        )
        .replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^[-*+]\s+', multiLine: true), '')
        .replaceAllMapped(RegExp(r'\*\*([^*]+)\*\*'), (m) => m.group(1)!)
        .replaceAllMapped(RegExp(r'\*([^*]+)\*'), (m) => m.group(1)!)
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 1).trim()}…';
  }

  /// Примерное время чтения (200 слов/мин).
  static int readingTimeMinutes(String markdown) {
    final plain = previewExcerpt(markdown, maxLength: 100000);
    final words =
        plain.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    if (words <= 0) return 1;
    return (words / 200).ceil().clamp(1, 999);
  }
}
