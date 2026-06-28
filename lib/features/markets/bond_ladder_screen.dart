import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/chart_share.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../asset_detail/asset_detail_screen.dart';
import '../shared/widgets/app_hover.dart';
import 'bond_analytics_hero_title.dart';

/// StatefulWidget [BondLadderContent] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class BondLadderContent extends StatefulWidget {
/// Создаёт [BondLadderContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const BondLadderContent({
    super.key,
    required this.bonds,
    this.accordion = false,
    this.previewMaxYears,
    this.includeYears,
  });

/// Поле [bonds] класса [BondLadderContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final List<MarketAsset> bonds;
/// Поле [accordion] класса [BondLadderContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final bool accordion;
/// Поле [previewMaxYears] класса [BondLadderContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final int? previewMaxYears;
  /// Ограничить отображение конкретными годами (wide layout).
  final Set<int>? includeYears;

/// Создаёт State для [BondLadderContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  State<BondLadderContent> createState() => _BondLadderContentState();
}

/// Приватный класс [_BondLadderContentState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _BondLadderContentState extends State<BondLadderContent> {
/// Поле [_expandedYears] класса [_BondLadderContentState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  late Set<int> _expandedYears;

/// Инициализация state [_BondLadderContentState].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  void initState() {
    super.initState();
    _expandedYears = _initialExpanded();
  }

/// Метод [didUpdateWidget] класса [_BondLadderContentState].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  @override
  void didUpdateWidget(covariant BondLadderContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bonds != widget.bonds) {
      _expandedYears = _initialExpanded();
    }
  }

/// Приватный метод [_initialExpanded] класса [_BondLadderContentState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  Set<int> _initialExpanded() {
    final ladder = buildBondLadderByYear(widget.bonds);
    if (ladder.isEmpty) return {};
    if (!widget.accordion) return ladder.keys.toSet();
    final first = ladder.keys.first;
    return {first};
  }

/// Отрисовывает UI [_BondLadderContentState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final ladder = buildBondLadderByYear(widget.bonds);
    if (ladder.isEmpty) return const SizedBox.shrink();

    final maxYield = widget.bonds
        .where((b) => b.yieldPercent != null)
        .map((b) => b.yieldPercent!)
        .fold<double>(0, (m, v) => v > m ? v : m);

    final entries = ladder.entries.toList();
    var visibleEntries = widget.includeYears != null
        ? entries.where((e) => widget.includeYears!.contains(e.key)).toList()
        : entries;
    if (widget.previewMaxYears != null && widget.includeYears == null) {
      visibleEntries = visibleEntries.take(widget.previewMaxYears!).toList();
    }
    final hiddenYears = widget.includeYears != null
        ? 0
        : entries.length - visibleEntries.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in visibleEntries)
          _YearSection(
            year: entry.key,
            items: entry.value,
            maxYield: maxYield,
            palette: palette,
            l10n: l10n,
            accordion: widget.accordion,
            expanded: _expandedYears.contains(entry.key),
            onToggle: () {
              setState(() {
                if (_expandedYears.contains(entry.key)) {
                  _expandedYears.remove(entry.key);
                } else {
                  _expandedYears.add(entry.key);
                }
              });
            },
          ),
        if (hiddenYears > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.bondLadderMoreYears(hiddenYears),
              style: TextStyle(fontSize: 12, color: palette.accent),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

/// Приватный класс [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class _YearSection extends StatelessWidget {
/// Создаёт [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  const _YearSection({
    required this.year,
    required this.items,
    required this.maxYield,
    required this.palette,
    required this.l10n,
    required this.accordion,
    required this.expanded,
    required this.onToggle,
  });

/// Поле [year] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final int year;
/// Поле [items] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final List<MarketAsset> items;
/// Поле [maxYield] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final double maxYield;
/// Поле [palette] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final AppPalette palette;
/// Поле [l10n] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  final AppLocalizations l10n;
/// Поле [accordion] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final bool accordion;
/// Поле [expanded] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final bool expanded;
/// Поле [onToggle] класса [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final VoidCallback onToggle;

