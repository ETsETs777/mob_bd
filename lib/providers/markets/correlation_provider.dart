// =============================================================================
// EcoPulse · lib/providers/correlation_provider.dart
// Автор: Цымбал Е. В.
// Дата: 20.05.2026
// Riverpod state: провайдеры и notifiers. Файл: correlation_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/correlation_utils.dart';
import '../../data/repositories/correlation_repository.dart';
import '../../data/services/api_client.dart';
import 'package:ecopulse/providers/app/app_providers.dart';

/// Riverpod-провайдер [correlationRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final correlationRepositoryProvider = Provider<CorrelationRepository>((ref) {
  return CorrelationRepository(
    ref.watch(dioProvider),
    ref.watch(cacheServiceProvider),
  );
});

/// Riverpod-провайдер [correlationProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
final correlationProvider =
    AsyncNotifierProvider<CorrelationNotifier, CorrelationSnapshot?>(
  CorrelationNotifier.new,
);

/// Riverpod AsyncNotifier [CorrelationNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
class CorrelationNotifier extends AsyncNotifier<CorrelationSnapshot?> {
/// Отрисовывает UI [CorrelationNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  @override
  Future<CorrelationSnapshot?> build() => _load();

/// Перезагружает данные [CorrelationNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<CorrelationSnapshot?>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [CorrelationNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<CorrelationSnapshot?> _load({bool force = false}) {
    return ref.read(correlationRepositoryProvider).fetchCorrelation(force: force);
  }
}
