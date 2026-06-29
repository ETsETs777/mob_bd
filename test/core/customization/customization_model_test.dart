import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/customization_legacy_adapter.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserCustomization json roundtrip', () {
    final original = CustomizationDefaults.create(
      updatedAt: DateTime.utc(2026, 6, 28, 12),
    ).copyWith(
      charts: CustomizationDefaults.create().charts.copyWith(
            defaultType: ChartTypeId.candlestick,
            defaultPeriodKey: 'y1',
          ),
      appearance: CustomizationDefaults.create().appearance.copyWith(
            themeModeKey: 'oled',
            accentKey: 'teal',
          ),
    );

    final restored = UserCustomization.fromJson(original.toJson());
    expect(restored.meta.schemaVersion, UserCustomization.currentSchemaVersion);
    expect(restored.charts.defaultType, ChartTypeId.candlestick);
    expect(restored.charts.defaultPeriodKey, 'y1');
    expect(restored.appearance.themeModeKey, 'oled');
    expect(restored.appearance.accentKey, 'teal');
    expect(restored.home.sectionOrder.length, greaterThan(10));
  });

  test('CustomizationLegacyAdapter imports theme and home keys', () {
    final legacy = <String, String>{
      'theme_mode': 'light',
      'accent_color': 'purple',
      'compact_home': 'true',
      'default_tab': '3',
      'base_currency': 'rub',
      'app_locale': 'en',
      'home_sec_news': '0',
      'widget_layout': 'compact',
      'widget_slot1': 'btc',
    };

    final config = CustomizationLegacyAdapter.importFromStrings(
      (key) => legacy[key],
    );

    expect(config.appearance.themeModeKey, 'light');
    expect(config.appearance.accentKey, 'purple');
    expect(config.home.compactHome, isTrue);
    expect(config.navigation.defaultTabIndex, 3);
    expect(config.dataDisplay.baseCurrency, 'rub');
    expect(config.dataDisplay.localeCode, 'en');
    expect(config.home.sectionVisibility['news'], isFalse);
    expect(config.widgets.layout, 'compact');
    expect(config.widgets.slots.first, 'btc');
  });

  test('ChartContextProfile defaults per context', () {
    final charts = CustomizationDefaults.create().charts;
    expect(
      charts.profileFor(ChartContextId.inflation).type,
      ChartTypeId.bar,
    );
    expect(
      charts.profileFor(ChartContextId.compare).type,
      ChartTypeId.normalizedOverlay,
    );
    expect(
      charts.profileFor(ChartContextId.assetDetail).useGlobalDefaults,
      isTrue,
    );
  });
}
