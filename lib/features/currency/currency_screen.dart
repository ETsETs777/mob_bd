// =============================================================================
// EcoPulse · lib/features/currency/currency_screen.dart
// Автор: Цымбал Е. В.
// Дата: 05.06.2026
// Вкладка валют: курсы, конвертер, сравнение. Файл: currency_screen.
// =============================================================================

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/market_catalog.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/market_list_utils.dart';
import '../../core/utils/sector_labels.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/user_customization.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/commodities_provider.dart';
import '../shared/app_actions.dart';
import '../shared/widgets/app_refresh_indicator.dart';
import '../shared/widgets/charts.dart';
import '../shared/widgets/custom_chart_view.dart';
import '../shared/widgets/last_updated_banner.dart';
import '../shared/widgets/loading_skeleton.dart';
import '../shared/widgets/metric_card.dart';

/// Класс [CurrencyScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class CurrencyScreen extends ConsumerStatefulWidget {
/// Создаёт [CurrencyScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const CurrencyScreen({super.key});

/// Создаёт State для [CurrencyScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreenState();
}

/// Приватный класс [_CurrencyScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _CurrencyScreenState extends ConsumerState<CurrencyScreen> {
/// Поле [_selected] класса [_CurrencyScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  CurrencyRate? _selected;
/// Поле [_comparePairs] класса [_CurrencyScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final Set<String> _comparePairs = {};

/// Инициализация state [_CurrencyScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(refreshTimeProvider(RefreshScope.currency)) == null) {
        markRefreshed(ref, RefreshScope.currency);
      }
    });
  }

/// Отрисовывает UI [_CurrencyScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    final ratesAsync = ref.watch(currencyRatesProvider);
    final amount = ref.watch(converterAmountProvider);
    final from = ref.watch(converterFromProvider);
    final to = ref.watch(converterToProvider);
    final fee = ref.watch(converterFeeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabCurrency)),
      body: ratesAsync.when(
        loading: () => const LoadingSkeleton(),
        error: (e, _) {
          final palette = AppPalette.of(context);
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.currencyLoadError,
                  style: TextStyle(color: palette.negative),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      ref.read(currencyRatesProvider.notifier).refresh(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        },
        data: (rates) {
          _selected ??= rates.firstOrNull;
          final selected = _selected ?? rates.first;

          final listContent = _CurrencyListContent(
            rates: rates,
            selected: selected,
            comparePairs: _comparePairs,
            amount: amount,
            from: from,
            to: to,
            fee: fee,
            l10n: l10n,
            isRussian: Localizations.localeOf(context).languageCode == 'ru',
            onSelectRate: (rate) => setState(() => _selected = rate),
            onToggleCompare: (rate, active) {
              setState(() {
                _selected = rate;
                if (active) {
                  _comparePairs.remove(rate.pairLabel);
                } else if (_comparePairs.length < 3) {
                  _comparePairs.add(rate.pairLabel);
                }
              });
            },
          );

          return AppRefreshIndicator(
            onRefresh: () async {
              await ref.read(currencyRatesProvider.notifier).refresh();
              markRefreshed(ref, RefreshScope.currency);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideLandscape = constraints.maxWidth >= 720 &&
                    MediaQuery.orientationOf(context) ==
                        Orientation.landscape;

                if (isWideLandscape) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(AppSpacing.page),
                          children: listContent.leftColumn,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(AppSpacing.page),
                          children: listContent.rightColumn,
                        ),
                      ),
                    ],
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.page),
                  children: listContent.all,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Приватный класс [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _CurrencyListContent {
/// Создаёт [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const _CurrencyListContent({
    required this.rates,
    required this.selected,
    required this.comparePairs,
    required this.amount,
    required this.from,
    required this.to,
    required this.fee,
    required this.l10n,
    required this.isRussian,
    required this.onSelectRate,
    required this.onToggleCompare,
  });

/// Поле [rates] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final List<CurrencyRate> rates;
/// Поле [selected] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final CurrencyRate selected;
/// Поле [comparePairs] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final Set<String> comparePairs;
/// Поле [amount] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final double amount;
/// Поле [from] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String from;
/// Поле [to] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String to;
/// Поле [fee] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final double fee;
/// Поле [l10n] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final AppLocalizations l10n;
/// Поле [isRussian] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final bool isRussian;
/// Поле [onSelectRate] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final ValueChanged<CurrencyRate> onSelectRate;
/// Поле [onToggleCompare] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final void Function(CurrencyRate rate, bool active) onToggleCompare;

/// Getter [rateCards] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  List<Widget> get rateCards {
    final groups = groupCurrencyRates(rates);
    final widgets = <Widget>[];

    for (final section in groups) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            currencyGroupLabel(section.group, l10n),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      );
      for (final rate in section.rates) {
        final catalog = CurrencyCatalog.byCode(rate.code);
        final subtitle = catalog != null
            ? (isRussian ? catalog.nameRu : catalog.nameEn)
            : (rate.isRub ? l10n.currencyGroupMoex : null);
        final isSelected =
            rate.code == selected.code && rate.isRub == selected.isRub;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HighlightedCard(
              selected: isSelected,
              child: MetricCard(
                title: rate.pairLabel,
                subtitle: subtitle,
                value: rate.isRub
                    ? Formatters.rub(rate.rate)
                    : rate.rate.toStringAsFixed(4),
                numericValue: rate.rate,
                valueFormatter: (v) => rate.isRub
                    ? Formatters.rub(v)
                    : v.toStringAsFixed(4),
                changePercent: rate.changePercent,
                sparkline: rate.history.map((p) => p.value).toList(),
                onTap: () => onSelectRate(rate),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

/// Getter [compareSection] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  List<Widget> get compareSection => [
        const SizedBox(height: 8),
        Text(
          l10n.currencyCompareTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.currencyCompareSubtitle,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: rates.where((r) => r.history.length >= 2).map((rate) {
            final active = comparePairs.contains(rate.pairLabel);
            return FilterChip(
              label: Text(rate.pairLabel),
              selected: active,
              onSelected: (_) => onToggleCompare(rate, active),
            );
          }).toList(),
        ),
        if (comparePairs.isNotEmpty && comparePairs.length < 2)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.currencyCompareSelect,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        const SizedBox(height: 12),
        if (comparePairs.length >= 2)
          CustomChartView(
            contextId: ChartContextId.compare,
            input: ChartRenderInput(
              series: rates
                  .where((r) => comparePairs.contains(r.pairLabel))
                  .map(
                    (r) => ChartLineSeries(
                      label: r.pairLabel,
                      points: r.history,
                    ),
                  )
                  .toList(),
            ),
          )
        else ...[
          Text(
            l10n.currencyChart30d(selected.pairLabel),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          CustomChartView(
            contextId: ChartContextId.currency,
            input: ChartRenderInput(
              points: selected.history,
              currencySymbol: selected.isRub ? '₽' : '',
            ),
          ),
        ],
      ];

/// Getter [converterSection] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  List<Widget> get converterSection => [
        const SizedBox(height: 24),
        Text(
          l10n.currencyConverter,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _ConverterCard(
          rates: rates,
          amount: amount,
          from: from,
          to: to,
          fee: fee,
          l10n: l10n,
        ),
        const SizedBox(height: 24),
        const _ConversionHistorySection(),
      ];

/// Getter [leftColumn] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  List<Widget> get leftColumn => [
        const LastUpdatedBanner(scope: RefreshScope.currency),
        _QuickConvertBar(rates: rates),
        const SizedBox(height: 16),
        ...rateCards,
      ];

/// Getter [rightColumn] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  List<Widget> get rightColumn => [
        ...compareSection,
        ...converterSection,
      ];

/// Getter [all] класса [_CurrencyListContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  List<Widget> get all => [
        ...leftColumn,
        ...rightColumn,
      ];
}

