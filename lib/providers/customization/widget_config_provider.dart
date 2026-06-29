// =============================================================================
// EcoPulse · lib/providers/widget_config_provider.dart
// Автор: Цымбал Е. В.
// Дата: 25.05.2026
// Конфиг Android home widget: layout 4×1 / 2×2 и метрики слотов.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecopulse/providers/app/app_providers.dart';

/// Метрика для слота home widget.
enum WidgetMetric {
  usdRub('USD/RUB'),
  eurRub('EUR/RUB'),
  btc('BTC'),
  eth('ETH'),
  keyRate('CBR'),
  brent('Brent'),
  wti('WTI'),
  imoex('IMOEX'),
  portfolioPnl('Portfolio'),
  inflationRu('CPI RU');

  const WidgetMetric(this.label);
  final String label;

  static WidgetMetric fromStorage(String? raw, WidgetMetric fallback) {
    if (raw == null) return fallback;
    return WidgetMetric.values.where((m) => m.name == raw).firstOrNull ?? fallback;
  }
}

/// Режим layout: auto подстраивается под размер, compact = 4×1, expanded = 2×2.
enum WidgetLayout {
  auto,
  compact,
  expanded;

  static WidgetLayout fromStorage(String? raw) {
    if (raw == null) return WidgetLayout.auto;
    return WidgetLayout.values.where((l) => l.name == raw).firstOrNull ??
        WidgetLayout.auto;
  }
}

/// Конфигурация home widget.
class WidgetConfig {
  const WidgetConfig({
    required this.layout,
    required this.slot1,
    required this.slot2,
    required this.slot3,
    required this.slot4,
  });

  final WidgetLayout layout;
  final WidgetMetric slot1;
  final WidgetMetric slot2;
  final WidgetMetric slot3;
  final WidgetMetric slot4;

  /// Метрики для записи в widget (все 4; compact показывает первые 2).
  List<WidgetMetric> get activeMetrics => [slot1, slot2, slot3, slot4];

  WidgetConfig copyWith({
    WidgetLayout? layout,
    WidgetMetric? slot1,
    WidgetMetric? slot2,
    WidgetMetric? slot3,
    WidgetMetric? slot4,
  }) =>
      WidgetConfig(
        layout: layout ?? this.layout,
        slot1: slot1 ?? this.slot1,
        slot2: slot2 ?? this.slot2,
        slot3: slot3 ?? this.slot3,
        slot4: slot4 ?? this.slot4,
      );
}

final widgetConfigProvider =
    NotifierProvider<WidgetConfigNotifier, WidgetConfig>(WidgetConfigNotifier.new);

class WidgetConfigNotifier extends Notifier<WidgetConfig> {
  static const _layoutKey = 'widget_layout';
  static const _slot1Key = 'widget_slot1';
  static const _slot2Key = 'widget_slot2';
  static const _slot3Key = 'widget_slot3';
  static const _slot4Key = 'widget_slot4';

  @override
  WidgetConfig build() {
    final cache = ref.watch(cacheServiceProvider);
    return WidgetConfig(
      layout: WidgetLayout.fromStorage(cache.getString(_layoutKey)),
      slot1: WidgetMetric.fromStorage(cache.getString(_slot1Key), WidgetMetric.usdRub),
      slot2: WidgetMetric.fromStorage(cache.getString(_slot2Key), WidgetMetric.btc),
      slot3: WidgetMetric.fromStorage(cache.getString(_slot3Key), WidgetMetric.keyRate),
      slot4: WidgetMetric.fromStorage(cache.getString(_slot4Key), WidgetMetric.imoex),
    );
  }

  Future<void> setLayout(WidgetLayout layout) async {
    await ref.read(cacheServiceProvider).putString(_layoutKey, layout.name);
    state = state.copyWith(layout: layout);
  }

  Future<void> setSlot1(WidgetMetric metric) async {
    await ref.read(cacheServiceProvider).putString(_slot1Key, metric.name);
    state = state.copyWith(slot1: metric);
  }

  Future<void> setSlot2(WidgetMetric metric) async {
    await ref.read(cacheServiceProvider).putString(_slot2Key, metric.name);
    state = state.copyWith(slot2: metric);
  }

  Future<void> setSlot3(WidgetMetric metric) async {
    await ref.read(cacheServiceProvider).putString(_slot3Key, metric.name);
    state = state.copyWith(slot3: metric);
  }

  Future<void> setSlot4(WidgetMetric metric) async {
    await ref.read(cacheServiceProvider).putString(_slot4Key, metric.name);
    state = state.copyWith(slot4: metric);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
