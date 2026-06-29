import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ecopulse/data/models/market_asset.dart';
import 'package:ecopulse/data/services/cache_service.dart';
import 'package:ecopulse/features/asset_detail/asset_detail_screen.dart';
import 'package:ecopulse/features/shell/app_gate.dart';
import 'package:ecopulse/features/shell/main_shell.dart';
import '../test/support/widget_test_harness.dart';

/// Integration flow: onboarding → home → markets → asset detail.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding skip, markets tab, asset detail screen', (tester) async {
    await initWidgetTestEnvironment(onboardingCompleted: false);
    await CacheService.instance.deleteKey('onboarding_completed');

    await tester.pumpWidget(wrapForWidgetTest(const AppGate()));
    await tester.pumpAndSettle();

    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);

    await tester.tap(find.text('Markets'));
    await tester.pumpAndSettle();
    expect(find.text('Markets'), findsWidgets);

    final sample = MarketAsset(
      id: 'btc',
      symbol: 'BTC',
      name: 'Bitcoin',
      type: AssetType.crypto,
      price: 65000,
      changePercent: 2.5,
      currency: 'USD',
    );

    final shellContext = tester.element(find.byType(MainShell));
    await tester.runAsync(() async {
      await Navigator.of(shellContext).push(
        MaterialPageRoute<void>(
          builder: (_) => AssetDetailScreen(asset: sample),
        ),
      );
    });
    await tester.pumpAndSettle();

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsNothing);
  });
}
