import 'db_backend.dart';

/// Database access facade used by [AppDatabase] and services.
abstract class DbExecutor {
  DatabaseBackend get backend;

  Future<List<Map<String, Object?>>> select(
    String sql, [
    List<Object?> params = const [],
  ]);

  Future<void> execute(
    String sql, [
    List<Object?> params = const [],
  ]);

  Future<bool> columnExists(String table, String column);

  Future<void> close();
}
