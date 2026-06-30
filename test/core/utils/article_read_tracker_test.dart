import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_read_tracker.dart';
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

  test('marks article read and detects updates', () async {
    final updatedAt = DateTime(2026, 6, 1);
    expect(ArticleReadTracker.isUnread('a1', updatedAt), isTrue);

    await ArticleReadTracker.markRead(
      'a1',
      updatedAt: updatedAt.toIso8601String(),
    );
    expect(ArticleReadTracker.isUnread('a1', updatedAt), isFalse);
    expect(
      ArticleReadTracker.isUnread('a1', updatedAt.add(const Duration(days: 1))),
      isTrue,
    );
  });

  test('markUnread clears read state', () async {
    final updatedAt = DateTime(2026, 6, 1);
    await ArticleReadTracker.markRead(
      'a2',
      updatedAt: updatedAt.toIso8601String(),
    );
    expect(ArticleReadTracker.isUnread('a2', updatedAt), isFalse);

    await ArticleReadTracker.markUnread('a2');
    expect(ArticleReadTracker.isUnread('a2', updatedAt), isTrue);
  });

  test('markAllRead clears unread state', () async {
    final updatedAt = DateTime(2026, 6, 1);
    await ArticleReadTracker.markAllRead([
      UserArticle(
        id: 'a1',
        title: 'T',
        body: 'Body',
        status: UserArticleStatus.approved,
        authorId: 'u1',
        authorName: 'A',
        authorLogin: 'a',
        createdAt: updatedAt,
        updatedAt: updatedAt,
      ),
    ]);
    expect(ArticleReadTracker.isUnread('a1', updatedAt), isFalse);
    expect(ArticleReadTracker.unreadCount([]), 0);
  });
}
