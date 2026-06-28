// =============================================================================
// EcoPulse · lib/providers/default_tab_provider.dart
// Автор: Цымбал Е. В.
// Дата: 21.05.2026
// Riverpod state: провайдеры и notifiers. Файл: default_tab_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';
import 'app_providers.dart';

/// Enum [DefaultTab] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
enum DefaultTab {
/// Значение enum [home].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  home(0, 'Главная'),
/// Значение enum [currency].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  currency(1, 'Валюты'),
/// Значение enum [inflation].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  inflation(2, 'Инфляция'),
/// Значение enum [markets].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  markets(3, 'Рынки'),
/// Значение enum [settings].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  settings(4, 'Настройки');

  const DefaultTab(this.tabIndex, this.label);
  final int tabIndex;
  final String label;

  static DefaultTab fromIndex(int index) {
    return DefaultTab.values.firstWhere(
      (t) => t.tabIndex == index,
      orElse: () => DefaultTab.home,
    );
  }
}

/// Riverpod-провайдер [defaultTabProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
final defaultTabProvider =
    NotifierProvider<DefaultTabNotifier, DefaultTab>(DefaultTabNotifier.new);

/// Riverpod AsyncNotifier [DefaultTabNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
class DefaultTabNotifier extends Notifier<DefaultTab> {
/// Поле [_key] класса [DefaultTabNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  static const _key = 'default_tab';

/// Отрисовывает UI [DefaultTabNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  DefaultTab build() {
    final raw = CacheService.instance.getString(_key);
    if (raw == null) return DefaultTab.home;
    final index = int.tryParse(raw);
    if (index == null) return DefaultTab.home;
    return DefaultTab.fromIndex(index);
  }

/// Метод [setTab] класса [DefaultTabNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> setTab(DefaultTab tab) async {
    state = tab;
    await CacheService.instance.putString(_key, tab.tabIndex.toString());
    ref.read(navigationIndexProvider.notifier).state = tab.tabIndex;
  }
}
