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
        .replaceAllMapped(RegExp(r'~~([^~]+)~~'), (m) => m.group(1)!)
        .replaceAll(RegExp(r'^\|.+\|$', multiLine: true), ' ')
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

  /// ID видео YouTube из URL или голого ID.
  static String? extractYoutubeVideoId(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final bare = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    if (bare.hasMatch(trimmed)) return trimmed;

    final patterns = [
      RegExp(r'youtube\.com/watch\?[^#\s]*v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(trimmed);
      if (m != null) return m.group(1);
    }
    return null;
  }

  static String youtubeWatchUrl(String videoId) =>
      'https://www.youtube.com/watch?v=$videoId';

  static String youtubeThumbnailUrl(String videoId) =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  /// Разбивает текст на блоки: Markdown-абзацы и YouTube-embed (отдельный абзац с URL).
  static List<ArticleBodyBlock> splitBodyBlocks(String markdown) {
    if (markdown.trim().isEmpty) return [];

    final blocks = <ArticleBodyBlock>[];
    final buffer = StringBuffer();

    void flushMarkdown() {
      final chunk = buffer.toString().trimRight();
      buffer.clear();
      if (chunk.isNotEmpty) {
        blocks.add(ArticleBodyBlock.markdown(chunk));
      }
    }

    for (final para in markdown.split(RegExp(r'\n{2,}'))) {
      final trimmed = para.trim();
      if (trimmed.isEmpty) continue;

      final yt = extractYoutubeVideoId(trimmed);
      final isEmbed = yt != null &&
          !trimmed.contains('\n') &&
          (trimmed.startsWith('http') ||
              RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(trimmed));

      if (isEmbed) {
        flushMarkdown();
        blocks.add(ArticleBodyBlock.youtube(yt));
      } else {
        if (buffer.isNotEmpty) buffer.write('\n\n');
        buffer.write(para);
      }
    }
    flushMarkdown();
    return blocks;
  }
}

class ArticleBodyBlock {
  const ArticleBodyBlock._({this.markdown, this.youtubeVideoId});

  factory ArticleBodyBlock.markdown(String text) =>
      ArticleBodyBlock._(markdown: text);

  factory ArticleBodyBlock.youtube(String videoId) =>
      ArticleBodyBlock._(youtubeVideoId: videoId);

  final String? markdown;
  final String? youtubeVideoId;

  bool get isYoutube => youtubeVideoId != null;
}
