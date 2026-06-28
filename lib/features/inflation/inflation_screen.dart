// =============================================================================
// EcoPulse · lib/features/inflation/inflation_screen.dart
// Автор: Цымбал Е. В.
// Дата: 05.06.2026
// Инфляция по странам, графики, детали. Файл: inflation_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/motion/app_motion.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/inflation_chart_utils.dart';
import '../../core/utils/rate_inflation_utils.dart';
import '../../core/utils/inflation_math.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inflation_point.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../calculators/finance_calculators.dart';
import '../shared/app_actions.dart';
import '../shared/widgets/charts.dart';
import '../shared/widgets/last_updated_banner.dart';
import '../shared/widgets/loading_skeleton.dart';
import '../shared/widgets/app_card.dart';
import '../shared/widgets/app_refresh_indicator.dart';

/// Класс [InflationScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class InflationScreen extends ConsumerStatefulWidget {
/// Создаёт [InflationScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const InflationScreen({super.key});

/// Создаёт State для [InflationScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  ConsumerState<InflationScreen> createState() => _InflationScreenState();
}

/// Приватный класс [_InflationScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _InflationScreenState extends ConsumerState<InflationScreen>
    with SingleTickerProviderStateMixin {
/// Поле [_tabs] класса [_InflationScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  late final TabController _tabs;

/// Инициализация state [_InflationScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(refreshTimeProvider(RefreshScope.inflation)) == null) {
        markRefreshed(ref, RefreshScope.inflation);
      }
    });
  }

