import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../db/database.dart';

class ThreadService {
  ThreadService(this.db);

  final AppDatabase db;
  final _uuid = const Uuid();

  List<Map<String, dynamic>> listThreads(String userId) {
    final rows = db.db.select('''
SELECT t.id, t.type, t.created_at,
  (SELECT text FROM messages m WHERE m.thread_id = t.id ORDER BY m.created_at DESC LIMIT 1) AS last_text,
  (SELECT created_at FROM messages m WHERE m.thread_id = t.id ORDER BY m.created_at DESC LIMIT 1) AS last_at
FROM threads t
INNER JOIN thread_members tm ON tm.thread_id = t.id
WHERE tm.user_id = ?
ORDER BY COALESCE(last_at, t.created_at) DESC
''', [userId]);

    return rows.map((row) {
      final type = row['type'] as String;
      String title;
      String? peerId;
      if (type == 'self') {
        title = 'Себе';
      } else {
        final peers = db.db.select('''
SELECT u.id, u.login, u.display_name, u.avatar_emoji
FROM thread_members tm
INNER JOIN users u ON u.id = tm.user_id
WHERE tm.thread_id = ? AND tm.user_id != ?
LIMIT 1
''', [row['id'], userId]);
        if (peers.isEmpty) {
          title = 'Direct';
        } else {
          final p = peers.first;
          peerId = p['id'] as String;
          final name = (p['display_name'] as String).trim();
          title = name.isEmpty ? p['login'] as String : name;
        }
      }

      return {
        'id': row['id'],
        'type': type,
        'title': title,
        'peerProfileId': peerId,
        'lastText': row['last_text'],
        'lastAt': row['last_at'],
        'createdAt': row['created_at'],
      };
    }).toList();
  }

