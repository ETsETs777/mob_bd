import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/data/models/paper_portfolio_account.dart';
import 'package:ecopulse/data/models/portfolio_position.dart';
import 'package:ecopulse/data/models/savings_goal.dart';

void main() {
  test('PaperPortfolioStore json roundtrip', () {
    final store = PaperPortfolioStore(
      activeAccountId: 'main',
      accounts: [
        PaperPortfolioAccount.create(
          id: 'main',
          name: 'Main',
          kind: PaperPortfolioKind.main,
        ),
        PaperPortfolioAccount.create(
          id: 'iis',
          name: 'IIS',
          kind: PaperPortfolioKind.iis,
        ),
      ],
    );
    final decoded = PaperPortfolioStore.fromJson(store.toJson());
    expect(decoded.accounts.length, 2);
    expect(decoded.activeAccountId, 'main');
    expect(decoded.accounts.last.kind, PaperPortfolioKind.iis);
  });

  test('fromLegacyPortfolio preserves cash', () {
    const legacy = PaperPortfolio(
      initialCapitalRub: 80000,
      cashRub: 50000,
    );
    final store = PaperPortfolioStore.fromLegacyPortfolio(legacy);
    expect(store.accounts.length, 1);
    expect(store.activePortfolio.cashRub, 50000);
  });

  test('SavingsGoal progressRatio clamps', () {
    final goal = SavingsGoal(
      id: 'g1',
      title: '100k',
      targetRub: 100000,
      deadline: DateTime(2026, 12, 31),
      createdAt: DateTime(2026, 1, 1),
    );
    expect(goal.progressRatio(50000), 0.5);
    expect(goal.progressRatio(150000), 1.0);
  });

  test('default capital per account kind', () {
    expect(
      PaperPortfolioAccount.defaultCapitalFor(PaperPortfolioKind.iis),
      400000,
    );
    expect(
      PaperPortfolioAccount.defaultCapitalFor(PaperPortfolioKind.crypto),
      50000,
    );
  });
}
