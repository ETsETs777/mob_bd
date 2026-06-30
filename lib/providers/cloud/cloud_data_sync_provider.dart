import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/cloud/cloud_config.dart';
import '../../core/utils/user_error_message.dart';
import '../../data/models/user_profile.dart';
import '../../providers/cloud/cloud_auth_provider.dart';
import '../../providers/profile/user_profile_provider.dart';
import '../../providers/watchlist_provider.dart';

class CloudDataSyncState {
  const CloudDataSyncState({
    this.busy = false,
    this.lastSyncedAt,
    this.error = '',
  });

  final bool busy;
  final DateTime? lastSyncedAt;
  final String error;

  CloudDataSyncState copyWith({
    bool? busy,
    DateTime? lastSyncedAt,
    String? error,
  }) {
    return CloudDataSyncState(
      busy: busy ?? this.busy,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      error: error ?? this.error,
    );
  }
}

final cloudDataSyncProvider =
    NotifierProvider<CloudDataSyncNotifier, CloudDataSyncState>(
  CloudDataSyncNotifier.new,
);

class CloudDataSyncNotifier extends Notifier<CloudDataSyncState> {
  static const table = 'ecopulse_user_sync';

  @override
  CloudDataSyncState build() => const CloudDataSyncState();

  Future<bool> push(WidgetRef widgetRef) async {
    if (!CloudConfig.isConfigured) return false;
    final auth = ref.read(cloudAuthProvider);
    if (!auth.isSignedIn) return false;

    state = state.copyWith(busy: true, error: '');
    try {
      final profile = widgetRef.read(userProfileProvider);
      final watchlist = widgetRef.read(watchlistProvider);
      final payload = {
        'profile': profile.toJson(),
        'watchlist': watchlist,
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
      };

      await Supabase.instance.client.from(table).upsert({
        'user_id': auth.userId,
        'payload': payload,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

      state = state.copyWith(
        busy: false,
        lastSyncedAt: DateTime.now().toUtc(),
      );
      return true;
    } on PostgrestException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(busy: false, error: userErrorMessageShort(e));
      return false;
    }
  }

  Future<bool> pull(WidgetRef widgetRef) async {
    if (!CloudConfig.isConfigured) return false;
    final auth = ref.read(cloudAuthProvider);
    if (!auth.isSignedIn) return false;

    state = state.copyWith(busy: true, error: '');
    try {
      final row = await Supabase.instance.client
          .from(table)
          .select('payload')
          .eq('user_id', auth.userId)
          .maybeSingle();

      if (row == null) {
        state = state.copyWith(busy: false);
        return true;
      }

      final payload = row['payload'] as Map<String, dynamic>? ?? {};
      final profileRaw = payload['profile'];
      if (profileRaw is Map<String, dynamic>) {
        await widgetRef
            .read(userProfileProvider.notifier)
            .update(UserProfile.fromJson(profileRaw));
      }

      final watchRaw = payload['watchlist'];
      if (watchRaw is List) {
        final keys = watchRaw.whereType<String>().toList();
        await widgetRef.read(watchlistProvider.notifier).replaceAll(keys);
      }

      state = state.copyWith(
        busy: false,
        lastSyncedAt: DateTime.now().toUtc(),
      );
      return true;
    } on PostgrestException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(busy: false, error: userErrorMessageShort(e));
      return false;
    }
  }
}
