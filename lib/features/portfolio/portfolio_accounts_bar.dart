import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/paper_portfolio_account.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import 'add_portfolio_account_sheet.dart';

/// Горизонтальный переключатель бумажных счетов.
class PortfolioAccountsBar extends ConsumerWidget {
  const PortfolioAccountsBar({super.key});

  static String kindLabel(AppLocalizations l10n, PaperPortfolioKind kind) =>
      switch (kind) {
        PaperPortfolioKind.main => l10n.portfolioAccountKindMain,
        PaperPortfolioKind.iis => l10n.portfolioAccountKindIis,
        PaperPortfolioKind.usd => l10n.portfolioAccountKindUsd,
        PaperPortfolioKind.crypto => l10n.portfolioAccountKindCrypto,
        PaperPortfolioKind.custom => l10n.portfolioAccountKindCustom,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final store = ref.watch(paperPortfolioStoreProvider);
    final activeId = store.activeAccountId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.portfolioAccountsTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: store.accounts.length >= 8
                  ? null
                  : () => showAddPortfolioAccountSheet(context, ref),
              icon: Icon(Iconsax.add, size: 18, color: palette.accent),
              label: Text(l10n.portfolioAccountsAdd),
            ),
          ],
        ),
        const Gap(8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: store.accounts.length,
            separatorBuilder: (_, _) => const Gap(8),
            itemBuilder: (context, index) {
              final account = store.accounts[index];
              final selected = account.id == activeId;
              return FilterChip(
                selected: selected,
                label: Text(account.name),
                avatar: Icon(
                  _iconFor(account.kind),
                  size: 16,
                  color: selected ? palette.accent : palette.textSecondary,
                ),
                onSelected: (_) {
                  ref
                      .read(paperPortfolioStoreProvider.notifier)
                      .switchAccount(account.id);
                },
                onDeleted: account.id != 'main' && store.accounts.length > 1
                    ? () => _confirmDelete(context, ref, account, l10n)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _iconFor(PaperPortfolioKind kind) => switch (kind) {
        PaperPortfolioKind.main => Iconsax.wallet_3,
        PaperPortfolioKind.iis => Iconsax.shield_tick,
        PaperPortfolioKind.usd => Iconsax.dollar_circle,
        PaperPortfolioKind.crypto => Iconsax.coin_1,
        PaperPortfolioKind.custom => Iconsax.folder_2,
      };

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PaperPortfolioAccount account,
    AppLocalizations l10n,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.portfolioAccountDelete),
        content: Text(l10n.portfolioAccountDeleteConfirm(account.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.portfolioAccountDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref
          .read(paperPortfolioStoreProvider.notifier)
          .deleteAccount(account.id);
    }
  }
}

void showAddPortfolioAccountSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => AddPortfolioAccountSheet(parentRef: ref),
  );
}
