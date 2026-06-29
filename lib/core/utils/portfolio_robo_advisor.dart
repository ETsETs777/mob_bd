// =============================================================================
// EcoPulse · lib/core/utils/portfolio_robo_advisor.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Robo-advisor lite: рекомендация аллокации и приоритетных действий.
// =============================================================================

import '../../data/models/commodity_quote.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/paper_portfolio_account.dart';
import '../../data/models/portfolio_position.dart';
import '../../data/models/savings_goal.dart';
import 'portfolio_rebalance.dart';

/// Ключи обоснования для l10n.
enum RoboRationaleKey {
  accountIis,
  accountCrypto,
  accountUsd,
  goalShortTerm,
  goalLongTerm,
  fearGreedHigh,
  fearGreedLow,
  emptyPortfolio,
  highCash,
  highCrypto,
  defaultBalanced,
}

/// Совет robo-advisor.
class RoboAdvisorAdvice {
  const RoboAdvisorAdvice({
    required this.recommendedPreset,
    required this.rationaleKeys,
    required this.plan,
    required this.topActions,
    required this.riskScore,
  });

  final RebalancePreset recommendedPreset;
  final List<RoboRationaleKey> rationaleKeys;
  final RebalancePlan plan;
  final List<RebalanceSuggestion> topActions;
  final int riskScore;

  bool presetMatches(RebalancePreset current) => recommendedPreset == current;
}

/// Рекомендует пресет аллокации (0 = conservative, 50 = balanced, 100 = growth).
RebalancePreset recommendRoboPreset({
  required PaperPortfolioKind accountKind,
  required List<SavingsGoal> goals,
  required String activeAccountId,
  FearGreedIndex? fearGreed,
  required PortfolioSnapshot? snapshot,
  DateTime? asOf,
}) {
  final now = asOf ?? DateTime.now();

  if (snapshot == null || snapshot.positions.isEmpty) {
    return RebalancePreset.balanced;
  }

  var score = 50;

  switch (accountKind) {
    case PaperPortfolioKind.iis:
      score -= 15;
    case PaperPortfolioKind.crypto:
      score += 20;
    case PaperPortfolioKind.usd:
      score += 5;
    case PaperPortfolioKind.main:
    case PaperPortfolioKind.custom:
      break;
  }

  final linkedGoals = goals.where(
    (g) => g.linkedAccountId == null || g.linkedAccountId == activeAccountId,
  );

  for (final goal in linkedGoals) {
    final days = goal.daysLeft(now);
    if (days <= 730) score -= 20;
    if (days >= 1825) score += 10;
  }

  if (fearGreed != null) {
    if (fearGreed.value >= 75) score -= 15;
    if (fearGreed.value <= 25) score -= 10;
  }

  final total = snapshot.totalValueRub;
  if (total > 0) {
    final cashPct = (snapshot.portfolio.cashRub / total) * 100;
    if (cashPct > 40) score -= 10;
    final cryptoValue = snapshot.positions
        .where((p) => p.position.type == AssetType.crypto)
        .fold<double>(0, (s, p) => s + p.valueRub);
    if ((cryptoValue / total) * 100 > 35) score -= 15;
  }

  if (score <= 35) return RebalancePreset.conservative;
  if (score > 65) return RebalancePreset.growth;
  return RebalancePreset.balanced;
}

List<RoboRationaleKey> _buildRationale({
  required PaperPortfolioKind accountKind,
  required List<SavingsGoal> goals,
  required String activeAccountId,
  FearGreedIndex? fearGreed,
  required PortfolioSnapshot? snapshot,
  required RebalancePreset preset,
  DateTime? asOf,
}) {
  final now = asOf ?? DateTime.now();
  final keys = <RoboRationaleKey>[];

  if (snapshot == null || snapshot.positions.isEmpty) {
    return [RoboRationaleKey.emptyPortfolio];
  }

  switch (accountKind) {
    case PaperPortfolioKind.iis:
      keys.add(RoboRationaleKey.accountIis);
    case PaperPortfolioKind.crypto:
      keys.add(RoboRationaleKey.accountCrypto);
    case PaperPortfolioKind.usd:
      keys.add(RoboRationaleKey.accountUsd);
    case PaperPortfolioKind.main:
    case PaperPortfolioKind.custom:
      break;
  }

  for (final goal in goals) {
    if (goal.linkedAccountId != null &&
        goal.linkedAccountId != activeAccountId) {
      continue;
    }
    final days = goal.daysLeft(now);
    if (days <= 730 && !keys.contains(RoboRationaleKey.goalShortTerm)) {
      keys.add(RoboRationaleKey.goalShortTerm);
    }
    if (days >= 1825 && !keys.contains(RoboRationaleKey.goalLongTerm)) {
      keys.add(RoboRationaleKey.goalLongTerm);
    }
  }

  if (fearGreed != null) {
    if (fearGreed.value >= 75) keys.add(RoboRationaleKey.fearGreedHigh);
    if (fearGreed.value <= 25) keys.add(RoboRationaleKey.fearGreedLow);
  }

  final total = snapshot.totalValueRub;
  if (total > 0) {
    if ((snapshot.portfolio.cashRub / total) * 100 > 40) {
      keys.add(RoboRationaleKey.highCash);
    }
    final cryptoValue = snapshot.positions
        .where((p) => p.position.type == AssetType.crypto)
        .fold<double>(0, (s, p) => s + p.valueRub);
    if ((cryptoValue / total) * 100 > 35) {
      keys.add(RoboRationaleKey.highCrypto);
    }
  }

  if (keys.isEmpty) keys.add(RoboRationaleKey.defaultBalanced);

  return keys.take(3).toList();
}

int _riskScoreForPreset(RebalancePreset preset) => switch (preset) {
      RebalancePreset.conservative => 25,
      RebalancePreset.balanced => 50,
      RebalancePreset.growth => 75,
      RebalancePreset.custom => 50,
    };

/// Строит полный совет robo-advisor.
RoboAdvisorAdvice buildRoboAdvisorAdvice({
  required PaperPortfolioKind accountKind,
  required List<SavingsGoal> goals,
  required String activeAccountId,
  FearGreedIndex? fearGreed,
  required PortfolioSnapshot? snapshot,
  DateTime? asOf,
}) {
  final preset = recommendRoboPreset(
    accountKind: accountKind,
    goals: goals,
    activeAccountId: activeAccountId,
    fearGreed: fearGreed,
    snapshot: snapshot,
    asOf: asOf,
  );

  final target = PortfolioTargetAllocation.forPreset(preset);
  final plan = snapshot == null
      ? const RebalancePlan(
          totalValueRub: 0,
          suggestions: [],
          maxDriftPercent: 0,
        )
      : computeRebalancePlan(snapshot: snapshot, target: target);

  final topActions = plan.suggestions
      .where((s) => s.action != RebalanceAction.hold)
      .toList()
    ..sort((a, b) => b.deltaRub.abs().compareTo(a.deltaRub.abs()));

  final rationaleKeys = _buildRationale(
    accountKind: accountKind,
    goals: goals,
    activeAccountId: activeAccountId,
    fearGreed: fearGreed,
    snapshot: snapshot,
    preset: preset,
    asOf: asOf,
  );

  return RoboAdvisorAdvice(
    recommendedPreset: preset,
    rationaleKeys: rationaleKeys,
    plan: plan,
    topActions: topActions.take(3).toList(),
    riskScore: _riskScoreForPreset(preset),
  );
}
