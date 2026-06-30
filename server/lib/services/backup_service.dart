/// Снимки БД Home Server: SQLite (online backup API) и PostgreSQL (pg_dump).
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../config.dart';
import '../db/database.dart';

class BackupService {
  BackupService(this.config, this.db);

  final ServerConfig config;
  final AppDatabase db;

  static const manifestName = 'manifest.json';

  String get _manifestPath => p.join(config.backupDir, manifestName);

  Future<Map<String, dynamic>> status() async {
    final entries = await list();
    return {
      'backend': config.databaseBackend.name,
      'backupDir': config.backupDir,
      'intervalHours': config.backupIntervalHours,
      'maxCount': config.backupMaxCount,
      'count': entries.length,
      'latest': entries.isEmpty ? null : entries.first,
    };
  }

  Future<List<Map<String, dynamic>>> list() async {
    final manifest = await _readManifest();
    final entries = (manifest['entries'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    entries.sort(
      (a, b) => (b['createdAt'] as String).compareTo(a['createdAt'] as String),
    );
    return entries;
  }

  Future<Map<String, dynamic>> create({
    required String source,
    String? userId,
  }) async {
    final dir = Directory(config.backupDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final stamp = _timestamp();
    final id = stamp;
    late final String filename;
    late final String type;

    if (config.isPostgres) {
      filename = 'ecopulse_$stamp.sql';
      type = 'sql';
      await _pgDump(p.join(config.backupDir, filename));
    } else {
      filename = 'ecopulse_$stamp.db';
      type = 'sqlite';
      final executor = db.sqliteExecutor;
      if (executor == null) {
        throw BackupException('sqlite_executor_unavailable');
      }
      await executor.snapshotTo(p.join(config.backupDir, filename));
    }

    final file = File(p.join(config.backupDir, filename));
    if (!file.existsSync()) {
      throw BackupException('backup_file_missing');
    }

    final entry = {
      'id': id,
      'filename': filename,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'sizeBytes': file.lengthSync(),
      'backend': config.databaseBackend.name,
      'type': type,
      'source': source,
    };

    final manifest = await _readManifest();
    final entries = (manifest['entries'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    entries.add(entry);
    manifest['entries'] = entries;
    await _writeManifest(manifest);
    await _prune(entries);
    await db.audit(
      action: 'backup_create',
      userId: userId,
      meta: {'backupId': id, 'source': source, 'filename': filename},
    );

    return entry;
  }

  Future<File> fileFor(String id) async {
    final entry = await _find(id);
    final file = File(p.join(config.backupDir, entry['filename'] as String));
    if (!file.existsSync()) throw BackupException('not_found');
    return file;
  }

  Future<Map<String, dynamic>> restore({
    required String id,
    String? userId,
  }) async {
    final entry = await _find(id);
    final path = p.join(config.backupDir, entry['filename'] as String);
    final type = entry['type'] as String? ?? 'sqlite';

    if (type == 'sqlite') {
      if (config.isPostgres) {
        throw BackupException('backend_mismatch');
      }
      final executor = db.sqliteExecutor;
      if (executor == null) {
        throw BackupException('sqlite_executor_unavailable');
      }
      await executor.restoreFrom(path);
    } else {
      if (!config.isPostgres) {
        throw BackupException('backend_mismatch');
      }
      await _pgRestore(path);
    }

    await db.audit(
      action: 'backup_restore',
      userId: userId,
      meta: {'backupId': id, 'filename': entry['filename']},
    );

    return {
      'ok': true,
      'backupId': id,
      'restoredAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<void> delete({
    required String id,
    String? userId,
  }) async {
    final entry = await _find(id);
    final file = File(p.join(config.backupDir, entry['filename'] as String));
    if (file.existsSync()) file.deleteSync();

    final manifest = await _readManifest();
    final entries = (manifest['entries'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .where((e) => e['id'] != id)
        .toList();
    manifest['entries'] = entries;
    await _writeManifest(manifest);

    await db.audit(
      action: 'backup_delete',
      userId: userId,
      meta: {'backupId': id},
    );
  }

  Future<Map<String, dynamic>> _find(String id) async {
    for (final entry in await list()) {
      if (entry['id'] == id) return entry;
    }
    throw BackupException('not_found');
  }

  Future<void> _prune(List<Map<String, dynamic>> entries) async {
    if (entries.length <= config.backupMaxCount) return;

    entries.sort(
      (a, b) => (a['createdAt'] as String).compareTo(b['createdAt'] as String),
    );
    while (entries.length > config.backupMaxCount) {
      final oldest = entries.removeAt(0);
      final file = File(
        p.join(config.backupDir, oldest['filename'] as String),
      );
      if (file.existsSync()) file.deleteSync();
    }

    final manifest = await _readManifest();
    manifest['entries'] = entries;
    await _writeManifest(manifest);
  }

  Future<Map<String, dynamic>> _readManifest() async {
    final file = File(_manifestPath);
    if (!file.existsSync()) {
      return {'entries': <Map<String, dynamic>>[]};
    }
    try {
      final raw = jsonDecode(await file.readAsString());
      if (raw is! Map<String, dynamic>) {
        return {'entries': <Map<String, dynamic>>[]};
      }
      return raw;
    } catch (_) {
      return {'entries': <Map<String, dynamic>>[]};
    }
  }

  Future<void> _writeManifest(Map<String, dynamic> manifest) async {
    final dir = Directory(config.backupDir);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    await File(_manifestPath).writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifest),
    );
  }

  String _timestamp() {
    final now = DateTime.now().toUtc();
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${now.year}${pad(now.month)}${pad(now.day)}_'
        '${pad(now.hour)}${pad(now.minute)}${pad(now.second)}';
  }

  Future<void> _pgDump(String outputPath) async {
    final url = config.databaseUrl;
    if (url == null || url.trim().isEmpty) {
      throw BackupException('database_url_missing');
    }
    final result = await Process.run(
      'pg_dump',
      ['--clean', '--if-exists', '--no-owner', '--no-acl', '--file', outputPath, url.trim()],
      runInShell: true,
    );
    if (result.exitCode != 0) {
      stderr.writeln('pg_dump failed: ${result.stderr}');
      throw BackupException('pg_dump_failed');
    }
  }

  Future<void> _pgRestore(String sqlPath) async {
    final url = config.databaseUrl;
    if (url == null || url.trim().isEmpty) {
      throw BackupException('database_url_missing');
    }
    final result = await Process.run(
      'psql',
      [url.trim(), '-v', 'ON_ERROR_STOP=1', '-f', sqlPath],
      runInShell: true,
    );
    if (result.exitCode != 0) {
      stderr.writeln('psql restore failed: ${result.stderr}');
      throw BackupException('pg_restore_failed');
    }
  }
}

class BackupException implements Exception {
  BackupException(this.code);
  final String code;

  @override
  String toString() => code;
}
