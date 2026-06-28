// =============================================================================
// EcoPulse · lib/core/services/biometric_auth_service.dart
// Автор: Цымбал Е. В.
// Дата: 28.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: biometric_auth_service.
// =============================================================================

import 'package:local_auth/local_auth.dart';

/// Сервис [BiometricAuthService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
class BiometricAuthService {
/// Создаёт [BiometricAuthService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  BiometricAuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

/// Поле [_auth] класса [BiometricAuthService].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  final LocalAuthentication _auth;

/// Метод [isDeviceSupported] класса [BiometricAuthService].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  Future<bool> isDeviceSupported() => _auth.isDeviceSupported();

/// Метод [getAvailableBiometrics] класса [BiometricAuthService].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  Future<List<BiometricType>> getAvailableBiometrics() =>
      _auth.getAvailableBiometrics();

/// Метод [isAvailable] класса [BiometricAuthService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  Future<bool> isAvailable() async {
    if (!await _auth.isDeviceSupported()) return false;
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

/// Метод [authenticate] класса [BiometricAuthService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
