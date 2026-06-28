// =============================================================================
// EcoPulse · test/assistant_intent_router_test.dart
// Автор: Цымбал Е. В.
// Дата: 21.06.2026
// Unit/widget тест: assistant_intent_router_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/services/assistant/intent_router.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
void main() {
  group('IntentRouter', () {
    test('priceQuery RU usd', () {
      final m = IntentRouter.route('сколько стоит btc');
      expect(m.intent, AssistantIntent.priceQuery);
      expect(m.priceSymbol, PriceSymbol.btc);
    });

    test('priceQuery EN dollar', () {
      final m = IntentRouter.route('usd rub rate');
      expect(m.intent, AssistantIntent.priceQuery);
      expect(m.priceSymbol, PriceSymbol.usdRub);
    });

    test('priceQuery euro', () {
      final m = IntentRouter.route('курс евро');
      expect(m.intent, AssistantIntent.priceQuery);
      expect(m.priceSymbol, PriceSymbol.eurRub);
    });

    test('navigate inflation RU', () {
      final m = IntentRouter.route('открой инфляцию');
      expect(m.intent, AssistantIntent.navigate);
      expect(m.navigation, NavigationTarget.inflation);
    });

    test('navigate markets EN', () {
      final m = IntentRouter.route('go to markets');
      expect(m.intent, AssistantIntent.navigate);
      expect(m.navigation, NavigationTarget.markets);
    });

    test('navigate currency', () {
      final m = IntentRouter.route('open currency');
      expect(m.intent, AssistantIntent.navigate);
      expect(m.navigation, NavigationTarget.currency);
    });

    test('brief RU', () {
      final m = IntentRouter.route('что сегодня');
      expect(m.intent, AssistantIntent.brief);
    });

    test('brief EN', () {
      final m = IntentRouter.route('today brief');
      expect(m.intent, AssistantIntent.brief);
    });

    test('portfolio', () {
      final m = IntentRouter.route('мой портфель');
      expect(m.intent, AssistantIntent.portfolio);
    });

    test('portfolio pnl EN', () {
      final m = IntentRouter.route('my portfolio p&l');
      expect(m.intent, AssistantIntent.portfolio);
    });

    test('explain inflation RU', () {
      final m = IntentRouter.route('что такое инфляция');
      expect(m.intent, AssistantIntent.explain);
      expect(m.explainTopic, 'inflation');
    });

    test('explain key rate EN', () {
      final m = IntentRouter.route('explain key rate');
      expect(m.intent, AssistantIntent.explain);
      expect(m.explainTopic, 'keyRate');
    });

    test('setAlert usd above', () {
      final m = IntentRouter.route('алерт usd/rub выше 90');
      expect(m.intent, AssistantIntent.setAlert);
      expect(m.alertSymbol, 'usdRub');
      expect(m.alertThreshold, 90);
      expect(m.alertAbove, isTrue);
    });

    test('refresh RU', () {
      final m = IntentRouter.route('обнови данные');
      expect(m.intent, AssistantIntent.refresh);
    });

    test('refresh EN', () {
      final m = IntentRouter.route('refresh data');
      expect(m.intent, AssistantIntent.refresh);
    });

    test('general unknown', () {
      final m = IntentRouter.route('расскажи анекдот про экономику');
      expect(m.intent, AssistantIntent.general);
    });

    test('eth price', () {
      final m = IntentRouter.route('how much is eth');
      expect(m.intent, AssistantIntent.priceQuery);
      expect(m.priceSymbol, PriceSymbol.eth);
    });

    test('course RU', () {
      final m = IntentRouter.route('открой курс инвестирования');
      expect(m.intent, AssistantIntent.course);
    });
  });
}
