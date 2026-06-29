import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/portfolio/savings_goals_provider.dart';

class AddSavingsGoalSheet extends ConsumerStatefulWidget {
  const AddSavingsGoalSheet({super.key, required this.parentRef});

  final WidgetRef parentRef;

  @override
  ConsumerState<AddSavingsGoalSheet> createState() =>
      _AddSavingsGoalSheetState();
}

class _AddSavingsGoalSheetState extends ConsumerState<AddSavingsGoalSheet> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController(text: '100000');
  DateTime _deadline = DateTime.now().add(const Duration(days: 180));
  bool _linkAccount = true;

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.portfolioSavingsGoalAdd,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.portfolioSavingsGoalTitleHint,
            ),
          ),
          const Gap(12),
          TextField(
            controller: _targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.portfolioSavingsGoalTargetHint,
            ),
          ),
          const Gap(12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.portfolioSavingsGoalDeadline),
            subtitle: Text(
              MaterialLocalizations.of(context).formatMediumDate(_deadline),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.portfolioSavingsGoalLinkedAccount),
            value: _linkAccount,
            onChanged: (v) => setState(() => _linkAccount = v),
          ),
          const Gap(16),
          FilledButton(
            onPressed: _save,
            child: Text(l10n.portfolioSavingsGoalAdd),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final target = double.tryParse(
      _targetController.text.replaceAll(',', '.').trim(),
    );
    if (title.isEmpty || target == null || target <= 0) return;

    final accountId = widget.parentRef.read(paperPortfolioStoreProvider).activeAccountId;
    await widget.parentRef.read(savingsGoalsProvider.notifier).add(
          title: title,
          targetRub: target,
          deadline: _deadline,
          linkedAccountId: _linkAccount ? accountId : null,
        );
    if (mounted) Navigator.pop(context);
  }
}
