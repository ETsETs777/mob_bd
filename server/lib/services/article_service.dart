/// Сервис пользовательских статей с модерацией.
library;

import 'package:uuid/uuid.dart';

import '../db/database.dart';

class ArticleService {
  ArticleService(this.db);

  final AppDatabase db;
  final _uuid = const Uuid();

  static const maxTitle = 120;
  static const minTitle = 3;
  static const maxBody = 10000;
  static const minBody = 10;

  Map<String, dynamic> submit({
    required String authorId,
    required String title,
    required String body,
  }) {
    final t = title.trim();
    final b = body.trim();
    if (t.length < minTitle) throw ArticleException('title_too_short');
    if (t.length > maxTitle) throw ArticleException('title_too_long');
    if (b.length < minBody) throw ArticleException('body_too_short');
    if (b.length > maxBody) throw ArticleException('body_too_long');

    final id = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'INSERT INTO user_articles(id, author_id, title, body, status, created_at, updated_at) '
      'VALUES(?, ?, ?, ?, ?, ?, ?)',
      [id, authorId, t, b, 'pending', now, now],
    );
    db.audit(
      action: 'article_submit',
      userId: authorId,
      meta: {'articleId': id},
    );
    return _getRow(id, authorId, isAdmin: false)!;
  }

  List<Map<String, dynamic>> listPublished({int limit = 50, int offset = 0}) {
    final rows = db.db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE a.status = ? '
      'ORDER BY a.updated_at DESC '
      'LIMIT ? OFFSET ?',
      ['approved', limit.clamp(1, 100), offset.clamp(0, 10000)],
    );
    return rows.map(_mapPublic).toList();
  }

  List<Map<String, dynamic>> listMine(String authorId) {
    final rows = db.db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE a.author_id = ? '
      'ORDER BY a.updated_at DESC',
      [authorId],
    );
    return rows.map(_mapOwn).toList();
  }

  List<Map<String, dynamic>> listPending() {
    final rows = db.db.select(
      'SELECT a.*, u.display_name AS author_name, u.login AS author_login '
      'FROM user_articles a '
      'JOIN users u ON u.id = a.author_id '
      'WHERE a.status = ? '
      'ORDER BY a.created_at ASC',
      ['pending'],
    );
    return rows.map(_mapOwn).toList();
  }

  Map<String, dynamic>? get({
    required String articleId,
    required String viewerId,
    required bool isAdmin,
  }) {
    return _getRow(articleId, viewerId, isAdmin: isAdmin);
  }

  Map<String, dynamic> approve({
    required String articleId,
    required String adminId,
  }) {
    final row = _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['status'] != 'pending') throw ArticleException('invalid_status');

    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'UPDATE user_articles SET status = ?, moderated_at = ?, moderated_by = ?, '
      'reject_reason = NULL, updated_at = ? WHERE id = ?',
      ['approved', now, adminId, now, articleId],
    );
    db.audit(
      action: 'article_approve',
      userId: adminId,
      meta: {'articleId': articleId},
    );
    return _getRow(articleId, adminId, isAdmin: true)!;
  }

  Map<String, dynamic> update({
    required String authorId,
    required String articleId,
    required String title,
    required String body,
  }) {
    final row = _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['author_id'] != authorId) throw ArticleException('forbidden');
    if (row['status'] != 'pending') throw ArticleException('invalid_status');

    final t = title.trim();
    final b = body.trim();
    if (t.length < minTitle) throw ArticleException('title_too_short');
    if (t.length > maxTitle) throw ArticleException('title_too_long');
    if (b.length < minBody) throw ArticleException('body_too_short');
    if (b.length > maxBody) throw ArticleException('body_too_long');

    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'UPDATE user_articles SET title = ?, body = ?, updated_at = ? WHERE id = ?',
      [t, b, now, articleId],
    );
    db.audit(
      action: 'article_update',
      userId: authorId,
      meta: {'articleId': articleId},
    );
    return _getRow(articleId, authorId, isAdmin: false)!;
  }

  void delete({
    required String authorId,
    required String articleId,
  }) {
    final row = _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['author_id'] != authorId) throw ArticleException('forbidden');
    final status = row['status'] as String;
    if (status != 'pending' && status != 'rejected') {
      throw ArticleException('invalid_status');
    }

    db.db.execute('DELETE FROM user_articles WHERE id = ?', [articleId]);
    db.audit(
      action: 'article_delete',
      userId: authorId,
      meta: {'articleId': articleId},
    );
  }

  Map<String, dynamic> reject({
    required String articleId,
    required String adminId,
    String? reason,
  }) {
    final row = _rawRow(articleId);
    if (row == null) throw ArticleException('not_found');
    if (row['status'] != 'pending') throw ArticleException('invalid_status');

    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'UPDATE user_articles SET status = ?, moderated_at = ?, moderated_by = ?, '
      'reject_reason = ?, updated_at = ? WHERE id = ?',
      ['rejected', now, adminId, reason?.trim(), now, articleId],
    );
    db.audit(
      action: 'article_reject',
      userId: adminId,
      meta: {'articleId': articleId, 'reason': reason},
    );
    return _getRow(articleId, adminId, isAdmin: true)!;
  }

  bool isAdmin(String userId) {
    final rows = db.db.select(
      'SELECT is_admin FROM users WHERE id = ?',
      [userId],
    );
    if (rows.isEmpty) return false;
    return (rows.first['is_admin'] as int? ?? 0) == 1;
  }

  bool isAdminLogin(String login) {
    final admins = db.meta('admin_logins', fallback: 'admin');
    final set = admins
        .split(',')
        .map((s) => s.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toSet();
    return set.contains(login.trim().toLowerCase());
  }

  Map<String, dynamic>? _getRow(
    String articleId,
    String viewerId, {
    required bool isAdmin,
  }) {
    final row = _rawRow(articleId);
    if (row == null) return null;

    final status = row['status'] as String;
    final authorId = row['author_id'] as String;
    final canView = status == 'approved' ||
        authorId == viewerId ||
        isAdmin;
    if (!canView) return null;

    final users = db.db.select(
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

    if (status != 'approved' && authorId != viewerId && !isAdmin) {
      return null;
    }
    return mapped;
  }

  Map<String, Object?>? _rawRow(String articleId) {
    final rows = db.db.select(
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
        'createdAt': row['created_at'],
        'updatedAt': row['updated_at'],
        'moderatedAt': row['moderated_at'],
      };
}

class ArticleException implements Exception {
  ArticleException(this.code);
  final String code;

  @override
  String toString() => code;
}
