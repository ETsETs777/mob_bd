import 'dart:async';
import 'dart:io';

import '../config.dart';
import '../db/database.dart';
import 'backup_service.dart';

/// Периодические снимки БД по расписанию из [ServerConfig.backupIntervalHours].
class BackupScheduler {
  BackupScheduler({
    required this.config,
    required this.db,
  }) : _backup = BackupService(config, db);

  final ServerConfig config;
  final AppDatabase db;
  final BackupService _backup;

  Timer? _timer;
  bool _running = false;

  void start() {
    if (config.backupIntervalHours <= 0) return;
    if (_timer != null) return;

    final interval = Duration(hours: config.backupIntervalHours);
    _timer = Timer.periodic(interval, (_) => _tick());
    stderr.writeln(
      'Backup scheduler: every ${config.backupIntervalHours}h → ${config.backupDir}',
    );
    unawaited(_tick(initial: true));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick({bool initial = false}) async {
    if (_running) return;
    _running = true;
    try {
      if (initial) {
        final latest = await _backup.list();
        if (latest.isNotEmpty) {
          final last = DateTime.tryParse(latest.first['createdAt'] as String? ?? '');
          if (last != null) {
            final age = DateTime.now().toUtc().difference(last);
            if (age < Duration(hours: config.backupIntervalHours)) {
              return;
            }
          }
        }
      }
      await _backup.create(source: 'scheduled');
      stderr.writeln('Backup snapshot created (${config.databaseBackend.name})');
    } on BackupException catch (e) {
      stderr.writeln('Scheduled backup skipped: ${e.code}');
    } catch (e) {
      stderr.writeln('Scheduled backup failed: $e');
    } finally {
      _running = false;
    }
  }
}