/// Приватный класс [_HighlightedCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _HighlightedCard extends StatelessWidget {
/// Создаёт [_HighlightedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const _HighlightedCard({required this.selected, required this.child});

/// Поле [selected] класса [_HighlightedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final bool selected;
/// Поле [child] класса [_HighlightedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final Widget child;

/// Отрисовывает UI [_HighlightedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    if (!selected) return child;
    final palette = AppPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.accent, width: 1.5),
      ),
      child: child,
    );
  }
}

/// Приватный класс [_ConverterCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _ConverterCard extends ConsumerStatefulWidget {
/// Создаёт [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  const _ConverterCard({
    required this.rates,
    required this.amount,
    required this.from,
    required this.to,
    required this.fee,
    required this.l10n,
  });

/// Поле [rates] класса [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final List<CurrencyRate> rates;
/// Поле [amount] класса [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final double amount;
/// Поле [from] класса [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final String from;
/// Поле [to] класса [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final String to;
/// Поле [fee] класса [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final double fee;
/// Поле [l10n] класса [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final AppLocalizations l10n;

/// Создаёт State для [_ConverterCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  ConsumerState<_ConverterCard> createState() => _ConverterCardState();
}

/// Приватный класс [_ConverterCardState] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class _ConverterCardState extends ConsumerState<_ConverterCard> {
/// Поле [_controller] класса [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  late final TextEditingController _controller;
/// Поле [_feeController] класса [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  late final TextEditingController _feeController;
/// Поле [_lastSavedKey] класса [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  String? _lastSavedKey;

/// Инициализация state [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amount.toString());
    _feeController = TextEditingController(
      text: widget.fee > 0 ? widget.fee.toString() : '',
    );
  }

/// Метод [didUpdateWidget] класса [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  void didUpdateWidget(covariant _ConverterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        _controller.text != widget.amount.toString()) {
      _controller.text = widget.amount.toString();
    }
    if (oldWidget.fee != widget.fee &&
        _feeController.text != widget.fee.toString()) {
      _feeController.text =
          widget.fee > 0 ? widget.fee.toString() : '';
    }
  }

