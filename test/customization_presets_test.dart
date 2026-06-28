import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/customization_preset.dart';
import 'package:ecopulse/core/customization/customization_presets.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('built-in presets have unique ids', () {
    final ids = CustomizationPresets.builtIn.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('classic preset matches factory defaults', () {
    final classic = CustomizationPresets.classic;
    final defaults = CustomizationDefaults.create();
    expect(classic.config.appearance.themeModeKey, defaults.appearance.themeModeKey);
    expect(classic.config.charts.defaultType, defaults.charts.defaultType);
    expect(classic.isBuiltIn, isTrue);
  });

  test('trader preset enables market-focused options', () {
    final trader = CustomizationPresets.trader;
    expect(trader.config.charts.defaultType, ChartTypeId.candlestick);
    expect(trader.config.navigation.defaultTabIndex, 3);
    expect(trader.config.markets.groupStocksBySector, isTrue);
  });

  test('CustomizationPreset json roundtrip', () {
    final preset = CustomizationPreset(
      id: 'user_test',
      nameRu: 'Тест',
      nameEn: 'Test',
      config: CustomizationPresets.stripPresetMeta(CustomizationDefaults.create()),
    );

    final restored = CustomizationPreset.fromJson(preset.toJson());
    expect(restored.id, preset.id);
    expect(restored.nameRu, preset.nameRu);
    expect(restored.config.appearance.accentKey, 'blue');
  });

  test('withActivePreset sets activePresetId', () {
    final current = CustomizationDefaults.create();
    final applied = CustomizationPresets.withActivePreset(
      current,
      CustomizationPresets.oled,
    );
    expect(applied.meta.activePresetId, CustomizationPresets.oledId);
    expect(applied.appearance.themeModeKey, 'oled');
  });
}
