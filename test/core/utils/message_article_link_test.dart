import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/message_article_link.dart';

void main() {
  test('extracts article id from shared message tail', () {
    const text = 'My title\n\nExcerpt here\n\narticle:a-99';
    expect(extractArticleLinkId(text), 'a-99');
    expect(displayTextWithoutArticleLink(text), 'My title\n\nExcerpt here');
  });

  test('returns null when no article link present', () {
    expect(extractArticleLinkId('plain message'), isNull);
    expect(displayTextWithoutArticleLink('plain message'), 'plain message');
  });
}
