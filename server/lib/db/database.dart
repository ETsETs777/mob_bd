import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

import '../config.dart';
import 'schema.dart';

class AppDatabase {
  AppDatabase(this.config) : db = _open(config) {
    _migrate();
  }

  final ServerConfig config;
  final Database db;
  static const _uuid = Uuid();

  static Database _open(ServerConfig config) {
    final dir = Directory(config.dataDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final path = p.join(config.dataDir, 'ecopulse.db');
    return sqlite3.open(path);
  }

  void _migrate() {
    for (final stmt in schemaSql.split(';')) {
      final sql = stmt.trim();
      if (sql.isEmpty) continue;
      db.execute(sql);
    }
    _ensureColumn('users', 'is_admin', 'INTEGER NOT NULL DEFAULT 0');
    for (final entry in defaultMeta.entries) {
      db.execute(
        "INSERT OR IGNORE INTO server_meta(key, value) VALUES(?, ?)",
        [entry.key, entry.value],
      );
    }
  }

  String meta(String key, {String fallback = ''}) {
    final rs = db.select('SELECT value FROM server_meta WHERE key = ?', [key]);
    if (rs.isEmpty) return fallback;
    return rs.first['value'] as String;
  }

  void setMeta(String key, String value) {
    db.execute(
      'INSERT INTO server_meta(key, value) VALUES(?, ?) '
      'ON CONFLICT(key) DO UPDATE SET value = excluded.value',
      [key, value],
    );
  }

  void audit({
    required String action,
    String? userId,
    Map<String, dynamic>? meta,
  }) {
    final id = _uuid.v4();
    db.execute(
      'INSERT INTO audit_logs(id, user_id, action, meta_json, created_at) '
      'VALUES(?, ?, ?, ?, ?)',
      [
        id,
        userId,
        action,
        meta == null ? null : jsonEncode(meta),
        DateTime.now().toUtc().toIso8601String(),
      ],
    );
  }

  void close() => db.dispose();

  void _ensureColumn(String table, String column, String definition) {
    final info = db.select('PRAGMA table_info($table)');
    final exists = info.any((row) => row['name'] == column);
    if (!exists) {
      db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
    }
  }
}
