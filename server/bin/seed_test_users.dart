import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:ecopulse_server/auth/auth_service.dart';
import 'package:ecopulse_server/auth/password_service.dart';
import 'package:ecopulse_server/config.dart';
import 'package:ecopulse_server/db/database.dart';
import 'package:ecopulse_server/services/thread_service.dart';

Future<void> main(List<String> args) async {
  final root = Directory.current.path;
  final config = ServerConfig(
    host: '127.0.0.1',
    port: 8081,
    jwtSecret: 'ecopulse-dev-secret-change-in-prod',
    dataDir: p.join(root, 'data'),
  );

  final db = AppDatabase(config);
  final auth = AuthService(db, config, PasswordService());
  final threads = ThreadService(db);

  for (final cred in [
    ('user1', 'user1pass', 'User One'),
    ('user2', 'user2pass', 'User Two'),
  ]) {
    try {
      final r = auth.register(
        login: cred.$1,
        password: cred.$2,
        displayName: cred.$3,
      );
      threads.ensureSelfThread(r.profileId);
      stdout.writeln('Created ${cred.$1} → profileId=${r.profileId}');
    } on AuthException catch (e) {
      if (e.code == 'login_taken') {
        stdout.writeln('Skip ${cred.$1} (already exists)');
      } else {
        stdout.writeln('Error ${cred.$1}: ${e.code}');
      }
    }
  }

  db.close();
  stdout.writeln('Done.');
}
