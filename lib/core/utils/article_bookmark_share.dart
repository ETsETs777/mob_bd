import '../../data/models/user_article.dart';
import 'article_bookmark_storage.dart';
import 'markdown_utils.dart';

/// Текст для share всех закладок.
String buildBookmarkedArticlesShareText(List<UserArticle> articles) {
  final ids = ArticleBookmarkStorage.load();
  if (ids.isEmpty) return '';

  final buffer = StringBuffer();
  var count = 0;
  for (final article in articles) {
    if (!ids.contains(article.id)) continue;
    count++;
    buffer.writeln('## ${article.title}');
    buffer.writeln(
      MarkdownUtils.previewExcerpt(article.body, maxLength: 500),
    );
    buffer.writeln();
  }

  if (count == 0) return '';
  return buffer.toString().trim();
}