/// Освобождает ресурсы [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  void dispose() {
    _controller.dispose();
    _feeController.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final currencies = [
      'USD',
      'RUB',
      ...widget.rates.where((CurrencyRate r) => !r.isRub).map((r) => r.code),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: widget.l10n.currencyAmount),
              onChanged: (v) =>
                  ref.read(converterAmountProvider.notifier).state =
                      double.tryParse(v.replaceAll(',', '.')) ?? 0,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: widget.from,
                    decoration: InputDecoration(labelText: widget.l10n.currencyFrom),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(converterFromProvider.notifier).state = v;
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, color: palette.accent),
                  onPressed: () {
                    final from = ref.read(converterFromProvider);
                    final to = ref.read(converterToProvider);
                    ref.read(converterFromProvider.notifier).state = to;
                    ref.read(converterToProvider.notifier).state = from;
                  },
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: widget.to,
                    decoration: InputDecoration(labelText: widget.l10n.currencyTo),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(converterToProvider.notifier).state = v;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: widget.l10n.currencyFee,
                suffixText: '%',
              ),
              onChanged: (v) =>
                  ref.read(converterFeeProvider.notifier).state =
                      double.tryParse(v.replaceAll(',', '.')) ?? 0,
            ),
            const SizedBox(height: 16),
            FutureBuilder<double>(
              future: ref.read(currencyRepositoryProvider).convert(
                    amount: widget.amount,
                    from: widget.from,
                    to: widget.to,
                    rates: widget.rates,
                  ),
              builder: (context, snapshot) {
                final raw = snapshot.data;
                final result = raw != null ? raw * (1 - widget.fee / 100) : null;
                if (result != null && widget.amount > 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    _saveConversion(
                      widget.amount,
                      widget.from,
                      widget.to,
                      result,
                    );
                  });
                }
                return Text(
                  result != null
                      ? '= ${result.toStringAsFixed(2)} ${widget.to}'
                      : '...',
                  style: AppTypography.quote(
                    TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: palette.accent,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

/// Приватный метод [_saveConversion] класса [_ConverterCardState].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  void _saveConversion(double amount, String from, String to, double result) {
    final key =
        '${amount.toStringAsFixed(2)}-$from-$to-${result.toStringAsFixed(2)}';
    if (_lastSavedKey == key) return;
    _lastSavedKey = key;
    ref.read(conversionHistoryProvider.notifier).add(
          amount: amount,
          from: from,
          to: to,
          result: result,
        );
  }
}

/// Приватный класс [_QuickConvertBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class _QuickConvertBar extends ConsumerStatefulWidget {
/// Создаёт [_QuickConvertBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const _QuickConvertBar({required this.rates});

/// Поле [rates] класса [_QuickConvertBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final List<CurrencyRate> rates;

/// Создаёт State для [_QuickConvertBar].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  ConsumerState<_QuickConvertBar> createState() => _QuickConvertBarState();
}

/// Приватный класс [_QuickConvertBarState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class _QuickConvertBarState extends ConsumerState<_QuickConvertBar> {
/// Поле [_controller] класса [_QuickConvertBarState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final _controller = TextEditingController();

/// Освобождает ресурсы [_QuickConvertBarState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/// Приватный метод [_apply] класса [_QuickConvertBarState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  void _apply(String input) {
    final l10n = AppLocalizations.of(context)!;
    final parsed = parseQuickConvert(input);
    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.currencyQuickFormatError),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    ref.read(converterAmountProvider.notifier).state = parsed.amount;
    ref.read(converterFromProvider.notifier).state = parsed.from;
    ref.read(converterToProvider.notifier).state = parsed.to;
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${parsed.amount} ${parsed.from} → ${parsed.to}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

/// Отрисовывает UI [_QuickConvertBarState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: l10n.currencyQuickConvert,
                  hintText: l10n.currencyQuickHint,
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.go,
                onSubmitted: _apply,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => _apply(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_ConversionHistorySection].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
class _ConversionHistorySection extends ConsumerWidget {
/// Создаёт [_ConversionHistorySection].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const _ConversionHistorySection();

/// Отрисовывает UI [_ConversionHistorySection].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(conversionHistoryProvider);
    if (history.isEmpty) return const SizedBox.shrink();

    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.currencyHistory,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...history.map(
          (r) => Card(
            child: ListTile(
              dense: true,
              title: Text(
                '${r.amount.toStringAsFixed(2)} ${r.from} → ${r.result.toStringAsFixed(2)} ${r.to}',
                style: TextStyle(color: palette.textPrimary, fontSize: 14),
              ),
              subtitle: Text(
                DateFormat('HH:mm, dd MMM').format(r.at),
                style: TextStyle(color: palette.textSecondary, fontSize: 12),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.replay, size: 20),
                onPressed: () {
                  ref.read(converterAmountProvider.notifier).state = r.amount;
                  ref.read(converterFromProvider.notifier).state = r.from;
                  ref.read(converterToProvider.notifier).state = r.to;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
