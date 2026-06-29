// =============================================================================
// EcoPulse · test/bond_catalog_test.dart
// Автор: Цымбал Е. В.
// Дата: 23.06.2026
// Unit/widget тест: bond_catalog_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/constants/market_catalog.dart';
import 'package:ecopulse/core/services/assistant/intent_router.dart';
import 'package:ecopulse/core/services/assistant/local_responder.dart';
import 'package:ecopulse/core/services/assistant/assistant_context.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
void main() {
  test('bond catalog has OFZ and corporate entries', () {
    expect(BondCatalog.secids.length, greaterThanOrEqualTo(10));
    final ofz =
        BondCatalog.entries.where((e) => e.category.name == 'ofz').length;
    final corp = BondCatalog.entries
        .where((e) => e.category.name == 'corporate')
        .length;
    expect(ofz, greaterThanOrEqualTo(8));
    expect(corp, greaterThanOrEqualTo(4));
  });

  test('explain bonds opens chapter and markets tab action', () {
    final match = IntentRouter.route('объясни что такое облигации');
    expect(match.intent, AssistantIntent.explain);
    expect(match.explainTopic, 'bonds');

    const ctx = AssistantContext(locale: 'ru');
    final response = LocalResponder.respond(match, ctx);
    expect(response.action?.openCourseChapterIndex, 6);
    expect(response.action?.openMarketsTab, 2);
  });
}
