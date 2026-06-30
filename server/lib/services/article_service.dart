/// Сервис пользовательских статей с модерацией.
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../db/database.dart';
import '../db/sql_utils.dart';
import '../models/article_taxonomy.dart';
import '../auth/staff_role.dart';

class ArticleService {
  ArticleService(this.db, {required this.dataDir});

  final AppDatabase db;
  final String dataDir;
  final _uuid = const Uuid();

  static const maxTitle = 120;
  static const minTitle = 3;
  static const maxBody = 10000;
  static const minBody = 10;
  static const maxCoverBytes = 2 * 1024 * 1024;
  static const maxVersionsPerArticle = 50;
  static const maxBatchSize = 100;

  Future<Map<String, dynamic>> submit({
    required String authorId,
    required String title,
    required String body,
    String? category,
    List<String>? tags,
  }) async {
    final t = title.trim();
    final b = body.trim();
    if (t.length < minTitle) throw ArticleException('title_too_short');
    if (t.length > maxTitle) throw ArticleException('title_too_long');
    if (b.length < minBody) throw ArticleException('body_too_short');
    if (b.length > maxBody) throw ArticleException('body_too_long');

    final id = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    final cat = ArticleCategories.normalizeCategory(category);
    final tagsJson = encodeTags(tags ?? const []);
    await db.execute(
      'INSERT INTO user_articles(id, author_id, title, body, status, created_at, updated_at, '
      'category, tags_json, featured) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, 0)',
      [id, authorId, t, b, 'pending', now, now, cat, tagsJson],
    );
    await db.audit(
      action: 'article_submit',
      userId: authorId,
      meta: {'articleId': id},
    );
    final saved = await _getRow(id, authorId, isStaff: false); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<List<Map<String, dynamic>>> listPublished({
    int limit = 50,
    int offset = 0,
    String? category,
    String? tag,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final params = <Object?>['approved', now];
    final clauses = <String>[
      'a.status = ?',
      '(a.publish_at IS NULL OR a.publish_at <= ?)',
    ];

    final cat = category?.trim().toLowerCase();
    if (cat != null && cat.isNotEmpty && cat != ArticleCategories.all) {
      clauses.add('a.category = ?');
      params.add(ArticleCategories.normalizeCategory(cat));
    }
    if (tag != null && tag.trim().isNotEmpty) {
      clauses.add("a.tags_json LIKE ?");
      params.add('%"${normalizeTags([tag]).firstOrNull ?? tag.trim().toLowerCase()}"%');
    }

    params.addAll([limit.clamp(1, 100), offset.clamp(0, 10000)]);

    final rows = await db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE ${clauses.join(' AND ')} '
      'ORDER BY a.updated_at DESC '
      'LIMIT ? OFFSET ?',
      params,
    );
    return rows.map(_mapPublic).toList();
  }

  Future<List<Map<String, dynamic>>> listFeatured({int limit = 5}) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final rows = await db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE a.status = ? AND a.featured = 1 '
      'AND (a.publish_at IS NULL OR a.publish_at <= ?) '
      'ORDER BY a.updated_at DESC '
      'LIMIT ?',
      ['approved', now, limit.clamp(1, 20)],
    );
    return rows.map(_mapPublic).toList();
  }

  Future<Map<String, dynamic>> taxonomy() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final rows = await db.select(
      'SELECT category, tags_json FROM user_articles '
      'WHERE status = ? AND (publish_at IS NULL OR publish_at <= ?)',
      ['approved', now],
    );

    final categoryCounts = <String, int>{};
    final tagCounts = <String, int>{};
    for (final row in rows) {
      final cat = row['category'] as String? ?? ArticleCategories.other;
      categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
      for (final tag in decodeTags(row['tags_json'])) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    final tags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'categories': [
        for (final slug in ArticleCategories.slugs)
          if ((categoryCounts[slug] ?? 0) > 0)
            {'id': slug, 'count': categoryCounts[slug] ?? 0},
      ],
      'tags': [
        for (final e in tags.take(30)) {'id': e.key, 'count': e.value},
      ],
    };
  }

  Future<List<Map<String, dynamic>>> listMine(String authorId) async {
    final rows = await db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE a.author_id = ? '
      'ORDER BY a.updated_at DESC',
      [authorId],
    );
    return rows.map(_mapOwn).toList();
  }

  Future<List<Map<String, dynamic>>> listPending() async {
    final rows = await db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE a.status = ? '
      'ORDER BY a.created_at ASC',
      ['pending'],
    );
    return rows.map(_mapOwn).toList();
  }

  Future<Map<String, dynamic>?> get({
    required String articleId,
    required String viewerId,
    required bool isStaff,
  }) async {
    return await _getRow(articleId, viewerId, isStaff: isStaff);
  }

  Future<Map<String, dynamic>> approve({
    required String articleId,
    required String adminId,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['status'] != 'pending') throw ArticleException('invalid_status');

    final now = DateTime.now().toUtc().toIso8601String();
    await db.execute(
      'UPDATE user_articles SET status = ?, moderated_at = ?, moderated_by = ?, '
      'reject_reason = NULL, updated_at = ? WHERE id = ?',
      ['approved', now, adminId, now, articleId],
    );
    await db.audit(
      action: 'article_approve',
      userId: adminId,
      meta: {'articleId': articleId},
    );
    final saved = await _getRow(articleId, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<Map<String, dynamic>> update({
    required String authorId,
    required String articleId,
    required String title,
    required String body,
    String? category,
    List<String>? tags,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['author_id'] != authorId) throw ArticleException('forbidden');
    if (row['status'] != 'pending') throw ArticleException('invalid_status');

    final t = title.trim();
    final b = body.trim();
    _validateContent(t, b);

    final cat = category != null
        ? ArticleCategories.normalizeCategory(category)
        : row['category'] as String? ?? ArticleCategories.other;
    final tagsJson =
        tags != null ? encodeTags(tags) : row['tags_json'] as String? ?? '[]';

    final now = DateTime.now().toUtc().toIso8601String();
    await _saveVersion(row, createdBy: authorId, source: 'author_update');
    await db.execute(
      'UPDATE user_articles SET title = ?, body = ?, updated_at = ?, '
      'category = ?, tags_json = ? WHERE id = ?',
      [t, b, now, cat, tagsJson, articleId],
    );
    await db.audit(
      action: 'article_update',
      userId: authorId,
      meta: {'articleId': articleId},
    );
    final saved = await _getRow(articleId, authorId, isStaff: false); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<void> delete({
    required String authorId,
    required String articleId,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['author_id'] != authorId) throw ArticleException('forbidden');
    final status = row['status'] as String;
    if (status != 'pending' && status != 'rejected') {
      throw ArticleException('invalid_status');
    }

    await db.execute('DELETE FROM user_articles WHERE id = ?', [articleId]);
    await db.audit(
      action: 'article_delete',
      userId: authorId,
      meta: {'articleId': articleId},
    );
  }

  Future<List<Map<String, dynamic>>> listAll({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    final params = <Object?>[];
    final clauses = <String>[];

    if (status != null && status.isNotEmpty && status != 'all') {
      clauses.add('a.status = ?');
      params.add(status);
    }
    if (q != null && q.trim().isNotEmpty) {
      clauses.add('(a.title LIKE ? OR a.body LIKE ? OR u.login LIKE ?)');
      final like = '%${q.trim()}%';
      params.addAll([like, like, like]);
    }

    final where = clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}';
    params.addAll([limit.clamp(1, 200), offset.clamp(0, 10000)]);

    final rows = await db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      '$where '
      'ORDER BY a.updated_at DESC '
      'LIMIT ? OFFSET ?',
      params,
    );
    return rows.map(_mapOwn).toList();
  }

  Future<Map<String, dynamic>> adminCreate({
    required String adminId,
    required String title,
    required String body,
    bool publish = true,
    String? publishAt,
    String? coverUrl,
    String? category,
    List<String>? tags,
    bool featured = false,
  }) async {
    final t = title.trim();
    final b = body.trim();
    _validateContent(t, b);

    final id = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    final parsedPublishAt = _parsePublishAt(publishAt);
    final status = publish || parsedPublishAt != null ? 'approved' : 'pending';
    final cat = ArticleCategories.normalizeCategory(category);
    final tagsJson = encodeTags(tags ?? const []);
    final feat = featured ? 1 : 0;

    await db.execute(
      'INSERT INTO user_articles(id, author_id, title, body, status, created_at, updated_at, '
      'moderated_at, moderated_by, cover_url, publish_at, category, tags_json, featured) '
      'VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        id,
        adminId,
        t,
        b,
        status,
        now,
        now,
        status == 'approved' ? now : null,
        status == 'approved' ? adminId : null,
        coverUrl,
        parsedPublishAt,
        cat,
        tagsJson,
        feat,
      ],
    );
    await db.audit(
      action: status == 'approved'
          ? 'admin_article_publish'
          : 'admin_article_create',
      userId: adminId,
      meta: {'articleId': id, if (parsedPublishAt != null) 'publishAt': parsedPublishAt},
    );
    final saved = await _getRow(id, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<Map<String, dynamic>> adminUpdate({
    required String adminId,
    required String articleId,
    required String title,
    required String body,
    String? status,
    String? publishAt,
    String? coverUrl,
    bool clearCover = false,
    String? category,
    List<String>? tags,
    bool? featured,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');

    final t = title.trim();
    final b = body.trim();
    _validateContent(t, b);

    final now = DateTime.now().toUtc().toIso8601String();
    if (status != null &&
        status != 'pending' &&
        status != 'approved' &&
        status != 'rejected') {
      throw ArticleException('invalid_status');
    }

    final parsedPublishAt =
        publishAt != null ? _parsePublishAt(publishAt, allowEmpty: true) : null;
    final nextCover = clearCover
        ? null
        : (coverUrl ?? row['cover_url'] as String?);
    final nextPublishAt =
        publishAt != null ? parsedPublishAt : row['publish_at'];
    final nextCategory = category != null
        ? ArticleCategories.normalizeCategory(category)
        : row['category'] as String? ?? ArticleCategories.other;
    final nextTagsJson =
        tags != null ? encodeTags(tags) : row['tags_json'] as String? ?? '[]';
    final nextFeatured =
        featured != null ? (featured ? 1 : 0) : row['featured'] as int? ?? 0;
    final nextStatus = status ?? row['status'] as String;

    await _saveVersion(row, createdBy: adminId, source: 'admin_update');
    if (status != null) {
      await db.execute(
        'UPDATE user_articles SET title = ?, body = ?, status = ?, updated_at = ?, '
        'moderated_at = ?, moderated_by = ?, cover_url = ?, publish_at = ?, '
        'category = ?, tags_json = ?, featured = ? WHERE id = ?',
        [
          t,
          b,
          nextStatus,
          now,
          now,
          adminId,
          nextCover,
          nextPublishAt,
          nextCategory,
          nextTagsJson,
          nextFeatured,
          articleId,
        ],
      );
    } else if (publishAt != null || coverUrl != null || clearCover) {
      await db.execute(
        'UPDATE user_articles SET title = ?, body = ?, updated_at = ?, cover_url = ?, '
        'publish_at = ?, category = ?, tags_json = ?, featured = ? WHERE id = ?',
        [
          t,
          b,
          now,
          nextCover,
          parsedPublishAt,
          nextCategory,
          nextTagsJson,
          nextFeatured,
          articleId,
        ],
      );
    } else {
      await db.execute(
        'UPDATE user_articles SET title = ?, body = ?, updated_at = ?, '
        'category = ?, tags_json = ?, featured = ? WHERE id = ?',
        [t, b, now, nextCategory, nextTagsJson, nextFeatured, articleId],
      );
    }

    await db.audit(
      action: 'admin_article_update',
      userId: adminId,
      meta: {
        'articleId': articleId,
        'status': status,
        if (parsedPublishAt != null) 'publishAt': parsedPublishAt,
      },
    );
    final saved = await _getRow(articleId, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<Map<String, dynamic>> setCover({
    required String adminId,
    required String articleId,
    required List<int> bytes,
    required String contentType,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (bytes.isEmpty || bytes.length > maxCoverBytes) {
      throw ArticleException('cover_too_large');
    }

    final ext = switch (contentType) {
      'image/png' => '.png',
      'image/webp' => '.webp',
      'image/gif' => '.gif',
      _ => '.jpg',
    };

    final dir = Directory(p.join(dataDir, 'article_covers'));
    if (!dir.existsSync()) dir.createSync(recursive: true);

    for (final f in dir.listSync()) {
      if (f is File && p.basenameWithoutExtension(f.path) == articleId) {
        f.deleteSync();
      }
    }

    final file = File(p.join(dir.path, '$articleId$ext'));
    file.writeAsBytesSync(bytes);

    final coverUrl = '/v1/media/article-covers/$articleId$ext';
    final now = DateTime.now().toUtc().toIso8601String();
    await db.execute(
      'UPDATE user_articles SET cover_url = ?, updated_at = ? WHERE id = ?',
      [coverUrl, now, articleId],
    );
    await db.audit(
      action: 'admin_article_cover',
      userId: adminId,
      meta: {'articleId': articleId},
    );
    final saved = await _getRow(articleId, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  File? coverFileForUrl(String coverUrl) {
    final prefix = '/v1/media/article-covers/';
    if (!coverUrl.startsWith(prefix)) return null;
    final name = coverUrl.substring(prefix.length);
    if (name.contains('..') || name.contains('/')) return null;
    final file = File(p.join(dataDir, 'article_covers', name));
    return file.existsSync() ? file : null;
  }

  Future<void> adminDelete({
    required String adminId,
    required String articleId,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');

    await db.execute('DELETE FROM user_articles WHERE id = ?', [articleId]);
    _deleteCoverFiles(articleId);
    await db.audit(
      action: 'admin_article_delete',
      userId: adminId,
      meta: {'articleId': articleId},
    );
  }

  Future<Map<String, dynamic>> unpublish({
    required String adminId,
    required String articleId,
    String? reason,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['status'] != 'approved') throw ArticleException('invalid_status');

    final now = DateTime.now().toUtc().toIso8601String();
    await _saveVersion(row, createdBy: adminId, source: 'unpublish');
    await db.execute(
      'UPDATE user_articles SET status = ?, reject_reason = ?, updated_at = ?, '
      'moderated_at = ?, moderated_by = ? WHERE id = ?',
      ['rejected', reason?.trim() ?? 'Снято администратором', now, now, adminId, articleId],
    );
    await db.audit(
      action: 'admin_article_unpublish',
      userId: adminId,
      meta: {'articleId': articleId},
    );
    final saved = await _getRow(articleId, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<Map<String, dynamic>> batchApprove({
    required String adminId,
    required List<String> articleIds,
  }) async {
    final ids = _normalizeBatchIds(articleIds);
    if (ids.isEmpty) throw ArticleException('ids_required');

    final succeeded = <Map<String, dynamic>>[];
    final failed = <Map<String, dynamic>>[];
    for (final id in ids) {
      try {
        final article = await approve(articleId: id, adminId: adminId);
        succeeded.add({'id': id, 'article': article});
      } on ArticleException catch (e) {
        failed.add({'id': id, 'error': e.code});
      }
    }
    await db.audit(
      action: 'admin_batch_approve',
      userId: adminId,
      meta: {
        'processed': succeeded.length,
        'failed': failed.length,
        'ids': ids,
      },
    );
    return _batchResult(succeeded, failed);
  }

  Future<Map<String, dynamic>> batchReject({
    required String adminId,
    required List<String> articleIds,
    String? reason,
  }) async {
    final ids = _normalizeBatchIds(articleIds);
    if (ids.isEmpty) throw ArticleException('ids_required');

    final succeeded = <Map<String, dynamic>>[];
    final failed = <Map<String, dynamic>>[];
    for (final id in ids) {
      try {
        final article = await reject(
          articleId: id,
          adminId: adminId,
          reason: reason,
        );
        succeeded.add({'id': id, 'article': article});
      } on ArticleException catch (e) {
        failed.add({'id': id, 'error': e.code});
      }
    }
    await db.audit(
      action: 'admin_batch_reject',
      userId: adminId,
      meta: {
        'processed': succeeded.length,
        'failed': failed.length,
        'ids': ids,
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      },
    );
    return _batchResult(succeeded, failed);
  }

  Future<Map<String, dynamic>> batchDelete({
    required String adminId,
    required List<String> articleIds,
  }) async {
    final ids = _normalizeBatchIds(articleIds);
    if (ids.isEmpty) throw ArticleException('ids_required');

    final succeeded = <Map<String, dynamic>>[];
    final failed = <Map<String, dynamic>>[];
    for (final id in ids) {
      try {
        await adminDelete(adminId: adminId, articleId: id);
        succeeded.add({'id': id});
      } on ArticleException catch (e) {
        failed.add({'id': id, 'error': e.code});
      }
    }
    await db.audit(
      action: 'admin_batch_delete',
      userId: adminId,
      meta: {
        'processed': succeeded.length,
        'failed': failed.length,
        'ids': ids,
      },
    );
    return _batchResult(succeeded, failed);
  }

  Future<List<Map<String, dynamic>>> listVersions({
    required String articleId,
    int limit = 30,
    int offset = 0,
  }) async {
    if (await _rawRow(articleId) == null) throw ArticleException('not_found');
    final rows = await db.select(
      'SELECT v.*, u.login AS created_by_login '
      'FROM article_versions v '
      'LEFT JOIN users u ON u.id = v.created_by '
      'WHERE v.article_id = ? '
      'ORDER BY v.version_number DESC '
      'LIMIT ? OFFSET ?',
      [articleId, limit.clamp(1, 100), offset.clamp(0, 10000)],
    );
    return rows.map(_mapVersionSummary).toList();
  }

  Future<Map<String, dynamic>> getVersion({
    required String articleId,
    required String versionId,
  }) async {
    if (await _rawRow(articleId) == null) throw ArticleException('not_found');
    final rows = await db.select(
      'SELECT v.*, u.login AS created_by_login '
      'FROM article_versions v '
      'LEFT JOIN users u ON u.id = v.created_by '
      'WHERE v.article_id = ? AND v.id = ?',
      [articleId, versionId],
    );
    if (rows.isEmpty) throw ArticleException('version_not_found');
    return _mapVersionFull(rows.first);
  }

  Future<Map<String, dynamic>> rollback({
    required String adminId,
    required String articleId,
    required String versionId,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');

    final versionRows = await db.select(
      'SELECT * FROM article_versions WHERE article_id = ? AND id = ?',
      [articleId, versionId],
    );
    if (versionRows.isEmpty) throw ArticleException('version_not_found');
    final version = versionRows.first;

    await _saveVersion(row, createdBy: adminId, source: 'pre_rollback');

    final now = DateTime.now().toUtc().toIso8601String();
    await db.execute(
      'UPDATE user_articles SET title = ?, body = ?, status = ?, reject_reason = ?, '
      'cover_url = ?, publish_at = ?, category = ?, tags_json = ?, featured = ?, '
      'updated_at = ?, moderated_at = ?, moderated_by = ? WHERE id = ?',
      [
        version['title'],
        version['body'],
        version['status'],
        version['reject_reason'],
        version['cover_url'],
        version['publish_at'],
        version['category'] ?? ArticleCategories.other,
        version['tags_json'] ?? '[]',
        version['featured'] ?? 0,
        now,
        now,
        adminId,
        articleId,
      ],
    );
    await db.audit(
      action: 'admin_article_rollback',
      userId: adminId,
      meta: {
        'articleId': articleId,
        'versionId': versionId,
        'versionNumber': version['version_number'],
      },
    );
    final saved = await _getRow(articleId, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  void _validateContent(String title, String body) {
    if (title.length < minTitle) throw ArticleException('title_too_short');
    if (title.length > maxTitle) throw ArticleException('title_too_long');
    if (body.length < minBody) throw ArticleException('body_too_short');
    if (body.length > maxBody) throw ArticleException('body_too_long');
  }

  Future<Map<String, dynamic>> reject({
    required String articleId,
    required String adminId,
    String? reason,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['status'] != 'pending') throw ArticleException('invalid_status');

    final now = DateTime.now().toUtc().toIso8601String();
    await db.execute(
      'UPDATE user_articles SET status = ?, moderated_at = ?, moderated_by = ?, '
      'reject_reason = ?, updated_at = ? WHERE id = ?',
      ['rejected', now, adminId, reason?.trim(), now, articleId],
    );
    await db.audit(
      action: 'article_reject',
      userId: adminId,
      meta: {'articleId': articleId, 'reason': reason},
    );
    final saved = await _getRow(articleId, adminId, isStaff: true); if (saved == null) throw ArticleException('not_found'); return saved;
  }

  Future<bool> isStaffUser(String userId) async {
    final rows = await db.select(
      'SELECT role, is_admin FROM users WHERE id = ?',
      [userId],
    );
    if (rows.isEmpty) return false;
    final row = rows.first;
    return StaffRole.isStaff(
      StaffRole.resolve(
        role: row['role'] as String?,
        legacyIsAdmin: row['is_admin'] as int?,
      ),
    );
  }

  Future<bool> isAdmin(String userId) => isStaffUser(userId);

  Future<bool> isAdminLogin(String login) async {
    final admins = await db.meta('admin_logins', fallback: 'admin');
    final set = admins
        .split(',')
        .map((s) => s.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toSet();
    return set.contains(login.trim().toLowerCase());
  }

  Future<Map<String, dynamic>?> _getRow(
    String articleId,
    String viewerId, {
    required bool isStaff,
  }) async {
    final row = await _rawRow(articleId);
    if (row == null) return null;

    final status = row['status'] as String;
    final authorId = row['author_id'] as String;
    final canView = status == 'approved' ||
        authorId == viewerId ||
        isStaff;
    if (!canView) return null;

    final users = await db.select(
      'SELECT display_name, login FROM users WHERE id = ?',
      [authorId],
    );
    final authorName = users.isEmpty
        ? ''
        : users.first['display_name'] as String? ?? '';
    final authorLogin =
        users.isEmpty ? '' : users.first['login'] as String? ?? '';

    final mapped = status == 'approved'
        ? _mapPublic({...row, 'author_name': authorName, 'author_login': authorLogin})
        : _mapOwn({...row, 'author_name': authorName, 'author_login': authorLogin});

    if (status != 'approved' && authorId != viewerId && !isStaff) {
      return null;
    }
    return mapped;
  }

  Future<Map<String, Object?>?> _rawRow(String articleId) async {
    final rows = await db.select(
      'SELECT * FROM user_articles WHERE id = ?',
      [articleId],
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Map<String, dynamic> _mapPublic(Map<String, Object?> row) => {
        'id': row['id'],
        'title': row['title'],
        'body': row['body'],
        'status': row['status'],
        'authorId': row['author_id'],
        'authorName': row['author_name'] ?? '',
        'authorLogin': row['author_login'] ?? '',
        'coverUrl': row['cover_url'],
        'publishAt': row['publish_at'],
        'category': row['category'] ?? ArticleCategories.other,
        'tags': decodeTags(row['tags_json']),
        'featured': row['featured'] == 1,
        'createdAt': row['created_at'],
        'updatedAt': row['updated_at'],
      };

  Map<String, dynamic> _mapOwn(Map<String, Object?> row) => {
        'id': row['id'],
        'title': row['title'],
        'body': row['body'],
        'status': row['status'],
        'authorId': row['author_id'],
        'authorName': row['author_name'] ?? '',
        'authorLogin': row['author_login'] ?? '',
        'rejectReason': row['reject_reason'],
        'coverUrl': row['cover_url'],
        'publishAt': row['publish_at'],
        'category': row['category'] ?? ArticleCategories.other,
        'tags': decodeTags(row['tags_json']),
        'featured': row['featured'] == 1,
        'createdAt': row['created_at'],
        'updatedAt': row['updated_at'],
        'moderatedAt': row['moderated_at'],
      };

  String? _parsePublishAt(String? raw, {bool allowEmpty = false}) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return allowEmpty ? null : throw ArticleException('invalid_publish_at');
    final dt = DateTime.tryParse(trimmed);
    if (dt == null) throw ArticleException('invalid_publish_at');
    return dt.toUtc().toIso8601String();
  }

  void _deleteCoverFiles(String articleId) {
    final dir = Directory(p.join(dataDir, 'article_covers'));
    if (!dir.existsSync()) return;
    for (final f in dir.listSync()) {
      if (f is File && p.basenameWithoutExtension(f.path) == articleId) {
        f.deleteSync();
      }
    }
  }

  Future<void> _saveVersion(
    Map<String, Object?> row, {
    required String? createdBy,
    required String source,
  }) async {
    final articleId = row['id'] as String;
    final maxRows = await db.select(
      'SELECT COALESCE(MAX(version_number), 0) AS m FROM article_versions '
      'WHERE article_id = ?',
      [articleId],
    );
    final versionNumber = SqlUtils.asInt(maxRows.first['m']) + 1;
    final now = DateTime.now().toUtc().toIso8601String();

    await db.execute(
      'INSERT INTO article_versions(id, article_id, version_number, title, body, status, '
      'reject_reason, cover_url, publish_at, category, tags_json, featured, source, '
      'created_by, created_at) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        _uuid.v4(),
        articleId,
        versionNumber,
        row['title'],
        row['body'],
        row['status'],
        row['reject_reason'],
        row['cover_url'],
        row['publish_at'],
        row['category'] ?? ArticleCategories.other,
        row['tags_json'] ?? '[]',
        row['featured'] ?? 0,
        source,
        createdBy,
        now,
      ],
    );
    await _pruneOldVersions(articleId);
  }

  Future<void> _pruneOldVersions(String articleId) async {
    final rows = await db.select(
      'SELECT id FROM article_versions WHERE article_id = ? '
      'ORDER BY version_number DESC OFFSET ?',
      [articleId, maxVersionsPerArticle],
    );
    for (final row in rows) {
      await db.execute('DELETE FROM article_versions WHERE id = ?', [row['id']]);
    }
  }

  List<String> _normalizeBatchIds(List<dynamic> raw) {
    final out = <String>[];
    for (final item in raw) {
      final id = item.toString().trim();
      if (id.isEmpty || out.contains(id)) continue;
      out.add(id);
      if (out.length >= maxBatchSize) break;
    }
    return out;
  }

  Map<String, dynamic> _batchResult(
    List<Map<String, dynamic>> succeeded,
    List<Map<String, dynamic>> failed,
  ) =>
      {
        'processed': succeeded.length,
        'failedCount': failed.length,
        'succeeded': succeeded,
        'failed': failed,
      };

  Map<String, dynamic> _mapVersionSummary(Map<String, Object?> row) => {
        'id': row['id'],
        'articleId': row['article_id'],
        'versionNumber': row['version_number'],
        'title': row['title'],
        'source': row['source'],
        'createdByLogin': row['created_by_login'] ?? '',
        'createdAt': row['created_at'],
      };

  Map<String, dynamic> _mapVersionFull(Map<String, Object?> row) => {
        ..._mapVersionSummary(row),
        'body': row['body'],
        'status': row['status'],
        'rejectReason': row['reject_reason'],
        'coverUrl': row['cover_url'],
        'publishAt': row['publish_at'],
        'category': row['category'] ?? ArticleCategories.other,
        'tags': decodeTags(row['tags_json']),
        'featured': row['featured'] == 1,
      };
}

class ArticleException implements Exception {
  ArticleException(this.code);
  final String code;

  @override
  String toString() => code;
}
