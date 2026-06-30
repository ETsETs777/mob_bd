import '../../data/models/user_customization.dart';
import 'customization_defaults.dart';
import 'customization_preset.dart';

/// Встроенные пресеты и утилиты для пользовательских пресетов.
class CustomizationPresets {
  CustomizationPresets._();

  static const classicId = 'builtin_classic';
  static const traderId = 'builtin_trader';
  static const minimalId = 'builtin_minimal';
  static const analystId = 'builtin_analyst';
  static const oledId = 'builtin_oled';

  static List<CustomizationPreset> get builtIn => [
        classic,
        trader,
        minimal,
        analyst,
        oled,
      ];

  static CustomizationPreset get classic => CustomizationPreset(
        id: classicId,
        nameRu: 'Классика',
        nameEn: 'Classic',
        isBuiltIn: true,
        config: stripPresetMeta(CustomizationDefaults.create()),
      );

  static CustomizationPreset get trader {
    final base = CustomizationDefaults.create();
    return CustomizationPreset(
      id: traderId,
      nameRu: 'Трейдер',
      nameEn: 'Trader',
      isBuiltIn: true,
      config: stripPresetMeta(
        base.copyWith(
          charts: base.charts.copyWith(
            defaultType: ChartTypeId.candlestick,
            defaultHeight: ChartHeightPreset.tall,
            preferCandlesWhenAvailable: true,
          ),
          appearance: base.appearance.copyWith(
            accentKey: 'green',
            backgroundKey: 'emerald',
            uiDensity: UiDensity.compact,
          ),
          home: base.home.copyWith(compactHome: true),
          navigation: base.navigation.copyWith(defaultTabIndex: 3),
          markets: base.markets.copyWith(
            groupStocksBySector: true,
            listRowCompact: true,
          ),
          assistant: base.assistant.copyWith(showQuickChips: true),
        ),
      ),
    );
  }

  static CustomizationPreset get minimal {
    final base = CustomizationDefaults.create();
    return CustomizationPreset(
      id: minimalId,
      nameRu: 'Минимализм',
      nameEn: 'Minimal',
      isBuiltIn: true,
      config: stripPresetMeta(
        base.copyWith(
          appearance: base.appearance.copyWith(
            themeModeKey: 'light',
            backgroundKey: 'minimalLight',
            uiDensity: UiDensity.compact,
            motionReduced: true,
            cardStyle: CardStyleId.flat,
          ),
          home: base.home.copyWith(
            compactHome: true,
            showSparklines: false,
            sectionVisibility: {
              ...base.home.sectionVisibility,
              'learn': false,
              'news': false,
              'radar': false,
              'correlation': false,
            },
          ),
          navigation: base.navigation.copyWith(
            showAssistantFab: false,
            hideNavLabels: true,
          ),
          assistant: base.assistant.copyWith(
            showQuickChips: false,
            voiceInputEnabled: false,
          ),
        ),
      ),
    );
  }

  static CustomizationPreset get analyst {
    final base = CustomizationDefaults.create();
    return CustomizationPreset(
      id: analystId,
      nameRu: 'Аналитик',
      nameEn: 'Analyst',
      isBuiltIn: true,
      config: stripPresetMeta(
        base.copyWith(
          charts: base.charts.copyWith(
            defaultType: ChartTypeId.bar,
            normalizedCompare: true,
            visual: base.charts.visual.copyWith(showCrosshair: true),
          ),
          appearance: base.appearance.copyWith(
            accentKey: 'purple',
            uiDensity: UiDensity.spacious,
          ),
          portfolio: base.portfolio.copyWith(
            allocationChartType: AllocationChartType.donut,
            showJournal: true,
          ),
          dataDisplay: base.dataDisplay.copyWith(
            decimalPlaces: DecimalPlacesMode.fixed2,
            showCurrencyCode: true,
          ),
        ),
      ),
    );
  }

  static CustomizationPreset get oled {
    final base = CustomizationDefaults.create();
    return CustomizationPreset(
      id: oledId,
      nameRu: 'OLED',
      nameEn: 'OLED',
      isBuiltIn: true,
      config: stripPresetMeta(
        base.copyWith(
          appearance: base.appearance.copyWith(
            themeModeKey: 'oled',
            accentKey: 'blue',
            backgroundKey: 'graphite',
            amoledPureBlack: true,
          ),
        ),
      ),
    );
  }

  static CustomizationPreset? findById(String id) {
    for (final preset in builtIn) {
      if (preset.id == id) return preset;
    }
    return null;
  }

  /// Убирает activePresetId — пресет хранит только конфиг секций.
  static UserCustomization stripPresetMeta(UserCustomization config) {
    return config.copyWith(
      meta: CustomizationMeta(
        schemaVersion: UserCustomization.currentSchemaVersion,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  static UserCustomization withActivePreset(
    UserCustomization current,
    CustomizationPreset preset,
  ) {
    return preset.config.copyWith(
      meta: current.meta.copyWith(
        activePresetId: preset.id,
        updatedAt: DateTime.now().toUtc(),
        schemaVersion: UserCustomization.currentSchemaVersion,
      ),
    );
  }
}
