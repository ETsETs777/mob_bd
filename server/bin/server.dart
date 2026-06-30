import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:ecopulse_server/config.dart';
import 'package:ecopulse_server/db/database.dart';
import 'package:ecopulse_server/api/admin_static.dart';
import 'package:ecopulse_server/api/openapi_handler.dart';
import 'package:ecopulse_server/api/router.dart';
import 'package:ecopulse_server/services/backup_scheduler.dart';

Future<void> main(List<String> args) async {
  var host = '0.0.0.0';
  var port = 8081;
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--host' && i + 1 < args.length) host = args[i + 1];
    if (args[i] == '--port' && i + 1 < args.length) {
      port = int.tryParse(args[i + 1]) ?? 8081;
    }
  }

  final root = Directory.current.path;
  final dataDir = p.join(root, 'data');
  final fcmServerKey = Platform.environment['ECOPULSE_FCM_SERVER_KEY'] ?? '';

  final config = loadServerConfig(
    host: host,
    port: port,
    dataDir: dataDir,
  );

  final db = await AppDatabase.open(config);
  BackupScheduler(config: config, db: db).start();
  final webAdminDir = resolveWebAdminDir(root);
  final openapiDir = resolveOpenApiDir(root);
  final server = await startServer(
    db: db,
    config: config,
    webAdminDir: webAdminDir,
    openapiDir: openapiDir,
    fcmServerKey: fcmServerKey,
  );

  stdout.writeln('');
  stdout.writeln('EcoPulse Home Server v${ServerConfig.serverVersion}');
  stdout.writeln('Listening on http://${server.address.host}:${server.port}');
  stdout.writeln('LAN URL example: http://<your-ip>:$port');
  stdout.writeln('Health: http://127.0.0.1:$port/v1/health');
  stdout.writeln('API docs: http://127.0.0.1:$port/v1/docs/');
  stdout.writeln('Admin panel: http://127.0.0.1:$port/admin/');
  if (fcmServerKey.isNotEmpty) {
    stdout.writeln('FCM push: enabled');
  } else {
    stdout.writeln('FCM push: disabled (set ECOPULSE_FCM_SERVER_KEY)');
  }
  if (config.isPostgres) {
    stdout.writeln('Database: PostgreSQL (${config.databaseUrl})');
  } else {
    stdout.writeln('Database: SQLite ($dataDir/ecopulse.db');
  }
  if (config.backupIntervalHours > 0) {
    stdout.writeln(
      'Backups: every ${config.backupIntervalHours}h → ${config.backupDir} '
      '(max ${config.backupMaxCount})',
    );
  } else {
    stdout.writeln('Backups: scheduler disabled (ECOPULSE_BACKUP_INTERVAL_HOURS=0)');
  }
  if (config.rateLimitEnabled) {
    stdout.writeln(
      'Rate limits: auth ${config.rateAuthMax}/${config.rateAuthWindowMinutes}min · '
      'articles ${config.rateArticleMax}/${config.rateArticleWindowMinutes}min · '
      'messages ${config.rateMessageMax}/${config.rateMessageWindowMinutes}min',
    );
  } else {
    stdout.writeln('Rate limits: disabled (ECOPULSE_RATE_LIMIT=0)');
  }
  stdout.writeln('');
  stdout.writeln('Press Ctrl+C to stop.');
}
