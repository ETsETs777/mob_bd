import 'dart:convert';

import '../db/database.dart';

class LocalDataService {
  LocalDataService(this.db);

  final AppDatabase db;

  Map<String, dynamic>? get(String userId) {
    final rows = db.db.select(
      'SELECT payload_json FROM user_local_data WHERE user_id = ?',
      [userId],
    );
    if (rows.isEmpty) return null;
    final raw = rows.first['payload_json'] as String;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Map<String, dynamic> put(String userId, Map<String, dynamic> localData) {
    final now = DateTime.now().toUtc().toIso8601String();
    final fingerprint = localData['fingerprint'] as String? ?? '';
    final payload = jsonEncode(localData);

    db.db.execute(
      'INSERT INTO user_local_data(user_id, payload_json, fingerprint, updated_at) '
      'VALUES(?, ?, ?, ?) '
      'ON CONFLICT(user_id) DO UPDATE SET '
      'payload_json = excluded.payload_json, '
      'fingerprint = excluded.fingerprint, '
      'updated_at = excluded.updated_at',
      [userId, payload, fingerprint, now],
    );

    db.audit(
      action: 'save_local_data',
      userId: userId,
      meta: {'fingerprint': fingerprint},
    );

    return {'localData': localData, 'updatedAt': now};
  }
}
