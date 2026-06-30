/// Админ-операции: дашборд, пользователи, аудит, настройки сервера.
library;

import '../auth/staff_role.dart';
import '../db/database.dart';
import '../db/sql_utils.dart';

class AdminService {
  AdminService(this.db);

  final AppDatabase db;

  Future<Map<String, dynamic>> dashboard() async {
    final users = SqlUtils.asInt(
      (await db.select('SELECT COUNT(*) AS c FROM users')).first['c'],
    );
    final pending = SqlUtils.asInt(
      (await db.select(
        "SELECT COUNT(*) AS c FROM user_articles WHERE status = 'pending'",
      ))
          .first['c'],
    );
    final approved = SqlUtils.asInt(
      (await db.select(
        "SELECT COUNT(*) AS c FROM user_articles WHERE status = 'approved'",
      ))
          .first['c'],
    );
    final rejected = SqlUtils.asInt(
      (await db.select(
        "SELECT COUNT(*) AS c FROM user_articles WHERE status = 'rejected'",
      ))
          .first['c'],
    );
    final threads = SqlUtils.asInt(
      (await db.select('SELECT COUNT(*) AS c FROM threads')).first['c'],
    );
    final messages = SqlUtils.asInt(
      (await db.select('SELECT COUNT(*) AS c FROM messages')).first['c'],
    );

    final recentAudit = await listAudit(limit: 10);

    return {
      'users': users,
      'articles': {
        'pending': pending,
        'approved': approved,
        'rejected': rejected,
        'total': pending + approved + rejected,
      },
      'threads': threads,
      'messages': messages,
      'recentAudit': recentAudit,
    };
  }

  Future<List<Map<String, dynamic>>> listUsers({String? q, int limit = 100}) async {
    final query = q?.trim();
    final rows = query == null || query.isEmpty
        ? await db.select(
            'SELECT id, login, display_name, avatar_emoji, is_admin, role, created_at '
            'FROM users ORDER BY created_at DESC LIMIT ?',
            [limit.clamp(1, 500)],
          )
        : await db.select(
            'SELECT id, login, display_name, avatar_emoji, is_admin, role, created_at '
            'FROM users WHERE login LIKE ? OR display_name LIKE ? '
            'ORDER BY created_at DESC LIMIT ?',
            ['%$query%', '%$query%', limit.clamp(1, 500)],
          );

    final out = <Map<String, dynamic>>[];
    for (final row in rows) {
      out.add(await _mapUserRow(row));
    }
    return out;
  }

  Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? role,
    bool? isAdmin,
    String? displayName,
  }) async {
    final rows = await db.select('SELECT * FROM users WHERE id = ?', [userId]);
    if (rows.isEmpty) throw AdminException('not_found');

    if (displayName != null) {
      await db.execute(
        'UPDATE users SET display_name = ? WHERE id = ?',
        [displayName.trim(), userId],
      );
    }

    String? nextRole;
    if (role != null) {
      nextRole = StaffRole.normalize(role);
      await db.execute(
        'UPDATE users SET role = ?, is_admin = ? WHERE id = ?',
        [nextRole, StaffRole.isFullAdmin(nextRole) ? 1 : 0, userId],
      );
    } else if (isAdmin != null) {
      nextRole = isAdmin ? StaffRole.admin : StaffRole.none;
      await db.execute(
        'UPDATE users SET role = ?, is_admin = ? WHERE id = ?',
        [nextRole, isAdmin ? 1 : 0, userId],
      );
    }

    await db.audit(
      action: 'admin_user_update',
      userId: userId,
      meta: {'role': nextRole, 'isAdmin': isAdmin, 'displayName': displayName},
    );

    final updated = await db.select(
      'SELECT id, login, display_name, avatar_emoji, is_admin, role, created_at '
      'FROM users WHERE id = ?',
      [userId],
    );
    if (updated.isEmpty) throw AdminException('not_found');
    return _mapUserRow(updated.first);
  }

  Future<Map<String, dynamic>> _mapUserRow(Map<String, Object?> row) async {
    final resolvedRole = StaffRole.resolve(
      role: row['role'] as String?,
      legacyIsAdmin: row['is_admin'] as int?,
    );
    final articleCount = SqlUtils.asInt(
      (await db.select(
        'SELECT COUNT(*) AS c FROM user_articles WHERE author_id = ?',
        [row['id']],
      ))
          .first['c'],
    );
    return {
      'id': row['id'],
      'login': row['login'],
      'displayName': row['display_name'],
      'avatarEmoji': row['avatar_emoji'],
      'role': resolvedRole,
      'isAdmin': StaffRole.isFullAdmin(resolvedRole),
      'canModerate': StaffRole.canModerate(resolvedRole),
      'canEditContent': StaffRole.canEditContent(resolvedRole),
      'isStaff': StaffRole.isStaff(resolvedRole),
      'createdAt': row['created_at'],
      'articleCount': articleCount,
    };
  }

  Future<List<Map<String, dynamic>>> listAudit({int limit = 50, int offset = 0}) async {
    final rows = await db.select(
      'SELECT a.*, u.login AS user_login, u.display_name AS user_name '
      'FROM audit_logs a '
      'LEFT JOIN users u ON u.id = a.user_id '
      'ORDER BY a.created_at DESC '
      'LIMIT ? OFFSET ?',
      [limit.clamp(1, 200), offset.clamp(0, 10000)],
    );
    return rows
        .map(
          (row) => {
            'id': row['id'],
            'action': row['action'],
            'userId': row['user_id'],
            'userLogin': row['user_login'],
            'userName': row['user_name'],
            'meta': row['meta_json'],
            'createdAt': row['created_at'],
          },
        )
        .toList();
  }

  Future<Map<String, dynamic>> getSettings() async => {
        'minAppVersion': await db.meta('min_app_version', fallback: '1.0.44'),
        'serverVersion': await db.meta('server_version', fallback: '1.0.0'),
        'adminLogins': await db.meta('admin_logins', fallback: 'admin'),
      };

  Future<Map<String, dynamic>> updateSettings({
    String? minAppVersion,
    String? adminLogins,
  }) async {
    if (minAppVersion != null && minAppVersion.trim().isNotEmpty) {
      await db.setMeta('min_app_version', minAppVersion.trim());
    }
    if (adminLogins != null && adminLogins.trim().isNotEmpty) {
      await db.setMeta('admin_logins', adminLogins.trim());
    }
    await db.audit(action: 'admin_settings_update');
    return getSettings();
  }
}

class AdminException implements Exception {
  AdminException(this.code);
  final String code;

  @override
  String toString() => code;
}
