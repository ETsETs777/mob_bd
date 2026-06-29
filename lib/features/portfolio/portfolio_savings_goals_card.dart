import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/savings_goal.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/portfolio/savings_goals_provider.dart';
import 'add_savings_goal_sheet.dart';

/// Карточка целей накопления на экране портфеля.
class PortfolioSavingsGoalsCard extends ConsumerWidget {
  const PortfolioSavingsGoalsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final goals = ref.watch(savingsGoalsProvider);
    final activeAccountId =
        ref.watch(paperPortfolioStoreProvider).activeAccountId;
    final snapshot = ref.watch(portfolioSnapshotProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.flag, color: palette.accent, size: 20),
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.portfolioSavingsGoalsTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        l10n.portfolioSavingsGoalsSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.add),
                  tooltip: l10n.portfolioSavingsGoalAdd,
                  onPressed: () => showAddSavingsGoalSheet(context, ref),
                ),
              ],
            ),
            const Gap(12),
            if (goals.isEmpty)
              Text(
                l10n.portfolioSavingsGoalEmpty,
                style: TextStyle(color: palette.textSecondary),
              )
            else
              ...goals.map(
                (goal) => _GoalRow(
                  goal: goal,
                  palette: palette,
                  l10n: l10n,
                  currentRub: _currentForGoal(
                    ref,
                    goal,
                    activeAccountId,
                    snapshot?.totalValueRub ?? 0,
                  ),
                  onDelete: () =>
                      ref.read(savingsGoalsProvider.notifier).remove(goal.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _currentForGoal(
    WidgetRef ref,
    SavingsGoal goal,
    String activeAccountId,
    double activeTotal,
  ) {
    final linked = goal.linkedAccountId;
    if (linked == null || linked == activeAccountId) return activeTotal;
    final snap = ref.watch(portfolioSnapshotForAccountProvider(linked));
    return snap?.totalValueRub ?? 0;
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.goal,
    required this.palette,
    required this.l10n,
    required this.currentRub,
    required this.onDelete,
  });

  final SavingsGoal goal;
  final AppPalette palette;
  final AppLocalizations l10n;
  final double currentRub;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressRatio(currentRub);
    final days = goal.daysLeft(DateTime.now());
    final deadlineLabel = days < 0
        ? l10n.portfolioSavingsGoalOverdue
        : l10n.portfolioSavingsGoalDaysLeft(days);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Iconsax.trash, size: 18, color: palette.textSecondary),
                onPressed: onDelete,
              ),
            ],
          ),
          Text(
            l10n.portfolioSavingsGoalProgress(
              Formatters.rub(currentRub),
              Formatters.rub(goal.targetRub),
            ),
            style: TextStyle(fontSize: 13, color: palette.textSecondary),
          ),
          const Gap(6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: palette.border,
              color: palette.accent,
            ),
          ),
          const Gap(4),
          Text(
            deadlineLabel,
            style: TextStyle(fontSize: 11, color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

void showAddSavingsGoalSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => AddSavingsGoalSheet(parentRef: ref),
  );
}
