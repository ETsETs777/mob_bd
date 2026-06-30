// =============================================================================
// EcoPulse · lib/features/shell/app_gate.dart
// Автор: Цымбал Е. В.
// Дата: 30.05.2026
// Входной экран: onboarding, биометрия, переход в MainShell.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/customization/customization_sync.dart';
import '../../core/utils/user_calendar_reminders.dart';
import '../../providers/customization_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/overnight_changes_provider.dart';
import '../../providers/articles_provider.dart';
import '../../core/services/home_widget_refresh_pipeline.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/price_alerts_provider.dart';
import '../../providers/security_provider.dart';
import '../../providers/user_calendar_provider.dart';
import '../../providers/profile/user_local_data_sync_provider.dart';
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
      CustomizationSync.applyLegacy(ref, ref.read(customizationProvider));
      final completed = ref.read(onboardingCompletedProvider);
      if (!completed) {
        setState(() => _showOnboarding = true);
      }
      UserCalendarReminders.syncAll(ref.read(userCalendarProvider));
      final auth = ref.read(homeServerProvider).auth;
      if (auth.isLoggedIn) {
        ref.read(homeServerProvider.notifier).refreshSession();
        ref.read(userLocalDataSyncProvider.notifier).smartSyncAuto();
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
      persistOvernightSnapshot(ref);
      ref.read(appUnlockedProvider.notifier).lock();
    } else if (state == AppLifecycleState.resumed) {
      final unlocked = ref.read(appUnlockedProvider);
      if (unlocked) {
        evaluatePriceAlerts(ref);
        UserCalendarReminders.syncAll(ref.read(userCalendarProvider));
        final auth = ref.read(homeServerProvider).auth;
        if (auth.isLoggedIn) {
          ref.read(homeServerProvider.notifier).refreshSession();
          ref.read(userLocalDataSyncProvider.notifier).smartSyncAuto();
          ref.read(articlesProvider.notifier).refreshAll();
          HomeWidgetRefreshPipeline.refresh(ref.read);
        }
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
