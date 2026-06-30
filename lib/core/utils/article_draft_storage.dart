import 'dart:convert';

import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Локальный черновик статьи до отправки на модерацию.
class ArticleDraft {
  const ArticleDraft({
    required this.title,
    required this.body,
    required this.updatedAt,
  });

  final String title;
  final String body;
  final DateTime updatedAt;

  bool get isEmpty => title.trim().isEmpty && body.trim().isEmpty;

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ArticleDraft.fromJson(Map<String, dynamic> json) {
    return ArticleDraft(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class ArticleDraftStorage {
  ArticleDraftStorage._();

  static const cacheKey = 'user_article_draft_v1';

  static ArticleDraft? load() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final draft = ArticleDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      return draft.isEmpty ? null : draft;
    } catch (_) {
      return null;
    }
  }

  static Future<void> save({required String title, required String body}) async {
    if (title.trim().isEmpty && body.trim().isEmpty) {
      await clear();
      return;
    }
    final draft = ArticleDraft(
      title: title,
      body: body,
      updatedAt: DateTime.now(),
    );
    await CacheService.instance.putString(cacheKey, jsonEncode(draft.toJson()));
    UserLocalDataAutoSync.onCommunityPrefsChanged();
  }

  static Future<void> clear() async {
    await CacheService.instance.putString(cacheKey, '');
    UserLocalDataAutoSync.onCommunityPrefsChanged();
  }
}
