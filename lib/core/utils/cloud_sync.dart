// =============================================================================
// EcoPulse · lib/core/utils/cloud_sync.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Fingerprint и сравнение снимков для cloud sync.
// =============================================================================

import 'dart:convert';

import '../services/backup_service.dart';

/// Метаданные последней синхронизации.
class CloudSyncMeta {
  const CloudSyncMeta({
    this.lastSyncOutAt,
    this.lastSyncInAt,
    this.syncOutFingerprint,
    this.lastRemoteExportedAt,
    this.lastRemoteFingerprint,
  });

  final DateTime? lastSyncOutAt;
  final DateTime? lastSyncInAt;
  final String? syncOutFingerprint;
  final DateTime? lastRemoteExportedAt;
  final String? lastRemoteFingerprint;

  bool get hasSyncedOut => lastSyncOutAt != null;

  CloudSyncMeta copyWith({
    DateTime? lastSyncOutAt,
    DateTime? lastSyncInAt,
    String? syncOutFingerprint,
    DateTime? lastRemoteExportedAt,
    String? lastRemoteFingerprint,
  }) {
    return CloudSyncMeta(
      lastSyncOutAt: lastSyncOutAt ?? this.lastSyncOutAt,
      lastSyncInAt: lastSyncInAt ?? this.lastSyncInAt,
      syncOutFingerprint: syncOutFingerprint ?? this.syncOutFingerprint,
      lastRemoteExportedAt: lastRemoteExportedAt ?? this.lastRemoteExportedAt,
      lastRemoteFingerprint:
          lastRemoteFingerprint ?? this.lastRemoteFingerprint,
    );
  }

  Map<String, dynamic> toJson() => {
        'lastSyncOutAt': lastSyncOutAt?.toIso8601String(),
        'lastSyncInAt': lastSyncInAt?.toIso8601String(),
        'syncOutFingerprint': syncOutFingerprint,
        'lastRemoteExportedAt': lastRemoteExportedAt?.toIso8601String(),
        'lastRemoteFingerprint': lastRemoteFingerprint,
      };

  factory CloudSyncMeta.fromJson(Map<String, dynamic> json) {
    return CloudSyncMeta(
      lastSyncOutAt: _parse(json['lastSyncOutAt']),
      lastSyncInAt: _parse(json['lastSyncInAt']),
      syncOutFingerprint: json['syncOutFingerprint'] as String?,
      lastRemoteExportedAt: _parse(json['lastRemoteExportedAt']),
      lastRemoteFingerprint: json['lastRemoteFingerprint'] as String?,
    );
  }

  static DateTime? _parse(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

/// Статус локальных изменений относительно последнего sync out.
enum CloudSyncPendingState { synced, localChanges, neverSynced }

/// Снимок для сравнения при импорте.
class CloudSyncSnapshot {
  const CloudSyncSnapshot({
    required this.fingerprint,
    required this.exportedAt,
    required this.payload,
  });

  final String fingerprint;
  final DateTime exportedAt;
  final BackupPayload payload;
}

/// Fingerprint JSON-бэкапа (djb2, hex).
String backupFingerprint(String exportJson) {
  var hash = 5381;
  for (final unit in exportJson.codeUnits) {
    hash = ((hash << 5) + hash + unit) & 0x7fffffff;
  }
  return hash.toRadixString(16);
}

/// Текущий снимок данных приложения.
CloudSyncSnapshot buildCurrentSyncSnapshot() {
  final json = BackupService.instance.exportJson();
  final payload = BackupService.instance.parseJson(json);
  return CloudSyncSnapshot(
    fingerprint: backupFingerprint(json),
    exportedAt: payload.exportedAt,
    payload: payload,
  );
}

/// Есть ли несинхронизированные локальные изменения.
CloudSyncPendingState pendingState({
  required CloudSyncMeta meta,
  required String currentFingerprint,
}) {
  if (!meta.hasSyncedOut) return CloudSyncPendingState.neverSynced;
  if (meta.syncOutFingerprint == currentFingerprint) {
    return CloudSyncPendingState.synced;
  }
  return CloudSyncPendingState.localChanges;
}

/// Импорт новее локального sync in?
bool isRemoteSnapshotNewer({
  required CloudSyncSnapshot remote,
  required CloudSyncMeta meta,
}) {
  if (meta.lastSyncInAt == null) return true;
  return remote.exportedAt.isAfter(meta.lastSyncInAt!);
}

String encodeCloudSyncMeta(CloudSyncMeta meta) =>
    jsonEncode(meta.toJson());

CloudSyncMeta decodeCloudSyncMeta(String? raw) {
  if (raw == null || raw.isEmpty) return const CloudSyncMeta();
  try {
    return CloudSyncMeta.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return const CloudSyncMeta();
  }
}

String syncFileName(DateTime at) {
  final stamp =
      '${at.year}${at.month.toString().padLeft(2, '0')}${at.day.toString().padLeft(2, '0')}';
  return 'ecopulse-sync-$stamp.json';
}
