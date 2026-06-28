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
import '../../providers/base_currency_provider.dart';
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

/// Отрисовывает UI [MainShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);
    ref.watch(baseCurrencyProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppShellShortcuts(
      child: Stack(
        children: [
          Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                for (var i = 0; i < _screens.length; i++)
                  AppTabLayer(
                    key: ValueKey('tab_$i'),
                    visible: index == i,
                    child: _screens[i],
                  ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: index,
              animationDuration: AppMotion.duration(context, AppMotion.fast),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (i) {
                HapticFeedback.selectionClick();
                ref.read(navigationIndexProvider.notifier).state = i;
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Iconsax.element_3),
                  selectedIcon: const Icon(Iconsax.element_4),
                  label: l10n.tabHome,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.convert_card),
                  selectedIcon: const Icon(Iconsax.convert_card),
                  label: l10n.tabCurrency,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.chart_2),
                  selectedIcon: const Icon(Iconsax.chart_21),
                  label: l10n.tabInflation,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.chart),
                  selectedIcon: const Icon(Iconsax.chart_1),
                  label: l10n.tabMarkets,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.setting_2),
                  selectedIcon: const Icon(Iconsax.setting),
                  label: l10n.tabSettings,
                ),
                NavigationDestination(
                  icon: const Icon(Iconsax.message),
                  selectedIcon: const Icon(Iconsax.message),
                  label: l10n.tabMessages,
                ),
              ],
            ),
          ),
          const AssistantFab(),
        ],
      ),
    );
  }
}
