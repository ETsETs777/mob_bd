import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_sync_conflict.dart';
import 'package:ecopulse/core/utils/article_sync_outbox.dart';
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

  group('ArticleSyncOutbox', () {
    test('enqueue and load roundtrip', () async {
      final op = ArticleSyncOperation(
        queueId: 'q1',
        kind: ArticleSyncOpKind.submit,
        tempArticleId: 'local-1',
        title: 'Title',
        body: 'Body long enough',
        queuedAt: DateTime.utc(2026, 6, 1),
        authorId: 'u1',
        authorName: 'User',
        authorLogin: 'user',
      );
      await ArticleSyncOutbox.enqueue(op);
      final loaded = ArticleSyncOutbox.load();
      expect(loaded, hasLength(1));
      expect(loaded.first.title, 'Title');
    });

    test('update replaces pending op for same article', () async {
      await ArticleSyncOutbox.enqueue(
        ArticleSyncOperation(
          queueId: 'q1',
          kind: ArticleSyncOpKind.update,
          articleId: 'a1',
          title: 'Old',
          body: 'Old body text',
          queuedAt: DateTime.utc(2026, 6, 1),
          authorId: 'u1',
          authorName: 'User',
          authorLogin: 'user',
        ),
      );
      await ArticleSyncOutbox.enqueue(
        ArticleSyncOperation(
          queueId: 'q2',
          kind: ArticleSyncOpKind.update,
          articleId: 'a1',
          title: 'New',
          body: 'New body text',
          queuedAt: DateTime.utc(2026, 6, 2),
          authorId: 'u1',
          authorName: 'User',
          authorLogin: 'user',
        ),
      );
      final loaded = ArticleSyncOutbox.load();
      expect(loaded, hasLength(1));
      expect(loaded.first.title, 'New');
    });
  });

  group('ArticleSyncConflict', () {
    test('detects when server changed after base time', () {
      final base = DateTime.utc(2026, 6, 1, 12);
      final server = UserArticle(
        id: 'a1',
        title: 'Server title',
        body: 'Server body text',
        status: UserArticleStatus.pending,
        authorId: 'u1',
        authorName: 'A',
        authorLogin: 'a',
        createdAt: base,
        updatedAt: DateTime.utc(2026, 6, 2, 12),
      );
      expect(
        ArticleSyncConflict.detect(
          baseUpdatedAt: base,
          pendingTitle: 'Local title',
          pendingBody: 'Local body text',
          server: server,
        ),
        isTrue,
      );
    });

    test('no conflict when server unchanged since base', () {
      final base = DateTime.utc(2026, 6, 2, 12);
      final server = UserArticle(
        id: 'a1',
        title: 'Same',
        body: 'Same body text',
        status: UserArticleStatus.pending,
        authorId: 'u1',
        authorName: 'A',
        authorLogin: 'a',
        createdAt: base,
        updatedAt: base,
      );
      expect(
        ArticleSyncConflict.detect(
          baseUpdatedAt: base,
          pendingTitle: 'Same',
          pendingBody: 'Same body text',
          server: server,
        ),
        isFalse,
      );
    });
  });
}
