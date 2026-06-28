// =============================================================================
// EcoPulse · lib/providers/onboarding_provider.dart
// Автор: Цымбал Е. В.
// Дата: 23.05.2026
// Riverpod state: провайдеры и notifiers. Файл: onboarding_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';

/// Riverpod-провайдер [onboardingCompletedProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
final onboardingCompletedProvider =
    NotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);

/// Riverpod AsyncNotifier [OnboardingNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
class OnboardingNotifier extends Notifier<bool> {
/// Поле [_cacheKey] класса [OnboardingNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  static const _cacheKey = 'onboarding_completed';

/// Отрисовывает UI [OnboardingNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  @override
  bool build() {
    return CacheService.instance.getString(_cacheKey) == 'true';
  }

/// Метод [complete] класса [OnboardingNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Future<void> complete() async {
    state = true;
    await CacheService.instance.putString(_cacheKey, 'true');
  }
}
