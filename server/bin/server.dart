import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:ecopulse_server/config.dart';
import 'package:ecopulse_server/db/database.dart';
import 'package:ecopulse_server/api/router.dart';

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
  final jwtSecret = Platform.environment['ECOPULSE_JWT_SECRET'] ??
      'ecopulse-dev-secret-change-in-prod';

  final config = ServerConfig(
    host: host,
    port: port,
    jwtSecret: jwtSecret,
    dataDir: dataDir,
  );

  final db = AppDatabase(config);
  final server = await startServer(db: db, config: config);

  stdout.writeln('');
  stdout.writeln('EcoPulse Home Server v${ServerConfig.serverVersion}');
  stdout.writeln('Listening on http://${server.address.host}:${server.port}');
  stdout.writeln('LAN URL example: http://<your-ip>:$port');
  stdout.writeln('Health: http://127.0.0.1:$port/v1/health');
  stdout.writeln('Data: $dataDir/ecopulse.db');
  stdout.writeln('');
  stdout.writeln('Press Ctrl+C to stop.');
}
