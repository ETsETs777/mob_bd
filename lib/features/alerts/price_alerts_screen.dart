// =============================================================================
// EcoPulse · lib/features/alerts/price_alerts_screen.dart
// Автор: Цымбал Е. В.
// Дата: 20.06.2026
// Модуль EcoPulse. Файл: price_alerts_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/price_alert_eval.dart';
import '../../data/models/price_alert.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/alert_history_provider.dart';
import '../../providers/alert_quiet_hours_provider.dart';
import '../../providers/price_alerts_provider.dart';

/// Класс [PriceAlertsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class PriceAlertsScreen extends ConsumerWidget {
/// Создаёт [PriceAlertsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  const PriceAlertsScreen({super.key});

/// Отрисовывает UI [PriceAlertsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final alerts = ref.watch(priceAlertsProvider);
    final history = ref.watch(alertHistoryProvider);
    final quiet = ref.watch(alertQuietHoursProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.alertsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context, ref),
        icon: const Icon(Iconsax.add),
        label: Text(l10n.alertsAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _QuietHoursCard(quiet: quiet, l10n: l10n, palette: palette, ref: ref),
          const Gap(12),
          if (alerts.isEmpty && history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(Iconsax.notification,
                      size: 56, color: palette.textSecondary),
                  const Gap(16),
                  Text(
                    l10n.alertsEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: palette.textSecondary),
                  ),
                ],
              ),
            )
          else ...[
            ...alerts.map((alert) {
              final conditionLabel = _conditionLabel(alert, l10n);
              final kindLabel = alert.isPercentChange
                  ? l10n.alertsKindPercentChange
                  : l10n.alertsKindThreshold;
              final thresholdText = alert.isPercentChange
                  ? '${alert.threshold.toStringAsFixed(1)}%'
                  : alert.threshold.toStringAsFixed(2);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      alert.enabled
                          ? Iconsax.notification
                          : Iconsax.notification_1,
                      color: alert.enabled
                          ? palette.accent
                          : palette.textSecondary,
                    ),
                    title: Text(
                      '${alert.symbol.label} · $kindLabel · $conditionLabel $thresholdText',
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: alert.lastNotifiedAt != null
                        ? Text(
                            l10n.alertsLastTriggered(
                              _formatTime(alert.lastNotifiedAt!),
                            ),
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 12,
                            ),
                          )
                        : Text(
                            l10n.alertsCheckOnRefresh,
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: alert.enabled,
                          onChanged: (_) => ref
                              .read(priceAlertsProvider.notifier)
                              .toggleEnabled(alert.id),
                        ),
                        IconButton(
                          icon: Icon(Iconsax.trash,
                              color: palette.negative, size: 20),
                          onPressed: () => ref
                              .read(priceAlertsProvider.notifier)
                              .remove(alert.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (history.isNotEmpty) ...[
              const Gap(16),
              Text(
                l10n.alertsHistoryTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: palette.accent,
                ),
              ),
              const Gap(8),
              ...history.reversed.map(
                (entry) => Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      '${entry.symbol} · ${entry.message}',
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      _formatTime(entry.triggeredAt),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _conditionLabel(PriceAlert alert, AppLocalizations l10n) {
    if (alert.isPercentChange) {
      return alert.isAbove ? l10n.alertsConditionRise : l10n.alertsConditionDrop;
    }
    return alert.isAbove ? l10n.alertsConditionAbove : l10n.alertsConditionBelow;
  }

/// Приватный метод [_formatTime] класса [PriceAlertsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  String _formatTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

/// Приватный метод [_showAddSheet] класса [PriceAlertsScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddAlertSheet(
        onSave: (alert) async {
          await ref.read(priceAlertsProvider.notifier).add(alert);
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}

class _QuietHoursCard extends StatelessWidget {
  const _QuietHoursCard({
    required this.quiet,
    required this.l10n,
    required this.palette,
    required this.ref,
  });

  final AlertQuietHoursSettings quiet;
  final AppLocalizations l10n;
  final AppPalette palette;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.moon, size: 18, color: palette.accent),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.alertsQuietHoursTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: palette.accent,
                    ),
                  ),
                ),
                Switch(
                  value: quiet.enabled,
                  onChanged: (v) => ref
                      .read(alertQuietHoursProvider.notifier)
                      .setEnabled(v),
                ),
              ],
            ),
            Text(
              l10n.alertsQuietHoursSubtitle,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
            if (quiet.enabled) ...[
              const Gap(8),
              Text(
                l10n.alertsQuietHoursRange(quiet.startHour, quiet.endHour),
                style: TextStyle(fontSize: 12, color: palette.textPrimary),
              ),
              const Gap(4),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: quiet.startHour,
                      decoration: InputDecoration(
                        labelText: l10n.alertsQuietHoursStart,
                        isDense: true,
                      ),
                      items: [
                        for (var h = 0; h < 24; h++)
                          DropdownMenuItem(value: h, child: Text('$h:00')),
                      ],
                      onChanged: (h) {
                        if (h == null) return;
                        ref.read(alertQuietHoursProvider.notifier).setHours(
                              startHour: h,
                              endHour: quiet.endHour,
                            );
                      },
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: quiet.endHour,
                      decoration: InputDecoration(
                        labelText: l10n.alertsQuietHoursEnd,
                        isDense: true,
                      ),
                      items: [
                        for (var h = 0; h < 24; h++)
                          DropdownMenuItem(value: h, child: Text('$h:00')),
                      ],
                      onChanged: (h) {
                        if (h == null) return;
                        ref.read(alertQuietHoursProvider.notifier).setHours(
                              startHour: quiet.startHour,
                              endHour: h,
                            );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_AddAlertSheet] — bottom sheet.
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class _AddAlertSheet extends StatefulWidget {
/// Создаёт [_AddAlertSheet].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  const _AddAlertSheet({required this.onSave});

/// Поле [onSave] класса [_AddAlertSheet].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final ValueChanged<PriceAlert> onSave;

/// Создаёт State для [_AddAlertSheet].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  State<_AddAlertSheet> createState() => _AddAlertSheetState();
}

/// Приватный класс [_AddAlertSheetState] — bottom sheet.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class _AddAlertSheetState extends State<_AddAlertSheet> {
/// Поле [_symbol] класса [_AddAlertSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  PriceAlertSymbol _symbol = PriceAlertSymbol.usdRub;
/// Поле [_condition] класса [_AddAlertSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  AlertCondition _condition = AlertCondition.above;
/// Поле [_kind] класса [_AddAlertSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  AlertKind _kind = AlertKind.threshold;
/// Поле [_thresholdController] класса [_AddAlertSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final _thresholdController = TextEditingController(text: '90');

/// Освобождает ресурсы [_AddAlertSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_AddAlertSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.alertsAdd,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(12),
          Text(
            l10n.alertsPresetsTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _presetChip(
                l10n.alertsPresetUsd100,
                PriceAlertSymbol.usdRub,
                AlertKind.threshold,
                AlertCondition.above,
                100,
              ),
              _presetChip(
                l10n.alertsPresetBtcDrop5,
                PriceAlertSymbol.btc,
                AlertKind.percentChange,
                AlertCondition.below,
                5,
              ),
              _presetChip(
                l10n.alertsPresetBtcRise5,
                PriceAlertSymbol.btc,
                AlertKind.percentChange,
                AlertCondition.above,
                5,
              ),
              _presetChip(
                l10n.alertsPresetImoexDrop3,
                PriceAlertSymbol.imoex,
                AlertKind.percentChange,
                AlertCondition.below,
                3,
              ),
            ],
          ),
          const Gap(16),
          DropdownButtonFormField<PriceAlertSymbol>(
            initialValue: _symbol,
            decoration: InputDecoration(labelText: l10n.alertsSymbol),
            items: PriceAlertSymbol.values
                .map(
                  (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _symbol = v);
            },
          ),
          const Gap(12),
          SegmentedButton<AlertKind>(
            segments: [
              ButtonSegment(
                value: AlertKind.threshold,
                label: Text(l10n.alertsKindThreshold),
              ),
              ButtonSegment(
                value: AlertKind.percentChange,
                label: Text(l10n.alertsKindPercentChange),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          const Gap(12),
          SegmentedButton<AlertCondition>(
            segments: [
              ButtonSegment(
                value: AlertCondition.above,
                label: Text(
                  _kind == AlertKind.percentChange
                      ? l10n.alertsConditionRise
                      : l10n.alertsConditionAbove,
                ),
              ),
              ButtonSegment(
                value: AlertCondition.below,
                label: Text(
                  _kind == AlertKind.percentChange
                      ? l10n.alertsConditionDrop
                      : l10n.alertsConditionBelow,
                ),
              ),
            ],
            selected: {_condition},
            onSelectionChanged: (s) => setState(() => _condition = s.first),
          ),
          const Gap(12),
          TextField(
            controller: _thresholdController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: _kind == AlertKind.percentChange
                  ? l10n.alertsPercentHint
                  : l10n.alertsThreshold,
            ),
          ),
          const Gap(20),
          FilledButton(
            onPressed: () {
              final threshold =
                  double.tryParse(_thresholdController.text.replaceAll(',', '.'));
              if (threshold == null) return;
              widget.onSave(
                PriceAlert(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  symbol: _symbol,
                  condition: _condition,
                  threshold: threshold,
                  kind: _kind,
                ),
              );
            },
            child: Text(l10n.alertsSave),
          ),
          const Gap(8),
        ],
      ),
    );
  }

  Widget _presetChip(
    String label,
    PriceAlertSymbol symbol,
    AlertKind kind,
    AlertCondition condition,
    double threshold,
  ) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: () => widget.onSave(
        PriceAlert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          symbol: symbol,
          condition: condition,
          threshold: threshold,
          kind: kind,
        ),
      ),
    );
  }
}

/// Функция [showAddPriceAlertSheet] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
void showAddPriceAlertSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _AddAlertSheet(
      onSave: (alert) async {
        await ref.read(priceAlertsProvider.notifier).add(alert);
        if (context.mounted) Navigator.pop(context);
      },
    ),
  );
}
