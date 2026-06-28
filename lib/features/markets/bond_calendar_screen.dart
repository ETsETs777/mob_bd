import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/bond_analytics.dart';
import '../../core/utils/chart_share.dart';
import '../../data/models/market_asset.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/watchlist_provider.dart';
import 'bond_analytics_hero_title.dart';
import 'bond_calendar_sidebar.dart';
import 'bond_event_list.dart';

/// Класс [BondCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class BondCalendarScreen extends ConsumerStatefulWidget {
/// Создаёт [BondCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const BondCalendarScreen({super.key, required this.allBonds});

/// Поле [allBonds] класса [BondCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final List<MarketAsset> allBonds;

/// Создаёт State для [BondCalendarScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  ConsumerState<BondCalendarScreen> createState() => _BondCalendarScreenState();
}

/// Приватный класс [_BondCalendarScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.06.2026
class _BondCalendarScreenState extends ConsumerState<BondCalendarScreen> {
/// Поле [_horizonDays] класса [_BondCalendarScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  int _horizonDays = 365;
/// Поле [_captureKey] класса [_BondCalendarScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final _captureKey = GlobalKey();

/// Отрисовывает UI [_BondCalendarScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final watchlist = ref.watch(watchlistProvider);
    final portfolio = ref.watch(paperPortfolioProvider);

    final trackedKeys = {
      ...watchlist,
      ...portfolio.positions.map((p) => p.assetKey),
    };
    final tracked = widget.allBonds
        .where((b) => trackedKeys.contains(watchlistKey(b)))
        .toList();

    final events = buildBondCalendarEvents(
      tracked,
      horizonDays: _horizonDays,
    );
    final couponIncome = portfolioCouponIncomeEstimate(events, portfolio);

    final sidebar = BondCalendarSidebar(
      horizonDays: _horizonDays,
      onHorizonChanged: (days) => setState(() => _horizonDays = days),
      couponIncome: couponIncome,
      l10n: l10n,
      palette: palette,
    );

    Widget eventsBody;
    if (tracked.isEmpty) {
      eventsBody = Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Text(
          l10n.bondCalendarEmptyTracked,
          textAlign: TextAlign.center,
          style: TextStyle(color: palette.textSecondary),
        ),
      );
    } else if (events.isEmpty) {
      eventsBody = Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Text(
          l10n.bondCalendarEmptyEvents,
          textAlign: TextAlign.center,
          style: TextStyle(color: palette.textSecondary),
        ),
      );
    } else {
      eventsBody = ChartCaptureBoundary(
        captureKey: _captureKey,
        child: BondEventList(events: events, showTimeline: true),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: BondAnalyticsHeroTitle(
          tag: BondAnalyticsHero.calendar,
          text: l10n.bondCalendarTitle,
        ),
        actions: [
          if (events.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.export_3),
              tooltip: l10n.shareChart,
              onPressed: () => shareWidgetAsPng(
                boundaryKey: _captureKey,
                fileName: 'bond_calendar.png',
                text: 'EcoPulse · ${l10n.bondCalendarTitle}',
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide =
              constraints.maxWidth >= AppBreakpoints.bondAnalyticsSideBySide;

          if (wide) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 280, child: sidebar),
                    const Gap(AppSpacing.lg),
                    Expanded(child: eventsBody),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              sidebar,
              const Gap(AppSpacing.md),
              eventsBody,
            ],
          );
        },
      ),
    );
  }
}

/// Функция [openBondCalendarScreen] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
void openBondCalendarScreen(BuildContext context, List<MarketAsset> bonds) {
  openBondAnalyticsPage(context, BondCalendarScreen(allBonds: bonds));
}
