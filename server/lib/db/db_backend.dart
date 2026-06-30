enum DatabaseBackend {
  sqlite,
  postgres;

  static DatabaseBackend parse(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'postgres':
      case 'postgresql':
      case 'pg':
        return DatabaseBackend.postgres;
      default:
        return DatabaseBackend.sqlite;
    }
  }
}
