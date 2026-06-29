import 'dart:convert';

import '../db/database.dart';

class CustomizationService {
  CustomizationService(this.db);

  final AppDatabase db;

  Map<String, dynamic>? get(String userId) {
    final rows = db.db.select(
      'SELECT payload_json FROM user_customizations WHERE user_id = ?',
      [userId],
    );
    if (rows.isEmpty) return null;
    final raw = rows.first['payload_json'] as String;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Map<String, dynamic> put(String userId, Map<String, dynamic> customization) {
    final now = DateTime.now().toUtc().toIso8601String();
    final fingerprint = customization['fingerprint'] as String? ?? '';
    final payload = jsonEncode(customization);

    db.db.execute(
      'INSERT INTO user_customizations(user_id, payload_json, fingerprint, updated_at) '
      'VALUES(?, ?, ?, ?) '
      'ON CONFLICT(user_id) DO UPDATE SET '
      'payload_json = excluded.payload_json, '
      'fingerprint = excluded.fingerprint, '
      'updated_at = excluded.updated_at',
      [userId, payload, fingerprint, now],
    );

    db.audit(
      action: 'save_customization',
      userId: userId,
      meta: {'fingerprint': fingerprint},
    );

    return {'customization': customization, 'updatedAt': now};
  }
}
