import 'dart:convert';

import '../../data/models/user_customization.dart';
import '../utils/cloud_sync.dart';

/// Fingerprint JSON кастомизации (djb2, hex).
String customizationFingerprint(UserCustomization config) {
  return backupFingerprint(jsonEncode(config.toJson()));
}

/// Метаданные синхронизации кастомизации с home server.
class CustomizationServerSyncMeta {
  const CustomizationServerSyncMeta({
    this.lastPushAt,
    this.lastPullAt,
    this.lastServerFingerprint,
    this.lastServerUpdatedAt,
  });

  final DateTime? lastPushAt;
  final DateTime? lastPullAt;
  final String? lastServerFingerprint;
  final DateTime? lastServerUpdatedAt;

  CustomizationServerSyncMeta copyWith({
    DateTime? lastPushAt,
    DateTime? lastPullAt,
    String? lastServerFingerprint,
    DateTime? lastServerUpdatedAt,
  }) {
    return CustomizationServerSyncMeta(
      lastPushAt: lastPushAt ?? this.lastPushAt,
      lastPullAt: lastPullAt ?? this.lastPullAt,
      lastServerFingerprint:
          lastServerFingerprint ?? this.lastServerFingerprint,
      lastServerUpdatedAt: lastServerUpdatedAt ?? this.lastServerUpdatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'lastPushAt': lastPushAt?.toIso8601String(),
        'lastPullAt': lastPullAt?.toIso8601String(),
        'lastServerFingerprint': lastServerFingerprint,
        'lastServerUpdatedAt': lastServerUpdatedAt?.toIso8601String(),
      };

  factory CustomizationServerSyncMeta.fromJson(Map<String, dynamic> json) {
    return CustomizationServerSyncMeta(
      lastPushAt: _parse(json['lastPushAt']),
      lastPullAt: _parse(json['lastPullAt']),
      lastServerFingerprint: json['lastServerFingerprint'] as String?,
      lastServerUpdatedAt: _parse(json['lastServerUpdatedAt']),
    );
  }

  static DateTime? _parse(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

enum CustomizationServerSyncStatus {
  notLoggedIn,
  neverSynced,
  synced,
  localNewer,
  remoteNewer,
  remoteMissing,
}

CustomizationServerSyncStatus resolveCustomizationSyncStatus({
  required bool isLoggedIn,
  required CustomizationServerSyncMeta meta,
  required String localFingerprint,
  String? remoteFingerprint,
}) {
  if (!isLoggedIn) return CustomizationServerSyncStatus.notLoggedIn;
  if (remoteFingerprint == null) {
    if (meta.lastPushAt == null && meta.lastPullAt == null) {
      return CustomizationServerSyncStatus.neverSynced;
    }
    return CustomizationServerSyncStatus.remoteMissing;
  }
  if (meta.lastServerFingerprint == localFingerprint ||
      remoteFingerprint == localFingerprint) {
    return CustomizationServerSyncStatus.synced;
  }
  if (remoteFingerprint != meta.lastServerFingerprint &&
      meta.lastServerFingerprint != localFingerprint) {
    return CustomizationServerSyncStatus.remoteNewer;
  }
  return CustomizationServerSyncStatus.localNewer;
}

String encodeCustomizationServerSyncMeta(CustomizationServerSyncMeta meta) =>
    jsonEncode(meta.toJson());

CustomizationServerSyncMeta decodeCustomizationServerSyncMeta(String? raw) {
  if (raw == null || raw.isEmpty) return const CustomizationServerSyncMeta();
  try {
    return CustomizationServerSyncMeta.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  } catch (_) {
    return const CustomizationServerSyncMeta();
  }
}

Map<String, dynamic> customizationPayloadForServer(UserCustomization config) {
  final fingerprint = customizationFingerprint(config);
  return {
    ...config.toJson(),
    'fingerprint': fingerprint,
  };
}
