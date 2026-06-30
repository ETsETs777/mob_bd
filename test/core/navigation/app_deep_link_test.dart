import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/navigation/app_deep_link.dart';

void main() {
  group('AppDeepLink', () {
    test('parses custom scheme article link', () {
      final link = AppDeepLink.parse(
        Uri.parse('ecopulse://article/art-42'),
      );
      expect(link?.kind, AppDeepLinkKind.article);
      expect(link?.id, 'art-42');
    });

    test('parses https article link', () {
      final link = AppDeepLink.parse(
        Uri.parse('https://ecopulse.app/article/art-99'),
      );
      expect(link?.kind, AppDeepLinkKind.article);
      expect(link?.id, 'art-99');
    });

    test('parses thread and calendar links', () {
      expect(
        AppDeepLink.parse(Uri.parse('ecopulse://thread/t-1'))?.kind,
        AppDeepLinkKind.thread,
      );
      expect(
        AppDeepLink.parse(Uri.parse('https://ecopulse.app/calendar/e-2'))?.kind,
        AppDeepLinkKind.calendar,
      );
    });

    test('builds share URLs', () {
      final link = AppDeepLink.article('abc');
      expect(link.customLink, 'ecopulse://article/abc');
      expect(link.webLink, 'https://ecopulse.app/article/abc');
    });

    test('extractArticleReferenceId supports legacy and URL formats', () {
      expect(
        extractArticleReferenceId('Hi\n\narticle:legacy-id'),
        'legacy-id',
      );
      expect(
        extractArticleReferenceId('Read\nhttps://ecopulse.app/article/url-id'),
        'url-id',
      );
    });
  });
}
