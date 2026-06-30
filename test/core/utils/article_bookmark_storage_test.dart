import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/article_bookmark_storage.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('toggle bookmark adds and removes id', () async {
    expect(ArticleBookmarkStorage.isBookmarked('a1'), isFalse);
    final added = await ArticleBookmarkStorage.toggle('a1');
    expect(added, isTrue);
    expect(ArticleBookmarkStorage.isBookmarked('a1'), isTrue);

    final removed = await ArticleBookmarkStorage.toggle('a1');
    expect(removed, isFalse);
    expect(ArticleBookmarkStorage.isBookmarked('a1'), isFalse);
  });
}
