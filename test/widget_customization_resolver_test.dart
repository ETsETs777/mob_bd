import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/widget_customization_resolver.dart';
import 'package:ecopulse/providers/widget_config_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('WidgetCustomizationResolver resolves layout and slots', () {
    final widgets = CustomizationDefaults.create().widgets.copyWith(
          layout: 'expanded',
          slots: ['eth', 'wti', 'brent', 'portfolioPnl'],
        );

    final config = WidgetCustomizationResolver.resolve(widgets);

    expect(config.layout, WidgetLayout.expanded);
    expect(config.slot1, WidgetMetric.eth);
    expect(config.slot2, WidgetMetric.wti);
    expect(config.slot3, WidgetMetric.brent);
    expect(config.slot4, WidgetMetric.portfolioPnl);
  });

  test('WidgetCustomizationResolver falls back to defaults for short lists', () {
    final config = WidgetCustomizationResolver.resolve(
      CustomizationDefaults.create().widgets.copyWith(slots: ['btc']),
    );

    expect(config.slot1, WidgetMetric.usdRub);
    expect(config.slot2, WidgetMetric.btc);
    expect(config.slot3, WidgetMetric.keyRate);
    expect(config.slot4, WidgetMetric.imoex);
  });

  test('updateSlot mutates config', () {
    final widgets = CustomizationDefaults.create().widgets;
    final updated = WidgetCustomizationResolver.updateSlot(
      widgets,
      1,
      WidgetMetric.inflationRu,
    );

    expect(updated.slots[1], 'inflationRu');
  });

  test('fromWidgetConfig roundtrips', () {
    const config = WidgetConfig(
      layout: WidgetLayout.compact,
      slot1: WidgetMetric.usdRub,
      slot2: WidgetMetric.eth,
      slot3: WidgetMetric.keyRate,
      slot4: WidgetMetric.imoex,
    );

    final widgets = WidgetCustomizationResolver.fromWidgetConfig(config);
    final resolved = WidgetCustomizationResolver.resolve(widgets);

    expect(resolved.layout, config.layout);
    expect(resolved.activeMetrics, config.activeMetrics);
  });
}
