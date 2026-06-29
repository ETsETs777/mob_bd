import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/customization_cloud_sync.dart';
import '../../core/customization/customization_sync.dart';
import '../../data/models/user_customization.dart';
import '../../data/services/cache_service.dart';
import '../profile/home_server_provider.dart';
import 'customization_provider.dart';

class CustomizationServerSyncState {
  const CustomizationServerSyncState({
    this.meta = const CustomizationServerSyncMeta(),
    this.busy = false,
    this.lastError = '',
    this.remoteFingerprint,
    this.remoteUpdatedAt,
  });

  final CustomizationServerSyncMeta meta;
  final bool busy;
  final String lastError;
  final String? remoteFingerprint;
  final DateTime? remoteUpdatedAt;

  CustomizationServerSyncState copyWith({
    CustomizationServerSyncMeta? meta,
    bool? busy,
    String? lastError,
    String? remoteFingerprint,
    DateTime? remoteUpdatedAt,
    bool clearRemote = false,
  }) {
    return CustomizationServerSyncState(
      meta: meta ?? this.meta,
      busy: busy ?? this.busy,
      lastError: lastError ?? this.lastError,
      remoteFingerprint:
          clearRemote ? null : remoteFingerprint ?? this.remoteFingerprint,
      remoteUpdatedAt:
          clearRemote ? null : remoteUpdatedAt ?? this.remoteUpdatedAt,
    );
  }
}

final customizationServerSyncProvider = NotifierProvider<
    CustomizationServerSyncNotifier, CustomizationServerSyncState>(
  CustomizationServerSyncNotifier.new,
);

class CustomizationServerSyncNotifier
    extends Notifier<CustomizationServerSyncState> {
  static const cacheKey = 'customization_server_sync_meta';

  @override
  CustomizationServerSyncState build() {
    final raw = CacheService.instance.getString(cacheKey);
    return CustomizationServerSyncState(
      meta: decodeCustomizationServerSyncMeta(raw),
    );
  }

  CustomizationServerSyncStatus status(UserCustomization local) {
    final auth = ref.read(homeServerProvider).auth;
    return resolveCustomizationSyncStatus(
      isLoggedIn: auth.isLoggedIn,
      meta: state.meta,
      localFingerprint: customizationFingerprint(local),
      remoteFingerprint: state.remoteFingerprint,
    );
  }

  Future<void> refreshRemote() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(clearRemote: true, lastError: 'not_logged_in');
      return;
    }

    state = state.copyWith(busy: true, lastError: '');
    try {
      final client = ref.read(homeServerClientProvider);
      final remote = await client.fetchCustomization(auth);
      if (remote == null) {
        state = state.copyWith(
          busy: false,
          clearRemote: true,
        );
        return;
      }
      final fingerprint = remote['fingerprint'] as String? ??
          customizationFingerprint(UserCustomization.fromJson(remote));
      final updatedRaw = remote['updatedAt'] as String?;
      state = state.copyWith(
        busy: false,
        remoteFingerprint: fingerprint,
        remoteUpdatedAt: updatedRaw == null
            ? null
            : DateTime.tryParse(updatedRaw)?.toUtc(),
      );
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
    } catch (_) {
      state = state.copyWith(busy: false, lastError: 'network_error');
    }
  }

  Future<bool> pushToServer(WidgetRef widgetRef) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return false;

    final local = ref.read(customizationProvider);
    final payload = customizationPayloadForServer(local);

    state = state.copyWith(busy: true, lastError: '');
    try {
      final client = ref.read(homeServerClientProvider);
      final result = await client.putCustomization(auth, payload);
      final now = DateTime.now().toUtc();
      final fingerprint = payload['fingerprint'] as String;
      final updatedRaw = result['updatedAt'] as String?;
      final meta = state.meta.copyWith(
        lastPushAt: now,
        lastServerFingerprint: fingerprint,
        lastServerUpdatedAt: updatedRaw == null
            ? local.meta.updatedAt
            : DateTime.tryParse(updatedRaw)?.toUtc(),
      );
      await _persist(meta);
      state = state.copyWith(
        busy: false,
        meta: meta,
        remoteFingerprint: fingerprint,
        remoteUpdatedAt: meta.lastServerUpdatedAt,
      );
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
      return false;
    } catch (_) {
      state = state.copyWith(busy: false, lastError: 'network_error');
      return false;
    }
  }

  Future<bool> pullFromServer(WidgetRef widgetRef) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return false;

    state = state.copyWith(busy: true, lastError: '');
    try {
      final client = ref.read(homeServerClientProvider);
      final remote = await client.fetchCustomization(auth);
      if (remote == null) {
        state = state.copyWith(busy: false, lastError: 'not_found');
        return false;
      }

      final config = UserCustomization.fromJson(remote);
      await ref.read(customizationProvider.notifier).update(config);
      await CustomizationSync.applyLegacy(widgetRef, config);

      final fingerprint = remote['fingerprint'] as String? ??
          customizationFingerprint(config);
      final updatedRaw = remote['updatedAt'] as String?;
      final now = DateTime.now().toUtc();
      final meta = state.meta.copyWith(
        lastPullAt: now,
        lastServerFingerprint: fingerprint,
        lastServerUpdatedAt: updatedRaw == null
            ? config.meta.updatedAt
            : DateTime.tryParse(updatedRaw)?.toUtc(),
      );
      await _persist(meta);
      state = state.copyWith(
        busy: false,
        meta: meta,
        remoteFingerprint: fingerprint,
        remoteUpdatedAt: meta.lastServerUpdatedAt,
      );
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
      return false;
    } catch (_) {
      state = state.copyWith(busy: false, lastError: 'network_error');
      return false;
    }
  }

  Future<bool> smartSync(WidgetRef widgetRef) async {
    await refreshRemote();
    if (state.lastError.isNotEmpty) return false;

    final local = ref.read(customizationProvider);
    final localFp = customizationFingerprint(local);
    final remoteFp = state.remoteFingerprint;

    if (remoteFp == null) {
      return pushToServer(widgetRef);
    }
    if (remoteFp == localFp) {
      return true;
    }

    final remoteAt = state.remoteUpdatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (local.meta.updatedAt.isAfter(remoteAt)) {
      return pushToServer(widgetRef);
    }
    return pullFromServer(widgetRef);
  }

  Future<void> _persist(CustomizationServerSyncMeta meta) async {
    await CacheService.instance.putString(
      cacheKey,
      encodeCustomizationServerSyncMeta(meta),
    );
  }
}