  Map<String, dynamic> ensureSelfThread(String userId) {
    final existing = db.db.select('''
SELECT t.id FROM threads t
INNER JOIN thread_members tm ON tm.thread_id = t.id
WHERE t.type = 'self' AND tm.user_id = ?
LIMIT 1
''', [userId]);
    if (existing.isNotEmpty) {
      return {'id': existing.first['id'], 'type': 'self', 'title': 'Себе'};
    }

    final threadId = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'INSERT INTO threads(id, type, created_at) VALUES(?, ?, ?)',
      [threadId, 'self', now],
    );
    db.db.execute(
      'INSERT INTO thread_members(thread_id, user_id) VALUES(?, ?)',
      [threadId, userId],
    );
    db.audit(action: 'create_self_thread', userId: userId, meta: {'threadId': threadId});
    return {'id': threadId, 'type': 'self', 'title': 'Себе'};
  }

  Map<String, dynamic> createDirect({
    required String userId,
    String? targetProfileId,
    bool self = false,
  }) {
    if (self) {
      return ensureSelfThread(userId);
    }
    if (targetProfileId == null || targetProfileId.isEmpty) {
      throw ThreadException('target_required');
    }
    if (targetProfileId == userId) {
      return ensureSelfThread(userId);
    }

    final targetRows = db.db.select(
      'SELECT id, login, display_name FROM users WHERE id = ?',
      [targetProfileId],
    );
    if (targetRows.isEmpty) {
      throw ThreadException('user_not_found');
    }

    final existing = db.db.select('''
SELECT t.id FROM threads t
WHERE t.type = 'direct'
AND EXISTS (SELECT 1 FROM thread_members WHERE thread_id = t.id AND user_id = ?)
AND EXISTS (SELECT 1 FROM thread_members WHERE thread_id = t.id AND user_id = ?)
LIMIT 1
''', [userId, targetProfileId]);

    if (existing.isNotEmpty) {
      final id = existing.first['id'] as String;
      final target = targetRows.first;
      final name = (target['display_name'] as String).trim();
      return {
        'id': id,
        'type': 'direct',
        'title': name.isEmpty ? target['login'] : name,
        'peerProfileId': targetProfileId,
      };
    }

    final threadId = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'INSERT INTO threads(id, type, created_at) VALUES(?, ?, ?)',
      [threadId, 'direct', now],
    );
    db.db.execute(
      'INSERT INTO thread_members(thread_id, user_id) VALUES(?, ?)',
      [threadId, userId],
    );
    db.db.execute(
      'INSERT INTO thread_members(thread_id, user_id) VALUES(?, ?)',
      [threadId, targetProfileId],
    );
    db.audit(
      action: 'create_direct_thread',
      userId: userId,
      meta: {'threadId': threadId, 'peer': targetProfileId},
    );

    final target = targetRows.first;
    final name = (target['display_name'] as String).trim();
    return {
      'id': threadId,
      'type': 'direct',
      'title': name.isEmpty ? target['login'] : name,
      'peerProfileId': targetProfileId,
    };
  }

  bool isMember(String threadId, String userId) {
    final rows = db.db.select(
      'SELECT 1 FROM thread_members WHERE thread_id = ? AND user_id = ?',
      [threadId, userId],
    );
    return rows.isNotEmpty;
  }

  List<Map<String, dynamic>> listMessages(
    String threadId,
    String userId, {
    int limit = 50,
    String? before,
  }) {
    if (!isMember(threadId, userId)) {
      throw ThreadException('forbidden');
    }

    final params = <Object>[threadId];
    var sql = '''
SELECT m.id, m.thread_id, m.sender_id, m.text, m.created_at,
       u.login AS sender_login, u.display_name AS sender_name
FROM messages m
INNER JOIN users u ON u.id = m.sender_id
WHERE m.thread_id = ?
''';
    if (before != null && before.isNotEmpty) {
      sql += ' AND m.created_at < ?';
      params.add(before);
    }
    sql += ' ORDER BY m.created_at DESC LIMIT ?';
    params.add(limit);

    final rows = db.db.select(sql, params);
    return rows.reversed.map((row) {
      return {
        'id': row['id'],
        'threadId': row['thread_id'],
        'senderId': row['sender_id'],
        'senderLogin': row['sender_login'],
        'senderName': row['sender_name'],
        'text': row['text'],
        'createdAt': row['created_at'],
        'isMine': row['sender_id'] == userId,
      };
    }).toList();
  }

  Map<String, dynamic> sendMessage({
    required String threadId,
    required String userId,
    required String text,
  }) {
    if (!isMember(threadId, userId)) {
      throw ThreadException('forbidden');
    }
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ThreadException('empty_message');
    }

    final id = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'INSERT INTO messages(id, thread_id, sender_id, text, created_at) VALUES(?, ?, ?, ?, ?)',
      [id, threadId, userId, trimmed, now],
    );
    db.audit(
      action: 'send_message',
      userId: userId,
      meta: {'threadId': threadId, 'messageId': id},
    );

    final users = db.db.select(
      'SELECT login, display_name FROM users WHERE id = ?',
      [userId],
    );
    final u = users.first;
    return {
      'id': id,
      'threadId': threadId,
      'senderId': userId,
      'senderLogin': u['login'],
      'senderName': u['display_name'],
      'text': trimmed,
      'createdAt': now,
      'isMine': true,
    };
  }

  List<Map<String, dynamic>> searchUsers(String query, {String? excludeUserId}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final rows = db.db.select('''
SELECT id, login, display_name, avatar_emoji
FROM users
WHERE login LIKE ? OR id LIKE ?
LIMIT 20
''', ['%$q%', '%$q%']);

    return rows
        .where((r) => r['id'] != excludeUserId)
        .map((r) => {
              'profileId': r['id'],
              'login': r['login'],
              'displayName': r['display_name'],
              'avatarEmoji': r['avatar_emoji'],
            })
        .toList();
  }
}

class ThreadException implements Exception {
  ThreadException(this.code);
  final String code;

  @override
  String toString() => code;
}

String jsonResponse(Object data) => jsonEncode(data);

Map<String, dynamic> parseJsonBody(String body) {
  if (body.isEmpty) return {};
  return jsonDecode(body) as Map<String, dynamic>;
}
