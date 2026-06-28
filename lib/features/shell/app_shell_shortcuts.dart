// =============================================================================
// EcoPulse · lib/features/shell/app_shell_shortcuts.dart
// Автор: Цымбал Е. В.
// Дата: 30.05.2026
// Горячие клавиши web/desktop: цифры 1–5 переключают табы.
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
  const AppShellTabIntent(this.index);
/// Поле [index] класса [AppShellTabIntent].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final int index;
}

/// Горячие клавиши shell: цифры 1–5 переключают табы (web/desktop).
class AppShellShortcuts extends ConsumerWidget {
/// Создаёт [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const AppShellShortcuts({super.key, required this.child});

/// Поле [child] класса [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final Widget child;

/// Поле [maxTabs] класса [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static const maxTabs = 5;

/// Отрисовывает UI [AppShellShortcuts].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const tabKeys = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
    ];

    final shortcuts = <ShortcutActivator, Intent>{
      for (var i = 0; i < tabKeys.length; i++)
        SingleActivator(tabKeys[i]): AppShellTabIntent(i),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: {
          AppShellTabIntent: CallbackAction<AppShellTabIntent>(
            onInvoke: (intent) {
              if (intent.index < 0 || intent.index >= maxTabs) return null;
              HapticFeedback.selectionClick();
              ref.read(navigationIndexProvider.notifier).state = intent.index;
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
