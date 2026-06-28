// =============================================================================
// EcoPulse · lib/features/shell/app_shell_shortcuts.dart
// Автор: Цымбал Е. В.
// Дата: 30.05.2026
// Горячие клавиши web/desktop: цифры 1–6 переключают видимые табы.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

/// Класс [AppShellTabIntent].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
class AppShellTabIntent extends Intent {
/// Создаёт [AppShellTabIntent].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  const AppShellTabIntent(this.screenIndex);
/// Поле [screenIndex] класса [AppShellTabIntent].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final int screenIndex;
}

/// Горячие клавиши shell: цифры переключают видимые табы (web/desktop).
class AppShellShortcuts extends ConsumerWidget {
/// Создаёт [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const AppShellShortcuts({
    super.key,
    required this.child,
    required this.visibleTabIndices,
  });

/// Поле [child] класса [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final Widget child;
  final List<int> visibleTabIndices;

  static const _tabKeys = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
  ];

/// Отрисовывает UI [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = visibleTabIndices.isEmpty ? [0] : visibleTabIndices;
    final shortcuts = <ShortcutActivator, Intent>{
      for (var i = 0; i < tabs.length && i < _tabKeys.length; i++)
        SingleActivator(_tabKeys[i]): AppShellTabIntent(tabs[i]),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: {
          AppShellTabIntent: CallbackAction<AppShellTabIntent>(
            onInvoke: (intent) {
              if (!tabs.contains(intent.screenIndex)) return null;
              HapticFeedback.selectionClick();
              ref.read(navigationIndexProvider.notifier).state =
                  intent.screenIndex;
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
