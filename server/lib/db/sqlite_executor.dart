import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../config.dart';
import 'db_backend.dart';
import 'db_executor.dart';
import 'sql_utils.dart';

class SqliteExecutor implements DbExecutor {
  SqliteExecutor(this._db);

  final Database _db;

  static SqliteExecutor open(ServerConfig config) {
    final dir = Directory(config.dataDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final path = p.join(config.dataDir, 'ecopulse.db');
    return SqliteExecutor(sqlite3.open(path));
  }

  @override
  DatabaseBackend get backend => DatabaseBackend.sqlite;

  @override
  Future<List<Map<String, Object?>>> select(
    String sql, [
    List<Object?> params = const [],
  ]) async {
    final rows = _db.select(sql, params);
    return rows
        .map((row) => SqlUtils.normalizeRow(Map<String, Object?>.from(row)))
        .toList();
  }

  @override
  Future<void> execute(
    String sql, [
    List<Object?> params = const [],
  ]) async {
    _db.execute(sql, params);
  }

  @override
  Future<bool> columnExists(String table, String column) async {
    final info = _db.select('PRAGMA table_info($table)');
    return info.any((row) => row['name'] == column);
  }

  @override
  Future<void> close() async {
    _db.dispose();
  }

  /// Online snapshot into a new SQLite file ([path]).
  Future<void> snapshotTo(String path) async {
    await execute('PRAGMA wal_checkpoint(TRUNCATE)');
    final dest = sqlite3.open(path);
    try {
      await _db.backup(dest).drain();
    } finally {
      dest.dispose();
    }
  }

  /// Replace live DB contents from a SQLite backup file ([path]).
  Future<void> restoreFrom(String path) async {
    final source = sqlite3.open(path);
    try {
      await source.backup(_db).drain();
    } finally {
      source.dispose();
    }
    await execute('PRAGMA wal_checkpoint(TRUNCATE)');
  }
}
