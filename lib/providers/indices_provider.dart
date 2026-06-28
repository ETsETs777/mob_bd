// =============================================================================
// EcoPulse · lib/providers/indices_provider.dart
// Автор: Цымбал Е. В.
// Дата: 22.05.2026
// Riverpod state: провайдеры и notifiers. Файл: indices_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/demo/demo_fixtures.dart';
import '../data/models/market_asset.dart';
import 'app_providers.dart';
import 'demo_mode_provider.dart';

/// Riverpod-провайдер [usIndicesProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
final usIndicesProvider =
    AsyncNotifierProvider<UsIndicesNotifier, List<MarketAsset>>(
  UsIndicesNotifier.new,
);

/// Riverpod AsyncNotifier [UsIndicesNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
class UsIndicesNotifier extends AsyncNotifier<List<MarketAsset>> {
/// Отрисовывает UI [UsIndicesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  @override
  Future<List<MarketAsset>> build() => _load();

/// Перезагружает данные [UsIndicesNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state =
          AsyncValue<List<MarketAsset>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [UsIndicesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<List<MarketAsset>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.usIndices);
    }
    return ref.read(marketRepositoryProvider).fetchUsIndices(force: force);
  }
}
