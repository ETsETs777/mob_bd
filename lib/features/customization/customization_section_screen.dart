import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/customization/customization_sync.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_provider.dart';
import '../../providers/locale_provider.dart';
import 'panels/customization_panels.dart';

/// Sub-screen одной секции кастомизации.
class CustomizationSectionScreen extends ConsumerWidget {
  const CustomizationSectionScreen({
    super.key,
    required this.section,
  });

  final CustomizationSection section;

  static String titleFor(CustomizationSection section, AppLocalizations l10n) {
    return switch (section) {
      CustomizationSection.charts => l10n.customizationSectionCharts,
      CustomizationSection.appearance => l10n.customizationSectionAppearance,
      CustomizationSection.home => l10n.customizationSectionHome,
      CustomizationSection.navigation => l10n.customizationSectionNavigation,
      CustomizationSection.markets => l10n.customizationSectionMarkets,
      CustomizationSection.portfolio => l10n.customizationSectionPortfolio,
      CustomizationSection.widgets => l10n.customizationSectionWidgets,
      CustomizationSection.dataDisplay => l10n.customizationSectionDataDisplay,
      CustomizationSection.assistant => l10n.customizationSectionAssistant,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final config = ref.watch(customizationProvider);
    final isRu = ref.watch(localeProvider) == AppLocale.ru;

    Future<void> commit(UserCustomization next) =>
        ref.read(customizationProvider.notifier).commitWithLegacy(
              ref,
              next.copyWith(
                meta: next.meta.copyWith(activePresetId: null),
              ),
            );

    return Scaffold(
      appBar: AppBar(
        title: Text(titleFor(section, l10n)),
        actions: [
          TextButton(
            onPressed: () async {
              await CustomizationSync.resetSection(ref, section);
            },
            child: Text(l10n.customizationResetSection),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.scaled(context, 16)),
        children: [
          _buildPanel(
            config: config,
            l10n: l10n,
            palette: palette,
            isRu: isRu,
            commit: commit,
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildPanel({
    required UserCustomization config,
    required AppLocalizations l10n,
    required AppPalette palette,
    required bool isRu,
    required Future<void> Function(UserCustomization) commit,
  }) {
    return switch (section) {
      CustomizationSection.charts => CustomizationChartsPanel(
          charts: config.charts,
          l10n: l10n,
          palette: palette,
          isRu: isRu,
          onChanged: (ChartCustomization charts) =>
              commit(config.copyWith(charts: charts)),
        ),
      CustomizationSection.appearance => CustomizationAppearancePanel(
          appearance: config.appearance,
          l10n: l10n,
          palette: palette,
          isRu: isRu,
          onChanged: (AppearanceCustomization appearance) =>
              commit(config.copyWith(appearance: appearance)),
        ),
      CustomizationSection.home => CustomizationHomePanel(
          home: config.home,
          l10n: l10n,
          palette: palette,
          onChanged: (HomeCustomization home) =>
              commit(config.copyWith(home: home)),
        ),
      CustomizationSection.navigation => CustomizationNavigationPanel(
          navigation: config.navigation,
          l10n: l10n,
          palette: palette,
          onChanged: (NavigationCustomization navigation) =>
              commit(config.copyWith(navigation: navigation)),
        ),
      CustomizationSection.markets => CustomizationMarketsPanel(
          markets: config.markets,
          l10n: l10n,
          palette: palette,
          onChanged: (MarketsCustomization markets) =>
              commit(config.copyWith(markets: markets)),
        ),
      CustomizationSection.portfolio => CustomizationPortfolioPanel(
          portfolio: config.portfolio,
          l10n: l10n,
          palette: palette,
          onChanged: (PortfolioCustomization portfolio) =>
              commit(config.copyWith(portfolio: portfolio)),
        ),
      CustomizationSection.widgets => CustomizationWidgetsPanel(
          widgets: config.widgets,
          l10n: l10n,
          palette: palette,
          onChanged: (WidgetCustomization widgets) =>
              commit(config.copyWith(widgets: widgets)),
        ),
      CustomizationSection.dataDisplay => CustomizationDataDisplayPanel(
          dataDisplay: config.dataDisplay,
          l10n: l10n,
          palette: palette,
          onChanged: (DataDisplayCustomization dataDisplay) =>
              commit(config.copyWith(dataDisplay: dataDisplay)),
        ),
      CustomizationSection.assistant => CustomizationAssistantPanel(
          assistant: config.assistant,
          l10n: l10n,
          palette: palette,
          onChanged: (AssistantCustomization assistant) =>
              commit(config.copyWith(assistant: assistant)),
        ),
    };
  }
}
