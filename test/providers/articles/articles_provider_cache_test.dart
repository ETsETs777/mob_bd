import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/data/models/user_article.dart';
import 'package:ecopulse/data/services/cache_service.dart';
import 'package:ecopulse/providers/articles/articles_provider.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('published cache roundtrips through ArticlesNotifier.build', () async {
    final article = UserArticle(
      id: 'a1',
      title: 'Test',
      body: 'Body text long enough',
      status: UserArticleStatus.approved,
      authorId: 'u1',
      authorName: 'Author',
      authorLogin: 'author',
      createdAt: DateTime(2026, 6, 1),
      updatedAt: DateTime(2026, 6, 2),
    );

    await CacheService.instance.putString(
      ArticlesNotifier.publishedCacheKey,
      jsonEncode([
        {
          'id': article.id,
          'title': article.title,
          'body': article.body,
          'status': article.status.name,
          'authorId': article.authorId,
          'authorName': article.authorName,
          'authorLogin': article.authorLogin,
          'createdAt': article.createdAt.toIso8601String(),
          'updatedAt': article.updatedAt.toIso8601String(),
        },
      ]),
    );

    final raw = CacheService.instance.getString(ArticlesNotifier.publishedCacheKey);
    expect(raw, isNotNull);
    final list = jsonDecode(raw!) as List<dynamic>;
    expect(list, hasLength(1));
    expect(list.first['title'], 'Test');
  });
}
