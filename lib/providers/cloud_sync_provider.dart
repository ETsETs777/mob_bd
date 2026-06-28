// =============================================================================
// EcoPulse · lib/providers/cloud_sync_provider.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Состояние cloud sync (файл через Drive/Telegram и т.д.).
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/backup_service.dart';
import '../core/utils/cloud_sync.dart';
import '../data/services/cache_service.dart';

/// Состояние cloud sync для UI.
class CloudSyncState {
  const CloudSyncState({
    required this.meta,
    required this.currentFingerprint,
    required this.pending,
  });

  final CloudSyncMeta meta;
  final String currentFingerprint;
  final CloudSyncPendingState pending;
}

/// Riverpod-провайдер cloud sync.
final cloudSyncProvider =
    NotifierProvider<CloudSyncNotifier, CloudSyncState>(CloudSyncNotifier.new);

/// Notifier метаданных синхронизации.
class CloudSyncNotifier extends Notifier<CloudSyncState> {
  static const cacheKey = 'cloud_sync_meta';

  @override
  CloudSyncState build() => _computeState(_loadMeta());

  CloudSyncMeta _loadMeta() {
    return decodeCloudSyncMeta(CacheService.instance.getString(cacheKey));
  }

  Future<void> _persist(CloudSyncMeta meta) async {
    await CacheService.instance.putString(cacheKey, encodeCloudSyncMeta(meta));
    state = _computeState(meta);
  }

  CloudSyncState _computeState(CloudSyncMeta meta) {
    final current = buildCurrentSyncSnapshot().fingerprint;
    return CloudSyncState(
      meta: meta,
      currentFingerprint: current,
      pending: pendingState(meta: meta, currentFingerprint: current),
    );
  }

  /// Пересчитать fingerprint после изменения данных.
  void refresh() {
    state = _computeState(state.meta);
  }

  /// Отметить успешный export в облако (файл отправлен).
  Future<void> markSyncOut() async {
    final snapshot = buildCurrentSyncSnapshot();
    await _persist(
      state.meta.copyWith(
        lastSyncOutAt: DateTime.now(),
        syncOutFingerprint: snapshot.fingerprint,
      ),
    );
  }

  /// Импорт JSON из облака/файла.
  Future<int> importFromJson(String raw) async {
    final payload = BackupService.instance.parseJson(raw);
    final remote = CloudSyncSnapshot(
      fingerprint: backupFingerprint(raw),
      exportedAt: payload.exportedAt,
      payload: payload,
    );

    if (!isRemoteSnapshotNewer(remote: remote, meta: state.meta)) {
      throw CloudSyncException('remote_not_newer');
    }

    final count = await BackupService.instance.restore(payload);
    await _persist(
      state.meta.copyWith(
        lastSyncInAt: DateTime.now(),
        lastRemoteExportedAt: payload.exportedAt,
        lastRemoteFingerprint: remote.fingerprint,
        syncOutFingerprint: remote.fingerprint,
        lastSyncOutAt: DateTime.now(),
      ),
    );
    return count;
  }

  String exportJson() => BackupService.instance.exportJson();
}

/// Ошибка cloud sync.
class CloudSyncException implements Exception {
  CloudSyncException(this.code);
  final String code;

  @override
  String toString() => code;
}
