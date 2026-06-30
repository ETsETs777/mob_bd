import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/markdown_utils.dart';

void main() {
  test('previewExcerpt strips markdown headings and links', () {
    const raw = '## Заголовок\n\nТекст с [ссылкой](https://example.com) и **жирным**.';
    final excerpt = MarkdownUtils.previewExcerpt(raw);
    expect(excerpt, contains('Заголовок'));
    expect(excerpt, contains('ссылкой'));
    expect(excerpt, isNot(contains('##')));
    expect(excerpt, isNot(contains('https://')));
  });

  test('readingTimeMinutes estimates from word count', () {
    final text = List.filled(400, 'word').join(' ');
    expect(MarkdownUtils.readingTimeMinutes(text), 2);
  });

  test('previewExcerpt truncates long text', () {
    final long = List.filled(40, 'слово').join(' ');
    final excerpt = MarkdownUtils.previewExcerpt(long, maxLength: 30);
    expect(excerpt.length, lessThanOrEqualTo(30));
    expect(excerpt.endsWith('…'), isTrue);
  });
}
