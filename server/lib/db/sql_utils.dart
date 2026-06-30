/// Shared SQL helpers for SQLite and PostgreSQL backends.
class SqlUtils {
  SqlUtils._();

  /// Converts `?` placeholders to `$1`, `$2`, … for PostgreSQL.
  static String toPostgresPlaceholders(String sql) {
    var index = 0;
    return sql.replaceAllMapped('?', (_) {
      index += 1;
      return '\$$index';
    });
  }

  static int asInt(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is BigInt) return value.toInt();
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static Map<String, Object?> normalizeRow(Map<String, Object?> row) {
    return row.map((key, value) {
      if (value is BigInt) return MapEntry(key, value.toInt());
      return MapEntry(key, value);
    });
  }
}
