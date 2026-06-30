/// Категории и теги статей Community.
library;

import 'dart:convert';

abstract final class ArticleCategories {
  static const all = 'all';
  static const markets = 'markets';
  static const portfolio = 'portfolio';
  static const macro = 'macro';
  static const learn = 'learn';
  static const community = 'community';
  static const other = 'other';

  static const slugs = [
    markets,
    portfolio,
    macro,
    learn,
    community,
    other,
  ];

  static String normalizeCategory(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();
    if (v.isEmpty || v == all) return other;
    return slugs.contains(v) ? v : other;
  }
}

List<String> normalizeTags(dynamic raw) {
  Iterable<String> source;
  if (raw is List) {
    source = raw.map((e) => e.toString());
  } else if (raw is String && raw.trim().isNotEmpty) {
    if (raw.trimLeft().startsWith('[')) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        source = decoded.map((e) => e.toString());
      } catch (_) {
        source = raw.split(',');
      }
    } else {
      source = raw.split(',');
    }
  } else {
    return const [];
  }

  final out = <String>[];
  for (final item in source) {
    final tag = item.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    if (tag.length < 2 || tag.length > 32) continue;
    if (!out.contains(tag)) out.add(tag);
    if (out.length >= 8) break;
  }
  return out;
}

String encodeTags(List<String> tags) => jsonEncode(normalizeTags(tags));

List<String> decodeTags(Object? raw) {
  if (raw == null) return const [];
  if (raw is List) return normalizeTags(raw);
  if (raw is String && raw.isNotEmpty) return normalizeTags(raw);
  return const [];
}
