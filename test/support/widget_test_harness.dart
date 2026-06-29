import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecopulse/core/theme/app_theme.dart';
import 'package:ecopulse/data/services/cache_service.dart';
import 'package:ecopulse/features/shared/widgets/formatters_scope.dart';
import 'package:ecopulse/l10n/app_localizations.dart';

/// Подготовка Hive и кэша для widget/integration тестов.
Future<void> initWidgetTestEnvironment({
  bool onboardingCompleted = true,
  bool pinEnabled = false,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  if (!CacheService.instance.isInitialized) {
    await CacheService.instance.initForTests();
  }
  await CacheService.instance.resetForTests();

  if (onboardingCompleted) {
    await CacheService.instance.putString('onboarding_completed', 'true');
  }
  if (!pinEnabled) {
    await CacheService.instance.putString('pin_enabled', 'false');
    await CacheService.instance.deleteKey('pin_hash');
    await CacheService.instance.putString('biometric_enabled', 'false');
  }
}

Widget wrapForWidgetTest(Widget child) {
  return ProviderScope(
    child: FormattersScope(
      child: MaterialApp(
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          );
        },
        home: child,
      ),
    ),
  );
}

/// Большой viewport для hub-экранов с каруселями и анимациями.
void useLargeTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
}

void resetTestViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

Future<void> pumpWidgetForTest(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(wrapForWidgetTest(child));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

/// Сброс pending timers перед завершением теста.
Future<void> flushTestTimers(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}
