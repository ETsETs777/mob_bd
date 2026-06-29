import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/features/customization/customization_screen.dart';
import 'package:ecopulse/features/settings/settings_screen.dart';
import '../../support/widget_test_harness.dart';

void main() {
  setUp(() async {
    await initWidgetTestEnvironment();
  });

  testWidgets('Customization and Settings hubs render section navigation', (tester) async {
    useLargeTestViewport(tester);
    addTearDown(() => resetTestViewport(tester));

    await pumpWidgetForTest(tester, const CustomizationScreen());
    expect(find.byType(CustomizationScreen), findsOneWidget);
    expect(find.text('Customization'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Sections'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sections'), findsOneWidget);
    expect(find.text('Charts'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Widget'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Widget'), findsOneWidget);
    await tester.pumpWidget(wrapForWidgetTest(const SizedBox.shrink()));
    await tester.pump();

    await pumpWidgetForTest(tester, const SettingsScreen());
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Settings groups'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Security'), findsOneWidget);

    await flushTestTimers(tester);
  });
}
