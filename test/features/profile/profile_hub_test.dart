import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/features/profile/profile_hub_screen.dart';
import '../../support/widget_test_harness.dart';

void main() {
  setUp(() async {
    await initWidgetTestEnvironment();
  });

  testWidgets('ProfileHubScreen shows accounts and menu sections', (tester) async {
    useLargeTestViewport(tester);
    addTearDown(() => resetTestViewport(tester));

    await pumpWidgetForTest(tester, const ProfileHubScreen());

    expect(find.byType(ProfileHubScreen), findsOneWidget);
    expect(find.text('My accounts'), findsOneWidget);
    expect(find.text('Personal data'), findsOneWidget);
    expect(find.text('Security'), findsWidgets);

    await flushTestTimers(tester);
  });
}
