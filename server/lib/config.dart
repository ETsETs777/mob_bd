import 'package:path/path.dart' as p;

import 'db/db_backend.dart';

class ServerConfig {
  ServerConfig({
    required this.host,
    required this.port,
    required this.jwtSecret,
    required this.dataDir,
    this.databaseBackend = DatabaseBackend.sqlite,
    this.databaseUrl,
    this.backupIntervalHours = 24,
    this.backupMaxCount = 14,
    this.rateLimitEnabled = true,
    this.rateAuthMax = 15,
    this.rateAuthWindowMinutes = 15,
    this.rateArticleMax = 5,
    this.rateArticleWindowMinutes = 60,
    this.rateMessageMax = 60,
    this.rateMessageWindowMinutes = 1,
  });

  final String host;
  final int port;
  final String jwtSecret;
  final String dataDir;
  final DatabaseBackend databaseBackend;
  final String? databaseUrl;

  /// Automatic backup interval; `0` disables the scheduler.
  final int backupIntervalHours;

  /// Maximum number of backup files to retain.
  final int backupMaxCount;

  final bool rateLimitEnabled;
  final int rateAuthMax;
  final int rateAuthWindowMinutes;
  final int rateArticleMax;
  final int rateArticleWindowMinutes;
  final int rateMessageMax;
  final int rateMessageWindowMinutes;

  bool get isPostgres => databaseBackend == DatabaseBackend.postgres;

  String get backupDir => p.join(dataDir, 'backups');

  String get sqliteDbPath => p.join(dataDir, 'ecopulse.db');

  static const serverVersion = '1.0.0';
  static const minAppVersion = '1.0.44';
  static const apiVersion = 1;
  static const tokenTtlDays = 7;
}