/// Отрисовывает UI [_YearSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  Widget build(BuildContext context) {
    final header = Row(
      children: [
        Expanded(
          child: Text(
            l10n.bondLadderYearHeader(year, items.length),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: palette.accent,
              fontSize: 13,
            ),
          ),
        ),
        if (accordion)
          AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: AppMotion.duration(context, AppMotion.fast),
            curve: AppMotion.curve,
            child: Icon(
              Iconsax.arrow_down_1,
              size: 16,
              color: palette.textSecondary,
            ),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (accordion)
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: header,
              ),
            )
          else
            header,
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Gap(6),
                for (final bond in items)
                  _LadderBar(
                    bond: bond,
                    maxYield: maxYield,
                    palette: palette,
                  ),
              ],
            ),
            crossFadeState: !accordion || expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppMotion.duration(context, AppMotion.normal),
            sizeCurve: AppMotion.curve,
          ),
        ],
      ),
    );
  }
}

/// Приватный класс [_LadderBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
class _LadderBar extends StatelessWidget {
/// Создаёт [_LadderBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  const _LadderBar({
    required this.bond,
    required this.maxYield,
    required this.palette,
  });

/// Поле [bond] класса [_LadderBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final MarketAsset bond;
/// Поле [maxYield] класса [_LadderBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final double maxYield;
/// Поле [palette] класса [_LadderBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_LadderBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
  @override
  Widget build(BuildContext context) {
    final ytm = bond.yieldPercent ?? 0;
    final widthFactor =
        maxYield > 0 ? (ytm / maxYield).clamp(0.15, 1.0) : 0.5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AppHoverSurface(
      borderRadius: 8,
      clickable: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => openAppPage(
          context,
          AssetDetailScreen(asset: bond),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(
                bond.symbol.length > 10
                    ? bond.symbol.substring(0, 10)
                    : bond.symbol,
                style: TextStyle(
                  fontSize: 11,
                  color: palette.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, c) {
                  final targetWidth = c.maxWidth * widthFactor;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: targetWidth),
                    duration: AppMotion.duration(context, AppMotion.normal),
                    curve: AppMotion.curve,
                    builder: (_, width, __) => Container(
                      height: 22,
                      width: width,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: palette.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        Formatters.bondYield(bond.yieldPercent),
                        style: AppTypography.quote(
                          TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

/// StatefulWidget [BondLadderScreen] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
class BondLadderScreen extends StatefulWidget {
/// Создаёт [BondLadderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const BondLadderScreen({super.key, required this.bonds});

/// Поле [bonds] класса [BondLadderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final List<MarketAsset> bonds;

/// Создаёт State для [BondLadderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  State<BondLadderScreen> createState() => _BondLadderScreenState();
}

/// Приватный класс [_BondLadderScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
class _BondLadderScreenState extends State<BondLadderScreen> {
/// Поле [_captureKey] класса [_BondLadderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.06.2026
  final _captureKey = GlobalKey();

/// Отрисовывает UI [_BondLadderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final ofzCount =
        widget.bonds.where((b) => b.bondCategory == BondCategory.ofz).length;

    return Scaffold(
      appBar: AppBar(
        title: BondAnalyticsHeroTitle(
          tag: BondAnalyticsHero.ladder,
          text: l10n.bondLadderTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_3),
            tooltip: l10n.shareChart,
            onPressed: () => shareWidgetAsPng(
              boundaryKey: _captureKey,
              fileName: 'ofz_bond_ladder.png',
              text: 'EcoPulse · ${l10n.bondLadderTitle}',
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide =
              constraints.maxWidth >= AppBreakpoints.bondAnalyticsSideBySide;
          final ladder = buildBondLadderByYear(widget.bonds);
          final years = ladder.keys.toList();
          final mid = (years.length / 2).ceil();

          Widget ladderWidget;
          if (wide && years.length > 1) {
            ladderWidget = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BondLadderContent(
                    bonds: widget.bonds,
                    accordion: true,
                    includeYears: years.take(mid).toSet(),
                  ),
                ),
                const Gap(AppSpacing.md),
                Expanded(
                  child: BondLadderContent(
                    bonds: widget.bonds,
                    accordion: true,
                    includeYears: years.skip(mid).toSet(),
                  ),
                ),
              ],
            );
          } else {
            ladderWidget = BondLadderContent(
              bonds: widget.bonds,
              accordion: true,
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              Text(
                l10n.bondLadderFullSubtitle(ofzCount, ladder.length),
                style: TextStyle(color: palette.textSecondary, fontSize: 12),
              ),
              const Gap(AppSpacing.md),
              ChartCaptureBoundary(
                captureKey: _captureKey,
                child: ladderWidget,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Функция [openBondLadderScreen] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
void openBondLadderScreen(BuildContext context, List<MarketAsset> bonds) {
  openBondAnalyticsPage(context, BondLadderScreen(bonds: bonds));
}
