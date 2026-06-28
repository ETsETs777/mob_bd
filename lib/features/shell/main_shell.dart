// =============================================================================
// EcoPulse · lib/features/shell/main_shell.dart
// Автор: Цымбал Е. В.
// Дата: 30.05.2026
// Shell приложения: 5 табов, AppTabLayer, нижняя навигация, AssistantFab.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/navigation_customization_provider.dart';
import '../../providers/data_display_customization_provider.dart';
import '../currency/currency_screen.dart';
import '../home/home_screen.dart';
import '../inflation/inflation_screen.dart';
import '../markets/markets_screen.dart';
import '../messages/messages_screen.dart';
import '../settings/settings_screen.dart';
import '../assistant/assistant_fab.dart';
import '../shared/widgets/motion_widgets.dart';
import 'app_shell_shortcuts.dart';

/// Класс [MainShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
class MainShell extends ConsumerWidget {
/// Создаёт [MainShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  const MainShell({super.key});

/// Поле [_screens] класса [MainShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  static const _screens = [
    HomeScreen(),
    CurrencyScreen(),
    InflationScreen(),
    MarketsScreen(),
    SettingsScreen(),
    MessagesScreen(),
  ];

  static NavigationDestination _destinationFor(
    int index,
    AppLocalizations l10n,
  ) =>
      switch (index) {
        0 => NavigationDestination(
            icon: const Icon(Iconsax.element_3),
            selectedIcon: const Icon(Iconsax.element_4),
            label: l10n.tabHome,
          ),
        1 => NavigationDestination(
            icon: const Icon(Iconsax.convert_card),
            selectedIcon: const Icon(Iconsax.convert_card),
            label: l10n.tabCurrency,
          ),
        2 => NavigationDestination(
            icon: const Icon(Iconsax.chart_2),
            selectedIcon: const Icon(Iconsax.chart_21),
            label: l10n.tabInflation,
          ),
        3 => NavigationDestination(
            icon: const Icon(Iconsax.chart),
            selectedIcon: const Icon(Iconsax.chart_1),
            label: l10n.tabMarkets,
          ),
        4 => NavigationDestination(
            icon: const Icon(Iconsax.setting_2),
            selectedIcon: const Icon(Iconsax.setting),
            label: l10n.tabSettings,
          ),
        _ => NavigationDestination(
            icon: const Icon(Iconsax.message),
            selectedIcon: const Icon(Iconsax.message),
            label: l10n.tabMessages,
          ),
      };

/// Отрисовывает UI [MainShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(resolvedNavigationProvider);
    final screenIndex = ref.watch(navigationIndexProvider);
    ref.watch(resolvedDataDisplayProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(resolvedNavigationProvider, (previous, next) {
      final current = ref.read(navigationIndexProvider);
      if (!next.isScreenVisible(current)) {
        ref.read(navigationIndexProvider.notifier).state =
            next.effectiveDefaultIndex;
      }
    });

    final barIndex = navigation.barIndexForScreen(screenIndex) ?? 0;

    return AppShellShortcuts(
      visibleTabIndices: navigation.orderedVisibleIndices,
      child: Stack(
        children: [
          Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                for (var i = 0; i < _screens.length; i++)
                  AppTabLayer(
                    key: ValueKey('tab_$i'),
                    visible: screenIndex == i,
                    child: _screens[i],
                  ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: barIndex,
              animationDuration: AppMotion.duration(context, AppMotion.fast),
              labelBehavior: navigation.hideNavLabels
                  ? NavigationDestinationLabelBehavior.alwaysHide
                  : NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (selectedBarIndex) {
                HapticFeedback.selectionClick();
                ref.read(navigationIndexProvider.notifier).state =
                    navigation.screenIndexForBar(selectedBarIndex);
              },
              destinations: [
                for (final index in navigation.orderedVisibleIndices)
                  _destinationFor(index, l10n),
              ],
            ),
          ),
          if (navigation.showAssistantFab) const AssistantFab(),
        ],
      ),
    );
  }
}
