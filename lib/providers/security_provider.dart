// =============================================================================
// EcoPulse · lib/providers/security_provider.dart
// Автор: Цымбал Е. В.
// Дата: 24.05.2026
// Riverpod state: провайдеры и notifiers. Файл: security_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/biometric_auth_service.dart';
import '../data/services/cache_service.dart';

/// Riverpod-провайдер [biometricAuthServiceProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

/// Riverpod-провайдер [biometricAvailableProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  return ref.read(biometricAuthServiceProvider).isAvailable();
});

/// Top-level переменная [pinLength].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
const pinLength = 4;

/// Функция [hashPin] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
String hashPin(String pin) {
  var hash = 5381;
  for (final unit in pin.codeUnits) {
    hash = ((hash << 5) + hash + unit) & 0x7FFFFFFF;
  }
  return hash.toRadixString(16);
}

/// Класс [SecuritySettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
class SecuritySettings {
/// Создаёт [SecuritySettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  const SecuritySettings({
    required this.pinEnabled,
    this.pinHash,
    this.biometricEnabled = false,
  });

/// Поле [pinEnabled] класса [SecuritySettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final bool pinEnabled;
/// Поле [pinHash] класса [SecuritySettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final String? pinHash;
/// Поле [biometricEnabled] класса [SecuritySettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final bool biometricEnabled;

/// Метод [copyWith] класса [SecuritySettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  SecuritySettings copyWith({
    bool? pinEnabled,
    String? pinHash,
    bool? biometricEnabled,
  }) {
    return SecuritySettings(
      pinEnabled: pinEnabled ?? this.pinEnabled,
      pinHash: pinHash ?? this.pinHash,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

/// Riverpod-провайдер [securitySettingsProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final securitySettingsProvider =
    NotifierProvider<SecuritySettingsNotifier, SecuritySettings>(
  SecuritySettingsNotifier.new,
);

/// Riverpod AsyncNotifier [SecuritySettingsNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class SecuritySettingsNotifier extends Notifier<SecuritySettings> {
/// Поле [_enabledKey] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  static const _enabledKey = 'pin_enabled';
/// Поле [_hashKey] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  static const _hashKey = 'pin_hash';
/// Поле [_biometricKey] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  static const _biometricKey = 'biometric_enabled';

/// Отрисовывает UI [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  @override
  SecuritySettings build() {
    final enabled = CacheService.instance.getString(_enabledKey) == 'true';
    final hash = CacheService.instance.getString(_hashKey);
    final biometric =
        CacheService.instance.getString(_biometricKey) == 'true';
    return SecuritySettings(
      pinEnabled: enabled,
      pinHash: hash,
      biometricEnabled: biometric && enabled,
    );
  }

/// Метод [verify] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  bool verify(String pin) {
    final hash = state.pinHash;
    if (hash == null) return false;
    return hashPin(pin) == hash;
  }

/// Метод [enablePin] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  Future<bool> enablePin(String pin) async {
    if (pin.length != pinLength) return false;
    final hash = hashPin(pin);
    state = SecuritySettings(pinEnabled: true, pinHash: hash);
    await CacheService.instance.putString(_enabledKey, 'true');
    await CacheService.instance.putString(_hashKey, hash);
    return true;
  }

/// Метод [disablePin] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  Future<bool> disablePin(String pin) async {
    if (!verify(pin)) return false;
    state = const SecuritySettings(pinEnabled: false);
    await CacheService.instance.putString(_enabledKey, 'false');
    await CacheService.instance.deleteKey(_hashKey);
    await CacheService.instance.deleteKey(_biometricKey);
    ref.read(appUnlockedProvider.notifier).unlock();
    return true;
  }

/// Метод [changePin] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<bool> changePin(String oldPin, String newPin) async {
    if (!verify(oldPin) || newPin.length != pinLength) return false;
    final hash = hashPin(newPin);
    state = state.copyWith(pinHash: hash);
    await CacheService.instance.putString(_hashKey, hash);
    return true;
  }

/// Метод [setBiometricEnabled] класса [SecuritySettingsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> setBiometricEnabled(bool enabled) async {
    state = state.copyWith(biometricEnabled: enabled && state.pinEnabled);
    await CacheService.instance.putString(
      _biometricKey,
      state.biometricEnabled ? 'true' : 'false',
    );
  }
}

/// Riverpod-провайдер [appUnlockedProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
final appUnlockedProvider =
    NotifierProvider<AppUnlockedNotifier, bool>(AppUnlockedNotifier.new);

/// Riverpod AsyncNotifier [AppUnlockedNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
class AppUnlockedNotifier extends Notifier<bool> {
/// Отрисовывает UI [AppUnlockedNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  @override
  bool build() {
    final settings = ref.watch(securitySettingsProvider);
    return !settings.pinEnabled;
  }

/// Метод [unlock] класса [AppUnlockedNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  void unlock() => state = true;

/// Метод [lock] класса [AppUnlockedNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  void lock() {
    if (ref.read(securitySettingsProvider).pinEnabled) {
      state = false;
    }
  }
}
