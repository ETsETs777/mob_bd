import '../../data/models/chart_period.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import 'chart_registry.dart';

/// Метки и хелперы профилей графиков по [ChartContextId].
class ChartContextProfiles {
  ChartContextProfiles._();

  static const orderedContexts = ChartContextId.values;

  static bool supportsPeriod(ChartContextId context) => switch (context) {
        ChartContextId.assetDetail ||
        ChartContextId.currency ||
        ChartContextId.keyRate ||
        ChartContextId.compare =>
          true,
        _ => false,
      };

  static ChartPeriod periodFromKey(String? key) {
    if (key == null || key.isEmpty) return ChartPeriod.d30;
    for (final period in ChartPeriod.values) {
      if (period.name == key) return period;
    }
    return ChartPeriod.d30;
  }

  static ChartPeriod periodForContext(
    ChartCustomization charts,
    ChartContextId context,
  ) {
    final profile = charts.profileFor(context);
    final key = profile.useGlobalDefaults
        ? charts.defaultPeriodKey
        : (profile.periodKey ?? charts.defaultPeriodKey);
    return periodFromKey(key);
  }

  static ChartTypeId effectiveType(
    ChartCustomization charts,
    ChartContextId context,
  ) {
    final profile = charts.profileFor(context);
    if (profile.useGlobalDefaults) return charts.defaultType;
    return profile.type ?? charts.defaultType;
  }

  static ChartCustomization updateProfile(
    ChartCustomization charts,
    ChartContextId context,
    ChartContextProfile profile,
  ) {
    return charts.copyWith(
      contextProfiles: {
        ...charts.contextProfiles,
        context: profile,
      },
    );
  }

  static ChartContextProfile resetProfile(ChartContextId context) {
    return ChartContextProfile(
      useGlobalDefaults: context != ChartContextId.inflation &&
          context != ChartContextId.compare &&
          context != ChartContextId.portfolio &&
          context != ChartContextId.bonds,
      type: switch (context) {
        ChartContextId.inflation => ChartTypeId.bar,
        ChartContextId.compare => ChartTypeId.normalizedOverlay,
        ChartContextId.portfolio => ChartTypeId.pie,
        ChartContextId.bonds => ChartTypeId.yieldCurve,
        _ => null,
      },
    );
  }

  static String label(ChartContextId context, AppLocalizations l10n) =>
      switch (context) {
        ChartContextId.assetDetail => l10n.customizationChartContextAssetDetail,
        ChartContextId.inflation => l10n.customizationChartContextInflation,
        ChartContextId.currency => l10n.customizationChartContextCurrency,
        ChartContextId.compare => l10n.customizationChartContextCompare,
        ChartContextId.portfolio => l10n.customizationChartContextPortfolio,
        ChartContextId.bonds => l10n.customizationChartContextBonds,
        ChartContextId.keyRate => l10n.customizationChartContextKeyRate,
        ChartContextId.homeSparkline =>
          l10n.customizationChartContextHomeSparkline,
      };

  static List<ChartTypeId> typesForContext(ChartContextId context) =>
      ChartRegistry.typesForContext(context);
}
