import 'package:postgres/postgres.dart';

import '../config.dart';
import 'db_backend.dart';
import 'db_executor.dart';
import 'sql_utils.dart';

class PostgresExecutor implements DbExecutor {
  PostgresExecutor(this._connection);

  final Connection _connection;

  static Future<PostgresExecutor> open(ServerConfig config) async {
    final url = config.databaseUrl;
    if (url == null || url.trim().isEmpty) {
      throw ArgumentError(
        'ECOPULSE_DATABASE_URL is required when ECOPULSE_DB_BACKEND=postgres',
      );
    }
    final connection = await Connection.openFromUrl(url.trim());
    return PostgresExecutor(connection);
  }

  @override
  DatabaseBackend get backend => DatabaseBackend.postgres;

  @override
  Future<List<Map<String, Object?>>> select(
    String sql, [
    List<Object?> params = const [],
  ]) async {
    final pgSql = SqlUtils.toPostgresPlaceholders(sql);
    final result = await _connection.execute(pgSql, parameters: params);
    return [
      for (final row in result)
        SqlUtils.normalizeRow(
          row.toColumnMap().map((key, value) => MapEntry(key, value)),
        ),
    ];
  }

  @override
  Future<void> execute(
    String sql, [
    List<Object?> params = const [],
  ]) async {
    final pgSql = SqlUtils.toPostgresPlaceholders(sql);
    await _connection.execute(
      pgSql,
      parameters: params,
      ignoreRows: true,
    );
  }

  @override
  Future<bool> columnExists(String table, String column) async {
    final rows = await select(
      'SELECT 1 FROM information_schema.columns '
      'WHERE table_schema = ? AND table_name = ? AND column_name = ? '
      'LIMIT 1',
      ['public', table, column],
    );
    return rows.isNotEmpty;
  }

  @override
  Future<void> close() async {
    await _connection.close();
  }
}
