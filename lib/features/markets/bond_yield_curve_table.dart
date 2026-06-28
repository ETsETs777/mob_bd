// =============================================================================
// EcoPulse · lib/features/markets/bond_yield_curve_table.dart
// Автор: Цымбал Е. В.
// Дата: 08.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: bond_yield_curve_table.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../asset_detail/asset_detail_screen.dart';
import '../shared/widgets/app_hover.dart';

/// Таблица точек кривой доходности ОФЗ.
class BondYieldCurveTable extends StatelessWidget {
/// Создаёт [BondYieldCurveTable].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const BondYieldCurveTable({
    super.key,
    required this.curve,
    this.compact = false,
  });

/// Поле [curve] класса [BondYieldCurveTable].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final List<BondYieldPoint> curve;
/// Поле [compact] класса [BondYieldCurveTable].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final bool compact;

/// Отрисовывает UI [BondYieldCurveTable].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  Widget build(BuildContext context) {
    if (curve.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
          Text(
            l10n.bondYieldCurveTableTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Gap(AppSpacing.sm),
        ],
        ...curve.map((pt) => _CurveRow(point: pt, palette: palette, l10n: l10n)),
      ],
    );
  }
}

/// Приватный класс [_CurveRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _CurveRow extends StatelessWidget {
/// Создаёт [_CurveRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const _CurveRow({
    required this.point,
    required this.palette,
    required this.l10n,
  });

/// Поле [point] класса [_CurveRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final BondYieldPoint point;
/// Поле [palette] класса [_CurveRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final AppPalette palette;
/// Поле [l10n] класса [_CurveRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final AppLocalizations l10n;

/// Отрисовывает UI [_CurveRow].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    final bond = point.bond;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppHoverSurface(
        borderRadius: AppRadii.chip,
        clickable: true,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardBorder),
          title: Text(
            bond.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            '${bond.symbol} · ${point.yearsToMaturity.toStringAsFixed(1)} ${l10n.bondYearsShort}',
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
          ),
          trailing: Text(
            Formatters.bondYield(point.yieldPercent),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: palette.accent,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          onTap: () => openAppPage(
            context,
            AssetDetailScreen(asset: bond),
          ),
        ),
      ),
    );
  }
}
