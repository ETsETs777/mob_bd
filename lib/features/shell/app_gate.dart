// =============================================================================
// EcoPulse · lib/features/shell/app_gate.dart
// Автор: Цымбал Е. В.
// Дата: 30.05.2026
// Входной экран: onboarding, биометрия, переход в MainShell.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/onboarding_provider.dart';
import '../../providers/price_alerts_provider.dart';
import '../../providers/security_provider.dart';
import '../auth/pin_lock_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../shell/main_shell.dart';
import '../shared/widgets/app_background.dart';

/// Класс [AppGate].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
class AppGate extends ConsumerStatefulWidget {
/// Создаёт [AppGate].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  const AppGate({super.key});

/// Создаёт State для [AppGate].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  ConsumerState<AppGate> createState() => _AppGateState();
}

/// Приватный класс [_AppGateState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
class _AppGateState extends ConsumerState<AppGate> with WidgetsBindingObserver {
/// Поле [_showOnboarding] класса [_AppGateState].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  bool _showOnboarding = false;

/// Инициализация state [_AppGateState].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final completed = ref.read(onboardingCompletedProvider);
      if (!completed) {
        setState(() => _showOnboarding = true);
      }
    });
  }

/// Освобождает ресурсы [_AppGateState].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

/// Метод [didChangeAppLifecycleState] класса [_AppGateState].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      ref.read(appUnlockedProvider.notifier).lock();
    } else if (state == AppLifecycleState.resumed) {
      final unlocked = ref.read(appUnlockedProvider);
      if (unlocked) {
        evaluatePriceAlerts(ref);
      }
    }
  }

/// Отрисовывает UI [_AppGateState].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return AppBackground(
        child: OnboardingScreen(
          onComplete: () => setState(() => _showOnboarding = false),
        ),
      );
    }

    final unlocked = ref.watch(appUnlockedProvider);
    final pinEnabled = ref.watch(securitySettingsProvider).pinEnabled;

    return AppBackground(
      child: unlocked || !pinEnabled
          ? const MainShell()
          : PinLockScreen(
              onUnlocked: () => setState(() {}),
            ),
    );
  }
}
