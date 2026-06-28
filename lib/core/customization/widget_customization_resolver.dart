import '../../data/models/user_customization.dart';
import '../../providers/widget_config_provider.dart';

/// Резолвер настроек Android home widget из [WidgetCustomization].
class WidgetCustomizationResolver {
  WidgetCustomizationResolver._();

  static const defaultSlotKeys = ['usdRub', 'btc', 'keyRate', 'imoex'];

  static WidgetConfig resolve(WidgetCustomization widgets) {
    final keys = _resolveSlotKeys(widgets.slots);
    return WidgetConfig(
      layout: WidgetLayout.fromStorage(widgets.layout),
      slot1: WidgetMetric.fromStorage(keys[0], WidgetMetric.usdRub),
      slot2: WidgetMetric.fromStorage(keys[1], WidgetMetric.btc),
      slot3: WidgetMetric.fromStorage(keys[2], WidgetMetric.keyRate),
      slot4: WidgetMetric.fromStorage(keys[3], WidgetMetric.imoex),
    );
  }

  static List<String> _resolveSlotKeys(List<String> raw) {
    final keys = raw.length >= 4
        ? List<String>.from(raw.take(4))
        : List<String>.from(defaultSlotKeys);
    while (keys.length < 4) {
      keys.add(defaultSlotKeys[keys.length]);
    }
    return keys;
  }

  static WidgetCustomization updateLayout(
    WidgetCustomization widgets,
    WidgetLayout layout,
  ) =>
      widgets.copyWith(layout: layout.name);

  static WidgetCustomization updateSlot(
    WidgetCustomization widgets,
    int index,
    WidgetMetric metric,
  ) {
    final keys = _resolveSlotKeys(widgets.slots);
    keys[index.clamp(0, 3)] = metric.name;
    return widgets.copyWith(slots: keys);
  }

  static WidgetCustomization fromWidgetConfig(WidgetConfig config) {
    return WidgetCustomization(
      layout: config.layout.name,
      slots: config.activeMetrics.map((m) => m.name).toList(),
    );
  }
}
