import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_bookmark_share.dart';
import 'package:ecopulse/core/utils/article_bookmark_storage.dart';
import 'package:ecopulse/data/models/user_article.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('builds share text for bookmarked articles only', () async {
    await ArticleBookmarkStorage.toggle('a1');

    final articles = [
      UserArticle(
        id: 'a1',
        title: 'Saved',
        body: 'Body text',
        status: UserArticleStatus.approved,
        authorId: 'u1',
        authorName: 'Author',
        authorLogin: 'author',
        createdAt: DateTime(2026, 6, 1),
        updatedAt: DateTime(2026, 6, 2),
      ),
      UserArticle(
        id: 'a2',
        title: 'Other',
        body: 'Other body',
        status: UserArticleStatus.approved,
        authorId: 'u2',
        authorName: 'Other',
        authorLogin: 'other',
        createdAt: DateTime(2026, 6, 1),
        updatedAt: DateTime(2026, 6, 2),
      ),
    ];

    final text = buildBookmarkedArticlesShareText(articles);
    expect(text, contains('Saved'));
    expect(text, isNot(contains('Other')));
  });
}