/// Освобождает ресурсы [_InflationScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_InflationScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final inflationAsync = ref.watch(inflationProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabInflation),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: palette.accent,
          indicatorAnimation: TabIndicatorAnimation.elastic,
          labelColor: palette.accent,
          unselectedLabelColor: palette.textSecondary,
          tabs: [
            Tab(text: l10n.inflationTabCountries),
            Tab(text: l10n.inflationTabCalculator),
            Tab(text: l10n.inflationTabFinance),
          ],
        ),
      ),
      body: inflationAsync.when(
        loading: () => const LoadingSkeleton(),
        error: (e, _) {
          return Center(
            child: Text(
              l10n.errorGeneric(e.toString()),
              style: TextStyle(color: palette.negative),
            ),
          );
        },
        data: (points) => TabBarView(
          controller: _tabs,
          children: [
            _CountriesTab(points: points),
            _InflationCalculatorTab(points: points),
            const FinanceCalculatorsTab(),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_CountriesTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _CountriesTab extends ConsumerStatefulWidget {
/// Создаёт [_CountriesTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const _CountriesTab({required this.points});

/// Поле [points] класса [_CountriesTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final List<InflationPoint> points;

/// Создаёт State для [_CountriesTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  ConsumerState<_CountriesTab> createState() => _CountriesTabState();
}

/// Приватный класс [_CountriesTabState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _CountriesTabState extends ConsumerState<_CountriesTab> {
/// Поле [_compareCountries] класса [_CountriesTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final Set<String> _compareCountries = {};

/// Отрисовывает UI [_CountriesTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final compareSeries = buildInflationCompareSeries(
      widget.points,
      _compareCountries,
    );
    final keyRateAsync = ref.watch(keyRateProvider);
    final ruMatches = widget.points.where((p) => p.countryCode == 'RU');
    final ruInflation = ruMatches.isEmpty ? null : ruMatches.first;
    final rateVsInflation = keyRateAsync.valueOrNull == null
        ? null
        : buildRateVsInflationSeries(
            keyRateHistory: keyRateAsync.valueOrNull!.history,
            ruInflation: ruInflation,
            keyRateLabel: l10n.inflationRateVsKeyRate,
            inflationLabel: l10n.inflationRateVsCpi,
          );

    return AppRefreshIndicator(
      onRefresh: () async {
        await ref.read(inflationProvider.notifier).refresh();
        markRefreshed(ref, RefreshScope.inflation);
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          const LastUpdatedBanner(scope: RefreshScope.inflation),
          Text(
            l10n.inflationCpiTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(4),
          Text(
            l10n.inflationWorldBankNote,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
          ),
          const Gap(16),
          BarChartWidget(
            labels: widget.points.map((p) => p.countryCode).toList(),
            values: widget.points.map((p) => p.value).toList(),
          ),
          if (rateVsInflation != null) ...[
            const Gap(24),
            Text(
              l10n.inflationRateVsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(4),
            Text(
              l10n.inflationRateVsSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(12),
            MultiLineChartWidget(
              normalized: false,
              valueSuffix: '%',
              series: [
                ChartLineSeries(
                  label: rateVsInflation.keyRateLabel,
                  points: rateVsInflation.keyRatePoints,
                ),
                ChartLineSeries(
                  label: rateVsInflation.inflationLabel,
                  points: rateVsInflation.inflationPoints,
                ),
              ],
            ),
          ],
          const Gap(24),
          Text(
            l10n.inflationCompareTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(4),
          Text(
            l10n.inflationCompareSubtitle,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const Gap(10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.points
                .where((p) => p.history.length >= 2)
                .map((point) {
              final active = _compareCountries.contains(point.countryCode);
              return FilterChip(
                label: Text(point.countryCode),
                selected: active,
                onSelected: (_) {
                  setState(() {
                    if (active) {
                      _compareCountries.remove(point.countryCode);
                    } else if (_compareCountries.length < 3) {
                      _compareCountries.add(point.countryCode);
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (_compareCountries.isNotEmpty && _compareCountries.length < 2)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                l10n.inflationCompareSelect,
                style: TextStyle(color: palette.textSecondary, fontSize: 12),
              ),
            ),
          if (compareSeries.length >= 2) ...[
            const Gap(12),
            MultiLineChartWidget(
              normalized: false,
              valueSuffix: '%',
              series: compareSeries
                  .map(
                    (s) => ChartLineSeries(
                      label: s.label,
                      points: s.points,
                    ),
                  )
                  .toList(),
            ),
          ],
          const Gap(24),
          ...widget.points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _InflationTile(
                point: point,
                onTap: () => openAppPage(
                  context,
                  InflationDetailScreen(point: point),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Приватный класс [_InflationCalculatorTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class _InflationCalculatorTab extends StatefulWidget {
/// Создаёт [_InflationCalculatorTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const _InflationCalculatorTab({required this.points});

/// Поле [points] класса [_InflationCalculatorTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final List<InflationPoint> points;

/// Создаёт State для [_InflationCalculatorTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  State<_InflationCalculatorTab> createState() =>
      _InflationCalculatorTabState();
}

/// Приватный класс [_InflationCalculatorTabState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class _InflationCalculatorTabState extends State<_InflationCalculatorTab> {
/// Поле [_countryCode] класса [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  String _countryCode = 'RU';
/// Поле [_fromYear] класса [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  int _fromYear = AppConstants.purchasingPowerBaseYear;
/// Поле [_amount] класса [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  double _amount = 1000;
/// Поле [_amountController] класса [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final _amountController = TextEditingController(text: '1000');

/// Освобождает ресурсы [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final matches =
        widget.points.where((p) => p.countryCode == _countryCode);
    final point = matches.isEmpty ? null : matches.first;
    final years = point?.history ?? [];
    final yearOptions = years.map((y) => y.year).toSet().toList()..sort();
    final fromYear = yearOptions.contains(_fromYear)
        ? _fromYear
        : (yearOptions.isNotEmpty
            ? yearOptions.first
            : AppConstants.purchasingPowerBaseYear);
    final toYear = yearOptions.isEmpty ? fromYear : yearOptions.last;

    final result = _calculateInflation(
      amount: _amount,
      history: years,
      fromYear: fromYear,
      toYear: toYear,
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.page),
      children: [
        Text(
          l10n.inflationCalcTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(8),
        Text(
          l10n.inflationCalcSubtitle,
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
        const Gap(20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _countryCode,
                  decoration: InputDecoration(labelText: l10n.inflationCountry),
                  items: widget.points
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.countryCode,
                          child: Text(p.countryName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _countryCode = v;
                        InflationPoint? countryPoint;
                        for (final p in widget.points) {
                          if (p.countryCode == v) {
                            countryPoint = p;
                            break;
                          }
                        }
                        final opts = countryPoint?.history
                                .map((y) => y.year)
                                .toSet()
                                .toList()
                              ??
                            [];
                        if (opts.isNotEmpty && !opts.contains(_fromYear)) {
                          _fromYear = opts.first;
                        }
                      });
                    }
                  },
                ),
                const Gap(12),
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.inflationAmount,
                    suffixText: _countryCode == 'RU' ? '₽' : '\$',
                  ),
                  onChanged: (v) =>
                      setState(() => _amount = double.tryParse(v) ?? 0),
                ),
                const Gap(12),
                if (yearOptions.length > 1)
                  DropdownButtonFormField<int>(
                    value: fromYear,
                    decoration: InputDecoration(labelText: l10n.inflationYear),
                    items: yearOptions
                        .map(
                          (year) => DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _fromYear = v);
                    },
                  ),
                const Gap(20),
                Text(
                  result != null
                      ? _formatMoney(result, _countryCode)
                      : '—',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: palette.accent,
                  ),
                ),
                const Gap(4),
                Text(
                  'эквивалент в $toYear году',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

/// Приватный метод [_calculateInflation] класса [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  double? _calculateInflation({
    required double amount,
    required List<YearValue> history,
    required int fromYear,
    required int toYear,
  }) {
    if (history.isEmpty || fromYear >= toYear) return amount;

    var factor = 1.0;
    for (final entry in history) {
      if (entry.year > fromYear && entry.year <= toYear) {
        factor *= 1 + entry.value / 100;
      }
    }
    return amount * factor;
  }

/// Приватный метод [_formatMoney] класса [_InflationCalculatorTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  String _formatMoney(double value, String code) {
    final symbol = code == 'RU' ? '₽' : '\$';
    return '$symbol${value.toStringAsFixed(0)}';
  }
}

/// Приватный класс [_InflationTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _InflationTile extends StatelessWidget {
/// Создаёт [_InflationTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const _InflationTile({required this.point, required this.onTap});

/// Поле [point] класса [_InflationTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final InflationPoint point;
/// Поле [onTap] класса [_InflationTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final VoidCallback onTap;

/// Отрисовывает UI [_InflationTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final baseYear = AppConstants.purchasingPowerBaseYear;
    final power = purchasingPowerToday(
      baseAmount: 1000,
      fromYear: baseYear,
      history: point.history
          .map((h) => (year: h.year, value: h.value))
          .toList(),
    );
    final currencySymbol = point.countryCode == 'RU' ? '₽' : '\$';
    final powerText = power == null
        ? null
        : point.countryCode == 'RU'
            ? Formatters.rub(power)
            : '\$${power.toStringAsFixed(0)}';

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: ListTile(
        title: Text(point.countryName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${point.year} · World Bank'),
            if (power != null) ...[
              const Gap(6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadii.chip - 2),
                ),
                child: Text(
                  l10n.purchasingPower(
                    '1000$currencySymbol',
                    baseYear,
                    powerText ?? '',
                  ),
                  style: TextStyle(
                    fontSize: 11,
                    color: palette.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        isThreeLine: power != null,
        trailing: Text(
          '${point.value.toStringAsFixed(1)}%',
          style: AppTypography.quote(
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: point.value > 5 ? palette.negative : palette.positive,
            ),
          ),
        ),
      ),
    );
  }
}

/// StatelessWidget [InflationDetailScreen] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class InflationDetailScreen extends StatelessWidget {
/// Создаёт [InflationDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const InflationDetailScreen({super.key, required this.point});

/// Поле [point] класса [InflationDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final InflationPoint point;

/// Отрисовывает UI [InflationDetailScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final history = point.history;

    return Scaffold(
      appBar: AppBar(title: Text(point.countryName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            '${point.value.toStringAsFixed(2)}%',
            style: AppTypography.quote(
              Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: palette.accent,
                  ) ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: palette.accent,
                  ),
            ),
          ),
          Text(
            'Инфляция за ${point.year} год',
            style: TextStyle(color: palette.textSecondary),
          ),
          const Gap(24),
          Text('Динамика', style: Theme.of(context).textTheme.titleMedium),
          const Gap(12),
          BarChartWidget(
            labels: history.map((h) => h.year.toString()).toList(),
            values: history.map((h) => h.value).toList(),
            height: 220,
          ),
          const Gap(16),
          ...history.reversed.map(
            (h) => ListTile(
              title: Text('${h.year}'),
              trailing: Text(
                '${h.value.toStringAsFixed(2)}%',
                style: AppTypography.quote(const TextStyle()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
