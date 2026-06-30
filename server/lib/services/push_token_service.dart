/// Хранение FCM-токенов пользователей.
library;

import '../db/database.dart';

class PushTokenService {
  PushTokenService(this.db);

  final AppDatabase db;

  Future<void> upsert({
    required String userId,
    required String token,
    required String platform,
  }) async {
    final trimmed = token.trim();
    if (trimmed.isEmpty) return;
    final now = DateTime.now().toUtc().toIso8601String();
    await db.execute(
      'INSERT INTO push_tokens(user_id, token, platform, updated_at) '
      'VALUES(?, ?, ?, ?) '
      'ON CONFLICT(user_id, token) DO UPDATE SET platform = excluded.platform, '
      'updated_at = excluded.updated_at',
      [userId, trimmed, platform, now],
    );
  }

  Future<void> remove({required String userId, required String token}) async {
    await db.execute(
      'DELETE FROM push_tokens WHERE user_id = ? AND token = ?',
      [userId, token.trim()],
    );
  }

  Future<List<String>> tokensForUser(String userId) async {
    final rows = await db.select(
      'SELECT token FROM push_tokens WHERE user_id = ?',
      [userId],
    );
    return rows.map((r) => r['token'] as String).toList();
  }

  Future<List<String>> tokensForModerators({String? excludeUserId}) async {
    final rows = excludeUserId == null
        ? await db.select(
            'SELECT pt.token FROM push_tokens pt '
            'JOIN users u ON u.id = pt.user_id '
            "WHERE u.role IN ('moderator', 'admin')",
          )
        : await db.select(
            'SELECT pt.token FROM push_tokens pt '
            'JOIN users u ON u.id = pt.user_id '
            "WHERE u.role IN ('moderator', 'admin') AND u.id != ?",
            [excludeUserId],
          );
    return rows.map((r) => r['token'] as String).toList();
  }

  @Deprecated('Use tokensForModerators')
  Future<List<String>> tokensForAdmins({String? excludeUserId}) =>
      tokensForModerators(excludeUserId: excludeUserId);
}
