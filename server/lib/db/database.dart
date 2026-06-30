import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../config.dart';
import 'db_backend.dart';
import 'db_executor.dart';
import 'postgres_executor.dart';
import 'schema.dart';
import 'sqlite_executor.dart';

class AppDatabase {
  AppDatabase._(this.config, this._executor);

  final ServerConfig config;
  final DbExecutor _executor;
  static const _uuid = Uuid();

  DatabaseBackend get backend => _executor.backend;

  SqliteExecutor? get sqliteExecutor =>
      _executor is SqliteExecutor ? _executor : null;

  static Future<AppDatabase> open(ServerConfig config) async {
    final DbExecutor executor;
    if (config.databaseBackend == DatabaseBackend.postgres) {
      executor = await PostgresExecutor.open(config);
    } else {
      executor = SqliteExecutor.open(config);
    }
    final db = AppDatabase._(config, executor);
    await db._migrate();
    return db;
  }

  Future<List<Map<String, Object?>>> select(
    String sql, [
    List<Object?> params = const [],
  ]) =>
      _executor.select(sql, params);

  Future<void> execute(
    String sql, [
    List<Object?> params = const [],
  ]) =>
      _executor.execute(sql, params);

  Future<void> _migrate() async {
    for (final stmt in schemaSql.split(';')) {
      final sql = stmt.trim();
      if (sql.isEmpty) continue;
      await execute(sql);
    }
    await _ensureColumn('users', 'is_admin', 'INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn('users', 'role', "TEXT NOT NULL DEFAULT ''");
    await execute(
      "UPDATE users SET role = 'admin' WHERE is_admin = 1 AND (role IS NULL OR role = '')",
    );
    await _ensureColumn('user_articles', 'cover_url', 'TEXT');
    await _ensureColumn('user_articles', 'publish_at', 'TEXT');
    await _ensureColumn('user_articles', 'category', "TEXT NOT NULL DEFAULT 'other'");
    await _ensureColumn('user_articles', 'tags_json', "TEXT NOT NULL DEFAULT '[]'");
    await _ensureColumn('user_articles', 'featured', 'INTEGER NOT NULL DEFAULT 0');
    for (final entry in defaultMeta.entries) {
      await execute(
        'INSERT INTO server_meta(key, value) VALUES(?, ?) '
        'ON CONFLICT(key) DO NOTHING',
        [entry.key, entry.value],
      );
    }
  }

  Future<String> meta(String key, {String fallback = ''}) async {
    final rs = await select('SELECT value FROM server_meta WHERE key = ?', [key]);
    if (rs.isEmpty) return fallback;
    return rs.first['value'] as String;
  }

  Future<void> setMeta(String key, String value) async {
    await execute(
      'INSERT INTO server_meta(key, value) VALUES(?, ?) '
      'ON CONFLICT(key) DO UPDATE SET value = excluded.value',
      [key, value],
    );
  }

  Future<void> audit({
    required String action,
    String? userId,
    Map<String, dynamic>? meta,
  }) async {
    final id = _uuid.v4();
    await execute(
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

  Future<void> close() => _executor.close();

  Future<void> _ensureColumn(String table, String column, String definition) async {
    if (await _executor.columnExists(table, column)) return;
    await execute('ALTER TABLE $table ADD COLUMN $column $definition');
  }
}

/// Builds [ServerConfig] from CLI args and environment variables.
ServerConfig loadServerConfig({
  required String host,
  required int port,
  required String dataDir,
}) {
  final jwtSecret = Platform.environment['ECOPULSE_JWT_SECRET'] ??
      'ecopulse-dev-secret-change-in-prod';
  final databaseBackend =
      DatabaseBackend.parse(Platform.environment['ECOPULSE_DB_BACKEND']);
  final databaseUrl = Platform.environment['ECOPULSE_DATABASE_URL'];

  final backupIntervalHours = int.tryParse(
        Platform.environment['ECOPULSE_BACKUP_INTERVAL_HOURS'] ?? '24',
      ) ??
      24;
  final backupMaxCount = int.tryParse(
        Platform.environment['ECOPULSE_BACKUP_MAX_COUNT'] ?? '14',
      ) ??
      14;

  final rateLimitRaw = Platform.environment['ECOPULSE_RATE_LIMIT'] ?? '1';
  final rateLimitEnabled = rateLimitRaw.trim() != '0';
  final rateAuthMax = int.tryParse(
        Platform.environment['ECOPULSE_RATE_AUTH_MAX'] ?? '15',
      ) ??
      15;
  final rateAuthWindowMinutes = int.tryParse(
        Platform.environment['ECOPULSE_RATE_AUTH_WINDOW_MIN'] ?? '15',
      ) ??
      15;
  final rateArticleMax = int.tryParse(
        Platform.environment['ECOPULSE_RATE_ARTICLE_MAX'] ?? '5',
      ) ??
      5;
  final rateArticleWindowMinutes = int.tryParse(
        Platform.environment['ECOPULSE_RATE_ARTICLE_WINDOW_MIN'] ?? '60',
      ) ??
      60;
  final rateMessageMax = int.tryParse(
        Platform.environment['ECOPULSE_RATE_MESSAGE_MAX'] ?? '60',
      ) ??
      60;
  final rateMessageWindowMinutes = int.tryParse(
        Platform.environment['ECOPULSE_RATE_MESSAGE_WINDOW_MIN'] ?? '1',
      ) ??
      1;

  if (databaseBackend == DatabaseBackend.postgres &&
      (databaseUrl == null || databaseUrl.trim().isEmpty)) {
    stderr.writeln(
      'Error: ECOPULSE_DATABASE_URL is required when ECOPULSE_DB_BACKEND=postgres',
    );
    exit(1);
  }

  return ServerConfig(
    host: host,
    port: port,
    jwtSecret: jwtSecret,
    dataDir: dataDir,
    databaseBackend: databaseBackend,
    databaseUrl: databaseUrl?.trim(),
    backupIntervalHours: backupIntervalHours.clamp(0, 24 * 365),
    backupMaxCount: backupMaxCount.clamp(1, 500),
    rateLimitEnabled: rateLimitEnabled,
    rateAuthMax: rateAuthMax.clamp(1, 1000),
    rateAuthWindowMinutes: rateAuthWindowMinutes.clamp(1, 24 * 60),
    rateArticleMax: rateArticleMax.clamp(1, 1000),
    rateArticleWindowMinutes: rateArticleWindowMinutes.clamp(1, 24 * 60),
    rateMessageMax: rateMessageMax.clamp(1, 10000),
    rateMessageWindowMinutes: rateMessageWindowMinutes.clamp(1, 60),
  );
}
