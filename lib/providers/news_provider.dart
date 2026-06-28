// =============================================================================
// EcoPulse · lib/providers/news_provider.dart
// Автор: Цымбал Е. В.
// Дата: 23.05.2026
// Riverpod state: провайдеры и notifiers. Файл: news_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/demo/demo_fixtures.dart';
import '../data/models/macro_event.dart';
import '../data/models/news_item.dart';
import '../data/repositories/news_repository.dart';
import '../data/services/api_client.dart';
import 'app_providers.dart';
import 'demo_mode_provider.dart';

/// Riverpod-провайдер [newsRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(
    ref.watch(dioProvider),
    ref.watch(cacheServiceProvider),
  );
});

/// Riverpod-провайдер [marketNewsProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final marketNewsProvider =
    AsyncNotifierProvider<MarketNewsNotifier, List<NewsItem>>(
  MarketNewsNotifier.new,
);

/// Riverpod AsyncNotifier [MarketNewsNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class MarketNewsNotifier extends AsyncNotifier<List<NewsItem>> {
/// Отрисовывает UI [MarketNewsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  @override
  Future<List<NewsItem>> build() => _load();

/// Перезагружает данные [MarketNewsNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<List<NewsItem>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [MarketNewsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<List<NewsItem>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.news);
    }
    return ref.read(newsRepositoryProvider).fetchNews(force: force);
  }
}

/// Riverpod-провайдер [macroCalendarProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final macroCalendarProvider =
    AsyncNotifierProvider<MacroCalendarNotifier, List<MacroEvent>>(
  MacroCalendarNotifier.new,
);

/// Riverpod AsyncNotifier [MacroCalendarNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class MacroCalendarNotifier extends AsyncNotifier<List<MacroEvent>> {
/// Отрисовывает UI [MacroCalendarNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  @override
  Future<List<MacroEvent>> build() => _load();

/// Перезагружает данные [MacroCalendarNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state =
          AsyncValue<List<MacroEvent>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [MacroCalendarNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<List<MacroEvent>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.macroEvents);
    }
    return ref.read(newsRepositoryProvider).fetchMacroCalendar(force: force);
  }
}
