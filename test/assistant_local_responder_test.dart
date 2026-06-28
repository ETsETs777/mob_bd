// =============================================================================
// EcoPulse · test/assistant_local_responder_test.dart
// Автор: Цымбал Е. В.
// Дата: 22.06.2026
// Unit/widget тест: assistant_local_responder_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/services/assistant/assistant_context.dart';
import 'package:ecopulse/core/services/assistant/intent_router.dart';
import 'package:ecopulse/core/services/assistant/local_responder.dart';
import 'package:ecopulse/features/home/economic_brief.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
void main() {
  const ctx = AssistantContext(
    usdRub: 92.5,
    eurRub: 100.2,
    btcPrice: 65000,
    btcChange: 1.5,
    ethPrice: 3500,
    locale: 'ru',
  );

  group('LocalResponder', () {
    test('usd price text', () {
      const match = IntentMatch(
        intent: AssistantIntent.priceQuery,
        priceSymbol: PriceSymbol.usdRub,
      );
      final r = LocalResponder.respond(match, ctx);
      expect(r.text, contains('92.50'));
      expect(r.text, contains('USD/RUB'));
    });

    test('btc price with change', () {
      const match = IntentMatch(
        intent: AssistantIntent.priceQuery,
        priceSymbol: PriceSymbol.btc,
      );
      final r = LocalResponder.respond(match, ctx);
      expect(r.text, contains('65000'));
      expect(r.text, contains('1.50%'));
    });

    test('brief with lines', () {
      const match = IntentMatch(intent: AssistantIntent.brief);
      const briefCtx = AssistantContext(
        locale: 'ru',
        briefLines: [
          BriefLine(label: 'USD', text: 'USD/RUB вырос'),
          BriefLine(label: 'BTC', text: 'BTC стабилен', isPositive: true),
        ],
      );
      final r = LocalResponder.respond(match, briefCtx);
      expect(r.text, contains('Сводка'));
      expect(r.text, contains('USD/RUB вырос'));
    });

    test('portfolio with totals', () {
      const match = IntentMatch(intent: AssistantIntent.portfolio);
      const portCtx = AssistantContext(
        locale: 'en',
        portfolioTotalRub: 150000,
        portfolioPnlPct: 3.25,
      );
      final r = LocalResponder.respond(match, portCtx);
      expect(r.text, contains('150000'));
      expect(r.text, contains('3.25%'));
    });

    test('navigate action', () {
      const match = IntentMatch(
        intent: AssistantIntent.navigate,
        navigation: NavigationTarget.markets,
      );
      final r = LocalResponder.respond(match, ctx);
      expect(r.action?.navigateTo, NavigationTarget.markets);
      expect(r.text, contains('рынки'));
    });

    test('refresh action', () {
      const match = IntentMatch(intent: AssistantIntent.refresh);
      final r = LocalResponder.respond(match, ctx);
      expect(r.action?.refreshData, isTrue);
    });

    test('explain inflation FAQ', () {
      const match = IntentMatch(
        intent: AssistantIntent.explain,
        explainTopic: 'inflation',
      );
      final r = LocalResponder.respond(match, ctx);
      expect(r.text.length, greaterThan(20));
    });
  });
}
