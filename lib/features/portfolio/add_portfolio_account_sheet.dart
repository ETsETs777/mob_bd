import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../data/models/paper_portfolio_account.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import 'portfolio_accounts_bar.dart';

class AddPortfolioAccountSheet extends ConsumerStatefulWidget {
  const AddPortfolioAccountSheet({super.key, required this.parentRef});

  final WidgetRef parentRef;

  @override
  ConsumerState<AddPortfolioAccountSheet> createState() =>
      _AddPortfolioAccountSheetState();
}

class _AddPortfolioAccountSheetState
    extends ConsumerState<AddPortfolioAccountSheet> {
  final _nameController = TextEditingController();
  PaperPortfolioKind _kind = PaperPortfolioKind.iis;

  @override
  void dispose() {
    _nameController.dispose();
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
            l10n.portfolioAccountsAdd,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.portfolioAccountNameHint,
              hintText: PortfolioAccountsBar.kindLabel(l10n, _kind),
            ),
          ),
          const Gap(12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PaperPortfolioKind.values
                .where((k) => k != PaperPortfolioKind.main)
                .map(
                  (kind) => ChoiceChip(
                    label: Text(PortfolioAccountsBar.kindLabel(l10n, kind)),
                    selected: _kind == kind,
                    onSelected: (_) => setState(() => _kind = kind),
                  ),
                )
                .toList(),
          ),
          const Gap(16),
          FilledButton(
            onPressed: _create,
            child: Text(l10n.portfolioAccountCreate),
          ),
        ],
      ),
    );
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final account = await widget.parentRef
        .read(paperPortfolioStoreProvider.notifier)
        .createAccount(
          name: name.isEmpty
              ? PortfolioAccountsBar.kindLabel(l10n, _kind)
              : name,
          kind: _kind,
        );
    if (!mounted) return;
    if (account == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.portfolioAccountMaxReached)),
      );
      return;
    }
    Navigator.pop(context);
  }
}
