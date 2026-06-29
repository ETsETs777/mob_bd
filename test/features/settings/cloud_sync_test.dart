// =============================================================================
// EcoPulse · test/cloud_sync_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: cloud_sync fingerprint и pending state.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/cloud_sync.dart';
import 'package:ecopulse/core/services/backup_service.dart';

void main() {
  test('backupFingerprint is stable for same json', () {
    const json = '{"app":"EcoPulse","data":{"watchlist":"[]"}}';
    expect(backupFingerprint(json), backupFingerprint(json));
  });

  test('backupFingerprint changes when payload changes', () {
    const a = '{"data":{"watchlist":"[]"}}';
    const b = '{"data":{"watchlist":"[\\"x\\"]"}}';
    expect(backupFingerprint(a), isNot(backupFingerprint(b)));
  });

  test('pendingState detects local changes', () {
    const meta = CloudSyncMeta(
      lastSyncOutAt: null,
      syncOutFingerprint: 'abc',
    );
    expect(
      pendingState(meta: meta, currentFingerprint: 'abc'),
      CloudSyncPendingState.neverSynced,
    );

    final synced = meta.copyWith(
      lastSyncOutAt: DateTime(2026, 6, 1),
      syncOutFingerprint: 'abc',
    );
    expect(
      pendingState(meta: synced, currentFingerprint: 'abc'),
      CloudSyncPendingState.synced,
    );
    expect(
      pendingState(meta: synced, currentFingerprint: 'def'),
      CloudSyncPendingState.localChanges,
    );
  });

  test('isRemoteSnapshotNewer compares exportedAt', () {
    final remote = CloudSyncSnapshot(
      fingerprint: 'x',
      exportedAt: DateTime(2026, 6, 10),
      payload: BackupPayload(version: 1, exportedAt: DateTime(2026, 6, 10), data: {}),
    );
    const meta = CloudSyncMeta(lastSyncInAt: null);
    expect(isRemoteSnapshotNewer(remote: remote, meta: meta), isTrue);

    final olderMeta = CloudSyncMeta(lastSyncInAt: DateTime(2026, 6, 15));
    expect(isRemoteSnapshotNewer(remote: remote, meta: olderMeta), isFalse);
  });

  test('CloudSyncMeta json roundtrip', () {
    final original = CloudSyncMeta(
      lastSyncOutAt: DateTime(2026, 6, 1, 12, 0),
      syncOutFingerprint: 'deadbeef',
    );
    final restored = decodeCloudSyncMeta(encodeCloudSyncMeta(original));
    expect(restored.syncOutFingerprint, 'deadbeef');
    expect(restored.lastSyncOutAt, original.lastSyncOutAt);
  });
}
