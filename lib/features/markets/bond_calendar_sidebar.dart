// =============================================================================
// EcoPulse · lib/features/markets/bond_calendar_sidebar.dart
// Автор: Цымбал Е. В.
// Дата: 07.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: bond_calendar_sidebar.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/app_segmented_control.dart';

/// Боковая панель календаря облигаций (фильтры + доход).
class BondCalendarSidebar extends StatelessWidget {
/// Создаёт [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const BondCalendarSidebar({
    super.key,
    required this.horizonDays,
    required this.onHorizonChanged,
    required this.couponIncome,
    required this.l10n,
    required this.palette,
  });

/// Поле [horizonDays] класса [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final int horizonDays;
/// Поле [onHorizonChanged] класса [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final ValueChanged<int> onHorizonChanged;
/// Поле [couponIncome] класса [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final double couponIncome;
/// Поле [l10n] класса [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final AppLocalizations l10n;
/// Поле [palette] класса [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final AppPalette palette;

/// Отрисовывает UI [BondCalendarSidebar].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.bondCalendarFullSubtitle,
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
        const Gap(AppSpacing.md),
        AppSegmentedControl<int>(
          segments: [
            ButtonSegment(
              value: 182,
              label: Text(l10n.bondCalendarHorizon6m),
            ),
            ButtonSegment(
              value: 365,
              label: Text(l10n.bondCalendarHorizon1y),
            ),
            ButtonSegment(
              value: 730,
              label: Text(l10n.bondCalendarHorizon2y),
            ),
          ],
          selected: {horizonDays},
          onSelectionChanged: (selected) {
            if (selected.isEmpty) return;
            onHorizonChanged(selected.first);
          },
        ),
        if (couponIncome > 0) ...[
          const Gap(AppSpacing.md),
          Card(
            child: ListTile(
              leading: Icon(Iconsax.wallet_3, color: palette.positive),
              title: Text(l10n.bondCalendarCouponIncome),
              subtitle: Text(
                l10n.bondCalendarCouponIncomeHint,
                style: TextStyle(fontSize: 11, color: palette.textSecondary),
              ),
              trailing: Text(
                Formatters.rub(couponIncome),
                style: AppTypography.quote(
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    color: palette.positive,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
