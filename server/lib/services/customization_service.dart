import 'dart:convert';

import '../db/database.dart';

class CustomizationService {
  CustomizationService(this.db);

  final AppDatabase db;

  Future<Map<String, dynamic>?> get(String userId) async {
    final rows = await db.select(
      'SELECT payload_json FROM user_customizations WHERE user_id = ?',
      [userId],
    );
    if (rows.isEmpty) return null;
    final raw = rows.first['payload_json'] as String;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(
    String userId,
    Map<String, dynamic> customization,
  ) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final fingerprint = customization['fingerprint'] as String? ?? '';
    final payload = jsonEncode(customization);

    await db.execute(
      'INSERT INTO user_customizations(user_id, payload_json, fingerprint, updated_at) '
      'VALUES(?, ?, ?, ?) '
      'ON CONFLICT(user_id) DO UPDATE SET '
      'payload_json = excluded.payload_json, '
      'fingerprint = excluded.fingerprint, '
      'updated_at = excluded.updated_at',
      [userId, payload, fingerprint, now],
    );

    await db.audit(
      action: 'save_customization',
      userId: userId,
      meta: {'fingerprint': fingerprint},
    );

    return {'customization': customization, 'updatedAt': now};
  }
}
