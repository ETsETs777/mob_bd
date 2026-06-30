import 'dart:convert';

import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';

enum ArticleSyncOpKind { submit, update, delete }

/// Операция в очереди синхронизации (офлайн submit/update/delete).
class ArticleSyncOperation {
  const ArticleSyncOperation({
    required this.queueId,
    required this.kind,
    required this.queuedAt,
    required this.authorId,
    required this.authorName,
    required this.authorLogin,
    this.articleId,
    this.tempArticleId,
    this.title = '',
    this.body = '',
    this.category = 'other',
    this.tags = const [],
    this.baseUpdatedAt,
    this.blocked = false,
    this.serverTitle,
    this.serverBody,
    this.serverUpdatedAt,
  });

  final String queueId;
  final ArticleSyncOpKind kind;
  final String? articleId;
  final String? tempArticleId;
  final String title;
  final String body;
  final String category;
  final List<String> tags;
  final DateTime? baseUpdatedAt;
  final DateTime queuedAt;
  final String authorId;
  final String authorName;
  final String authorLogin;
  final bool blocked;
  final String? serverTitle;
  final String? serverBody;
  final DateTime? serverUpdatedAt;

  bool get isLocalOnly =>
      kind == ArticleSyncOpKind.submit &&
      tempArticleId != null &&
      tempArticleId!.startsWith('local-');

  Map<String, dynamic> toJson() => {
        'queueId': queueId,
        'kind': kind.name,
        'articleId': articleId,
        'tempArticleId': tempArticleId,
        'title': title,
        'body': body,
        'category': category,
        'tags': tags,
        'baseUpdatedAt': baseUpdatedAt?.toIso8601String(),
        'queuedAt': queuedAt.toIso8601String(),
        'authorId': authorId,
        'authorName': authorName,
        'authorLogin': authorLogin,
        'blocked': blocked,
        'serverTitle': serverTitle,
        'serverBody': serverBody,
        'serverUpdatedAt': serverUpdatedAt?.toIso8601String(),
      };

  factory ArticleSyncOperation.fromJson(Map<String, dynamic> json) {
    return ArticleSyncOperation(
      queueId: json['queueId'] as String,
      kind: ArticleSyncOpKind.values.firstWhere(
        (k) => k.name == json['kind'],
        orElse: () => ArticleSyncOpKind.submit,
      ),
      articleId: json['articleId'] as String?,
      tempArticleId: json['tempArticleId'] as String?,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? 'other',
      tags: json['tags'] is List
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : const [],
      baseUpdatedAt: json['baseUpdatedAt'] != null
          ? DateTime.tryParse(json['baseUpdatedAt'] as String)
          : null,
      queuedAt: DateTime.tryParse(json['queuedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorLogin: json['authorLogin'] as String? ?? '',
      blocked: json['blocked'] == true,
      serverTitle: json['serverTitle'] as String?,
      serverBody: json['serverBody'] as String?,
      serverUpdatedAt: json['serverUpdatedAt'] != null
          ? DateTime.tryParse(json['serverUpdatedAt'] as String)
          : null,
    );
  }

  ArticleSyncOperation copyWith({
    bool? blocked,
    String? serverTitle,
    String? serverBody,
    DateTime? serverUpdatedAt,
    String? articleId,
  }) {
    return ArticleSyncOperation(
      queueId: queueId,
      kind: kind,
      articleId: articleId ?? this.articleId,
      tempArticleId: tempArticleId,
      title: title,
      body: body,
      category: category,
      tags: tags,
      baseUpdatedAt: baseUpdatedAt,
      queuedAt: queuedAt,
      authorId: authorId,
      authorName: authorName,
      authorLogin: authorLogin,
      blocked: blocked ?? this.blocked,
      serverTitle: serverTitle ?? this.serverTitle,
      serverBody: serverBody ?? this.serverBody,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    );
  }

  UserArticle toOptimisticArticle() {
    final id = tempArticleId ?? articleId ?? queueId;
    return UserArticle(
      id: id,
      title: title,
      body: body,
      status: UserArticleStatus.pending,
      authorId: authorId,
      authorName: authorName,
      authorLogin: authorLogin,
      createdAt: queuedAt,
      updatedAt: queuedAt,
      category: category,
      tags: tags,
    );
  }
}

class ArticleSyncOutbox {
  ArticleSyncOutbox._();

  static const cacheKey = 'user_articles_sync_outbox_v1';

  static List<ArticleSyncOperation> load() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ArticleSyncOperation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<ArticleSyncOperation> ops) async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(ops.map((o) => o.toJson()).toList()),
    );
  }

  static Future<void> enqueue(ArticleSyncOperation op) async {
    var ops = load();
    if (op.kind == ArticleSyncOpKind.update && op.articleId != null) {
      ops.removeWhere(
        (o) =>
            o.kind == ArticleSyncOpKind.update &&
            o.articleId == op.articleId &&
            !o.blocked,
      );
    }
    ops.add(op);
    await save(ops);
  }

  static Future<void> replaceAll(List<ArticleSyncOperation> ops) async {
    await save(ops);
  }

  static Future<void> remove(String queueId) async {
    final ops = load().where((o) => o.queueId != queueId).toList();
    await save(ops);
  }

  static String newQueueId() =>
      'q-${DateTime.now().microsecondsSinceEpoch}';

  static String newTempArticleId() =>
      'local-${DateTime.now().microsecondsSinceEpoch}';
}
