// =============================================================================
// EcoPulse · lib/features/calculators/finance_calculators.dart
// Автор: Цымбал Е. В.
// Дата: 06.06.2026
// Финансовые калькуляторы. Файл: finance_calculators.
// =============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/finance_math.dart';
import '../../core/utils/formatters.dart';
import '../shared/widgets/animated_value_text.dart';

/// Enum [CreditType] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
/// Значение enum [annuity].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
/// Значение enum [differentiated].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
/// Значение enum [differentiated].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
/// Значение enum [annuity].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
enum CreditType { annuity, differentiated }

/// StatefulWidget [FinanceCalculatorsTab] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class FinanceCalculatorsTab extends StatefulWidget {
/// Создаёт [FinanceCalculatorsTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const FinanceCalculatorsTab({super.key});

/// Создаёт State для [FinanceCalculatorsTab].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  State<FinanceCalculatorsTab> createState() => _FinanceCalculatorsTabState();
}

/// Приватный класс [_FinanceCalculatorsTabState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class _FinanceCalculatorsTabState extends State<FinanceCalculatorsTab>
    with SingleTickerProviderStateMixin {
/// Поле [_tabs] класса [_FinanceCalculatorsTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  late final TabController _tabs;

/// Инициализация state [_FinanceCalculatorsTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

/// Освобождает ресурсы [_FinanceCalculatorsTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_FinanceCalculatorsTabState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Column(
      children: [
        TabBar(
          controller: _tabs,
          indicatorColor: palette.accent,
          indicatorAnimation: TabIndicatorAnimation.elastic,
          labelColor: palette.accent,
          unselectedLabelColor: palette.textSecondary,
          tabs: const [
            Tab(text: 'Вклад'),
            Tab(text: 'Кредит'),
            Tab(text: 'Сценарий'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _DepositCalculator(),
              _CreditCalculator(),
              _ScenarioCalculator(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Приватный класс [_DepositCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class _DepositCalculator extends StatefulWidget {
/// Создаёт [_DepositCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const _DepositCalculator();

/// Создаёт State для [_DepositCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  State<_DepositCalculator> createState() => _DepositCalculatorState();
}

/// Приватный класс [_DepositCalculatorState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _DepositCalculatorState extends State<_DepositCalculator> {
/// Поле [_amount] класса [_DepositCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  double _amount = 100000;
/// Поле [_rate] класса [_DepositCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  double _rate = 16;
/// Поле [_months] класса [_DepositCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  int _months = 12;
/// Поле [_capitalize] класса [_DepositCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  bool _capitalize = true;

/// Отрисовывает UI [_DepositCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final monthlyRate = _rate / 100 / 12;
    final result = _capitalize
        ? _amount * math.pow(1 + monthlyRate, _months)
        : _amount * (1 + monthlyRate * _months);
    final profit = result - _amount;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Калькулятор вклада',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(8),
        Text(
          'Сложный процент с ежемесячной капитализацией',
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
        const Gap(16),
        _LiveResultCard(
          value: result,
          format: Formatters.rub,
          secondary: 'Доход: +${Formatters.rub(profit)}',
          secondaryColor: palette.positive,
        ),
        const Gap(16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('Вклад 12 мес.'),
              onPressed: () => setState(() {
                _amount = 500000;
                _rate = 16;
                _months = 12;
                _capitalize = true;
              }),
            ),
            ActionChip(
              label: const Text('Накопительный 24 мес.'),
              onPressed: () => setState(() {
                _amount = 1000000;
                _rate = 14;
                _months = 24;
                _capitalize = true;
              }),
            ),
          ],
        ),
        const Gap(16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _MoneyField(
                  label: 'Сумма вклада',
                  value: _amount,
                  onChanged: (v) => setState(() => _amount = v),
                ),
                const Gap(12),
                _SliderField(
                  label: 'Ставка: ${_rate.toStringAsFixed(1)}% годовых',
                  value: _rate,
                  min: 1,
                  max: 30,
                  onChanged: (v) => setState(() => _rate = v),
                ),
                const Gap(12),
                _SliderField(
                  label: 'Срок: $_months мес.',
                  value: _months.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  onChanged: (v) => setState(() => _months = v.round()),
                ),
                const Gap(8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Капитализация процентов'),
                  value: _capitalize,
                  onChanged: (v) => setState(() => _capitalize = v),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Приватный класс [_CreditCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _CreditCalculator extends StatefulWidget {
/// Создаёт [_CreditCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const _CreditCalculator();

/// Создаёт State для [_CreditCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  State<_CreditCalculator> createState() => _CreditCalculatorState();
}

/// Приватный класс [_CreditCalculatorState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class _CreditCalculatorState extends State<_CreditCalculator> {
/// Поле [_amount] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  double _amount = 1000000;
/// Поле [_rate] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  double _rate = 18;
/// Поле [_months] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  int _months = 36;
/// Поле [_type] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  CreditType _type = CreditType.annuity;

/// Отрисовывает UI [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final monthlyRate = _rate / 100 / 12;

    final payment = _type == CreditType.annuity
        ? _annuityPayment(_amount, monthlyRate, _months)
        : _differentiatedFirst(_amount, monthlyRate, _months);

    final total = _type == CreditType.annuity
        ? payment * _months
        : _differentiatedTotal(_amount, monthlyRate, _months);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Кредитный калькулятор',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(8),
        Text(
          'Аннуитетный или дифференцированный платёж',
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
        const Gap(16),
        _LiveResultCard(
          value: payment,
          format: Formatters.rub,
          secondary: _type == CreditType.annuity
              ? 'Ежемесячный платёж · переплата ${Formatters.rub(total - _amount)}'
              : 'Первый платёж · переплата ${Formatters.rub(total - _amount)}',
          secondaryColor: palette.textSecondary,
        ),
        const Gap(16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('Ипотека 20 лет'),
              onPressed: () => setState(() {
                _amount = 5000000;
                _rate = 18;
                _months = 240;
                _type = CreditType.annuity;
              }),
            ),
            ActionChip(
              label: const Text('Потреб. 3 года'),
              onPressed: () => setState(() {
                _amount = 500000;
                _rate = 22;
                _months = 36;
                _type = CreditType.annuity;
              }),
            ),
          ],
        ),
        const Gap(16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _MoneyField(
                  label: 'Сумма кредита',
                  value: _amount,
                  onChanged: (v) => setState(() => _amount = v),
                ),
                const Gap(12),
                _SliderField(
                  label: 'Ставка: ${_rate.toStringAsFixed(1)}% годовых',
                  value: _rate,
                  min: 5,
                  max: 35,
                  onChanged: (v) => setState(() => _rate = v),
                ),
                const Gap(12),
                _SliderField(
                  label: 'Срок: $_months мес.',
                  value: _months.toDouble(),
                  min: 6,
                  max: 360,
                  divisions: 59,
                  onChanged: (v) => setState(() => _months = v.round()),
                ),
                const Gap(12),
                SegmentedButton<CreditType>(
                  segments: const [
                    ButtonSegment(
                      value: CreditType.annuity,
                      label: Text('Аннуитет'),
                    ),
                    ButtonSegment(
                      value: CreditType.differentiated,
                      label: Text('Дифф.'),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) =>
                      setState(() => _type = s.first),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

/// Приватный метод [_annuityPayment] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  double _annuityPayment(double principal, double monthlyRate, int months) {
    if (monthlyRate == 0) return principal / months;
    final factor = math.pow(1 + monthlyRate, months);
    return principal * monthlyRate * factor / (factor - 1);
  }

/// Приватный метод [_differentiatedFirst] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  double _differentiatedFirst(
    double principal,
    double monthlyRate,
    int months,
  ) {
    return principal / months + principal * monthlyRate;
  }

/// Приватный метод [_differentiatedTotal] класса [_CreditCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  double _differentiatedTotal(
    double principal,
    double monthlyRate,
    int months,
  ) {
    var total = 0.0;
    final part = principal / months;
    for (var i = 0; i < months; i++) {
      total += part + (principal - part * i) * monthlyRate;
    }
    return total;
  }
}

/// Приватный класс [_ScenarioCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class _ScenarioCalculator extends StatefulWidget {
/// Создаёт [_ScenarioCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const _ScenarioCalculator();

/// Создаёт State для [_ScenarioCalculator].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  State<_ScenarioCalculator> createState() => _ScenarioCalculatorState();
}

/// Приватный класс [_ScenarioCalculatorState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _ScenarioCalculatorState extends State<_ScenarioCalculator> {
/// Поле [_amount] класса [_ScenarioCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  double _amount = 5000000;
/// Поле [_baseRate] класса [_ScenarioCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  double _baseRate = 18;
/// Поле [_delta] класса [_ScenarioCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  double _delta = 2;
/// Поле [_months] класса [_ScenarioCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  int _months = 240;

/// Отрисовывает UI [_ScenarioCalculatorState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final scenarioRate = _baseRate + _delta;
    final basePayment = annuityPayment(_amount, _baseRate, _months);
    final scenarioPayment = annuityPayment(_amount, scenarioRate, _months);
    final deltaPayment = scenarioPayment - basePayment;
    final baseDeposit = depositTotal(
      amount: 100000,
      annualRate: _baseRate,
      months: 12,
      capitalize: true,
    );
    final scenarioDeposit = depositTotal(
      amount: 100000,
      annualRate: scenarioRate,
      months: 12,
      capitalize: true,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Что если ставка +${_delta.toStringAsFixed(1)}%?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(8),
        Text(
          'Сравнение ипотеки и вклада при изменении ключевой ставки',
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
        const Gap(16),
        _LiveResultCard(
          value: deltaPayment,
          format: Formatters.rub,
          secondary:
              'Δ платёж/мес: ${Formatters.rub(basePayment)} → ${Formatters.rub(scenarioPayment)}',
          secondaryColor: deltaPayment > 0 ? palette.negative : palette.positive,
        ),
        const Gap(12),
        Card(
          child: ListTile(
            title: const Text('Вклад 100 000 ₽ · 12 мес.'),
            subtitle: Text(
              '${Formatters.rub(baseDeposit)} → ${Formatters.rub(scenarioDeposit)} (+${Formatters.rub(scenarioDeposit - baseDeposit)})',
            ),
          ),
        ),
        const Gap(16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SliderField(
                  label: 'Базовая ставка: ${_baseRate.toStringAsFixed(1)}%',
                  value: _baseRate,
                  min: 5,
                  max: 30,
                  onChanged: (v) => setState(() => _baseRate = v),
                ),
                const Gap(12),
                _SliderField(
                  label: 'Сценарий: +${_delta.toStringAsFixed(1)}%',
                  value: _delta,
                  min: -3,
                  max: 5,
                  divisions: 16,
                  onChanged: (v) => setState(() => _delta = v),
                ),
                const Gap(12),
                _MoneyField(
                  label: 'Сумма кредита',
                  value: _amount,
                  onChanged: (v) => setState(() => _amount = v),
                ),
                const Gap(12),
                _SliderField(
                  label: 'Срок: $_months мес.',
                  value: _months.toDouble(),
                  min: 12,
                  max: 360,
                  divisions: 29,
                  onChanged: (v) => setState(() => _months = v.round()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Приватный класс [_LiveResultCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
class _LiveResultCard extends StatelessWidget {
/// Создаёт [_LiveResultCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  const _LiveResultCard({
    required this.value,
    required this.format,
    required this.secondary,
    this.secondaryColor,
  });

/// Поле [value] класса [_LiveResultCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final double value;
/// Поле [format] класса [_LiveResultCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final String Function(double) format;
/// Поле [secondary] класса [_LiveResultCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final String secondary;
/// Поле [secondaryColor] класса [_LiveResultCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final Color? secondaryColor;

/// Отрисовывает UI [_LiveResultCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Card(
      color: palette.accent.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedValueText(
              value: value,
              format: format,
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: palette.accent,
              ),
            ),
            const Gap(6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                secondary,
                key: ValueKey(secondary),
                style: TextStyle(
                  color: secondaryColor ?? palette.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_MoneyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class _MoneyField extends StatefulWidget {
/// Создаёт [_MoneyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const _MoneyField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

/// Поле [label] класса [_MoneyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final String label;
/// Поле [value] класса [_MoneyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final double value;
/// Поле [onChanged] класса [_MoneyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final ValueChanged<double> onChanged;

/// Создаёт State для [_MoneyField].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  State<_MoneyField> createState() => _MoneyFieldState();
}

/// Приватный класс [_MoneyFieldState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
class _MoneyFieldState extends State<_MoneyField> {
/// Поле [_controller] класса [_MoneyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  late final TextEditingController _controller;

/// Инициализация state [_MoneyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.value.toStringAsFixed(0));
  }

/// Метод [didUpdateWidget] класса [_MoneyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  void didUpdateWidget(covariant _MoneyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        _controller.text != widget.value.toStringAsFixed(0)) {
      _controller.text = widget.value.toStringAsFixed(0);
    }
  }

/// Освобождает ресурсы [_MoneyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_MoneyFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: '₽',
      ),
      onChanged: (v) => widget.onChanged(double.tryParse(v) ?? 0),
    );
  }
}

/// Приватный класс [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
class _SliderField extends StatelessWidget {
/// Создаёт [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

/// Поле [label] класса [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String label;
/// Поле [value] класса [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final double value;
/// Поле [min] класса [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final double min;
/// Поле [max] класса [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final double max;
/// Поле [divisions] класса [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  final int? divisions;
/// Поле [onChanged] класса [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final ValueChanged<double> onChanged;

/// Отрисовывает UI [_SliderField].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
