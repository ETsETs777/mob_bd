import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/portfolio_robo_advisor.dart';
import '../commodities_provider.dart';
import '../paper_portfolio_provider.dart';
import 'savings_goals_provider.dart';

/// Robo-advisor lite для активного бумажного счёта.
final portfolioRoboAdvisorProvider = Provider<RoboAdvisorAdvice?>((ref) {
  final snapshot = ref.watch(portfolioSnapshotProvider);
  if (snapshot == null || snapshot.totalValueRub <= 0) return null;

  final account = ref.watch(activePaperPortfolioAccountProvider);
  final goals = ref.watch(savingsGoalsProvider);
  final fearGreed = ref.watch(fearGreedProvider).valueOrNull;

  return buildRoboAdvisorAdvice(
    accountKind: account.kind,
    goals: goals,
    activeAccountId: account.id,
    fearGreed: fearGreed,
    snapshot: snapshot,
  );
});
