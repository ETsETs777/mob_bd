import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/cloud/cloud_config.dart';

enum CloudAuthStatus {
  disabled,
  signedOut,
  signedIn,
}

class CloudAuthState {
  const CloudAuthState({
    this.status = CloudAuthStatus.disabled,
    this.email = '',
    this.userId = '',
    this.busy = false,
    this.error = '',
  });

  final CloudAuthStatus status;
  final String email;
  final String userId;
  final bool busy;
  final String error;

  bool get isConfigured => status != CloudAuthStatus.disabled;
  bool get isSignedIn => status == CloudAuthStatus.signedIn;

  CloudAuthState copyWith({
    CloudAuthStatus? status,
    String? email,
    String? userId,
    bool? busy,
    String? error,
  }) {
    return CloudAuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      busy: busy ?? this.busy,
      error: error ?? this.error,
    );
  }
}

final cloudAuthProvider =
    NotifierProvider<CloudAuthNotifier, CloudAuthState>(CloudAuthNotifier.new);

class CloudAuthNotifier extends Notifier<CloudAuthState> {
  StreamSubscription<AuthState>? _sub;

  @override
  CloudAuthState build() {
    if (!CloudConfig.isConfigured) {
      return const CloudAuthState(status: CloudAuthStatus.disabled);
    }

    ref.onDispose(() => _sub?.cancel());
    _listenAuth();

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return const CloudAuthState(status: CloudAuthStatus.signedOut);
    }
    return CloudAuthState(
      status: CloudAuthStatus.signedIn,
      email: session.user.email ?? '',
      userId: session.user.id,
    );
  }

  void _listenAuth() {
    _sub?.cancel();
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session == null) {
        state = state.copyWith(
          status: CloudAuthStatus.signedOut,
          email: '',
          userId: '',
          busy: false,
        );
      } else {
        state = CloudAuthState(
          status: CloudAuthStatus.signedIn,
          email: session.user.email ?? '',
          userId: session.user.id,
        );
      }
    });
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(busy: true, error: '');
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      state = state.copyWith(busy: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(busy: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(busy: true, error: '');
    try {
      await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      state = state.copyWith(busy: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(busy: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(busy: true, error: '');
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: CloudConfig.url,
      );
      state = state.copyWith(busy: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(busy: false, error: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    state = state.copyWith(
      status: CloudAuthStatus.signedOut,
      email: '',
      userId: '',
    );
  }
}
