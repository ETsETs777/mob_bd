// =============================================================================
// EcoPulse · lib/features/portfolio/portfolio_home_card.dart
// Автор: Цымбал Е. В.
// Дата: 12.06.2026
// Бумажный портфель, аллокация, P&L. Файл: portfolio_home_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/portfolio/live_portfolio_snapshot_provider.dart';
import '../shared/widgets/app_card.dart';
import 'paper_portfolio_screen.dart';
import 'portfolio_allocation_mini.dart';
import 'portfolio_value_ticker.dart';

/// Класс [PortfolioHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.06.2026
class PortfolioHomeCard extends ConsumerWidget {
/// Создаёт [PortfolioHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  const PortfolioHomeCard({super.key});

/// Отрисовывает UI [PortfolioHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveMeta = ref.watch(livePortfolioSnapshotProvider);
    final snapshot = liveMeta?.snapshot ?? ref.watch(portfolioSnapshotProvider);
    final portfolio = ref.watch(paperPortfolioProvider);
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (portfolio.positions.isEmpty) {
      return AppCard(
        onTap: () => _open(context),
        child: Row(
          children: [
            Icon(Iconsax.wallet_3, color: palette.accent),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.portfolioTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    l10n.portfolioEmptySubtitle,
                    style: TextStyle(color: palette.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right_3, color: palette.textSecondary, size: 18),
          ],
        ),
      );
    }

    final snap = snapshot;
    final pnl = snap?.pnlRub ?? 0;
    final pnlPct = snap?.pnlPercent ?? 0;
    final total = snap?.totalValueRub ?? portfolio.cashRub;
    final pnlColor = pnl >= 0 ? palette.positive : palette.negative;

    return AppCard(
      onTap: () => _open(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.wallet_3, color: palette.accent, size: 20),
              const Gap(8),
              Text(
                l10n.portfolioTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(Iconsax.arrow_right_3, color: palette.textSecondary, size: 18),
            ],
          ),
          const Gap(12),
          PortfolioValueTicker(
            totalValueRub: total,
            isLive: liveMeta?.isLive ?? false,
            liveUpdatedAt: liveMeta?.liveUpdatedAt,
            fontSize: 22,
          ),
          const Gap(4),
          Text(
            '${Formatters.percent(pnlPct)} · ${Formatters.rub(pnl.abs())}',
            style: TextStyle(color: pnlColor, fontWeight: FontWeight.w600),
          ),
          if (snap != null) PortfolioAllocationMini(snapshot: snap),
        ],
      ),
    );
  }

/// Приватный метод [_open] класса [PortfolioHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  void _open(BuildContext context) {
    openAppPage<void>(context, const PaperPortfolioScreen());
  }
}

/// Функция [openPaperPortfolio] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
void openPaperPortfolio(BuildContext context) {
  openAppPage<void>(context, const PaperPortfolioScreen());
}
