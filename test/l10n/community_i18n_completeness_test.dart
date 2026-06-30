import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Community-related ARB keys (articles, chats, moderation, offline sync).
const _communityKeyPatterns = [
  'community',
  'userArticles',
  'messages',
  'article',
  'featureTourCommunity',
  'tabCommunity',
  'tabMessages',
  'tabArticles',
  'communityConnect',
];

/// Keys intentionally identical across locales (brands, URL schemes, counters).
const _allowIdenticalToEn = {
  'messagesThreadSearchCounter',
  'userArticlesMarkdownEmbed',
  'userArticlesUrlHint',
};

Map<String, dynamic> _loadArb(String path) {
  final raw = File(path).readAsStringSync();
  return jsonDecode(raw) as Map<String, dynamic>;
}

Set<String> _communityKeys(Map<String, dynamic> arb) {
  return arb.keys
      .where((k) => !k.startsWith('@'))
      .where(
        (k) => _communityKeyPatterns.any(
          (p) => k.toLowerCase().contains(p.toLowerCase()),
        ),
      )
      .toSet();
}

void main() {
  final en = _loadArb('lib/l10n/app_en.arb');
  final communityKeys = _communityKeys(en);

  test('DE/IT/RU contain all community keys from EN', () {
    for (final locale in ['de', 'it', 'ru']) {
      final loc = _loadArb('lib/l10n/app_$locale.arb');
      final missing = communityKeys.difference(_communityKeys(loc));
      expect(
        missing,
        isEmpty,
        reason: '$locale missing community keys: $missing',
      );
    }
  });

  test('DE/IT/RU community strings are translated (not copied from EN)', () {
    for (final locale in ['de', 'it', 'ru']) {
      final loc = _loadArb('lib/l10n/app_$locale.arb');
      final untranslated = <String>[];
      for (final key in communityKeys) {
        if (_allowIdenticalToEn.contains(key)) continue;
        final enVal = en[key];
        final locVal = loc[key];
        if (enVal is String && locVal is String && enVal == locVal) {
          untranslated.add(key);
        }
      }
      expect(
        untranslated,
        isEmpty,
        reason: '$locale has EN copies: $untranslated',
      );
    }
  });

  test('community sync/offline keys exist in all locales', () {
    const required = [
      'userArticlesStaleCache',
      'userArticlesPendingSync',
      'userArticlesSyncConflictBanner',
      'userArticlesSyncResolve',
      'userArticlesSyncConflictTitle',
      'userArticlesSyncConflictMessage',
      'userArticlesSyncKeepLocal',
      'userArticlesSyncUseServer',
      'userArticlesSavedOffline',
    ];
    for (final locale in ['en', 'de', 'it', 'ru']) {
      final loc = _loadArb('lib/l10n/app_$locale.arb');
      for (final key in required) {
        expect(loc[key], isNotNull, reason: '$locale missing $key');
        expect(loc[key], isNotEmpty, reason: '$locale empty $key');
      }
    }
  });
}
