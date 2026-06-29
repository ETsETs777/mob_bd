/// Лимиты Free vs EcoPulse Pro.
abstract final class ProLimits {
  static const freeMaxAlerts = 5;

  static int maxAlerts({required bool isPro}) => isPro ? 999 : freeMaxAlerts;

  static bool canAddAlert({required bool isPro, required int currentCount}) =>
      currentCount < maxAlerts(isPro: isPro);
}

/// Compile-time Pro unlock для dev/release builds.
abstract final class ProConfig {
  static const compileTimePro = bool.fromEnvironment(
    'ECOPULSE_PRO',
    defaultValue: false,
  );
}
