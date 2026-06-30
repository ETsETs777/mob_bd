import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/portfolio_calendar_import.dart';
import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/calendar_attachment_storage.dart';
import '../../core/utils/user_calendar_plan.dart';
import '../../core/utils/user_calendar_share.dart';
import '../../core/utils/user_calendar_ics.dart';
import '../../core/utils/user_calendar_ics_import.dart';
import '../../core/utils/calendar_plan_focus.dart';
import '../../core/navigation/calendar_navigation_intent.dart';
import '../../data/models/user_calendar_event.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_calendar_provider.dart';
import 'user_calendar_month_grid.dart';
import 'calendar_attachment_preview_screen.dart';
import 'user_calendar_event_form.dart';
import 'user_calendar_helpers.dart';

/// Личный календарь событий (ручные + портфель).
class UserCalendarScreen extends ConsumerStatefulWidget {
  const UserCalendarScreen({super.key});

  @override
  ConsumerState<UserCalendarScreen> createState() => _UserCalendarScreenState();
}

class _UserCalendarScreenState extends ConsumerState<UserCalendarScreen> {
  int _horizonDays = 365;
  DateTime? _gridSelectedDay;
  String? _pendingFocusKey;

  @override
  void initState() {
    super.initState();
    _pendingFocusKey = CalendarNavigationIntent.consumeFocusPlanItemKey();
  }

  void _tryOpenFocusedEvent(UserCalendarPlan plan) {
    final focusKey = _pendingFocusKey;
    if (focusKey == null || !mounted) return;

    final item = findPlanItemByFocusKey(plan, focusKey);
    if (item == null) return;

    _pendingFocusKey = null;
    setState(() => _gridSelectedDay = item.date);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openDetail(context, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final settings = ref.watch(userCalendarSettingsProvider);
    final plan = ref.watch(userCalendarPlanProvider(_horizonDays));
    _tryOpenFocusedEvent(plan);
    final monthEntries = plan.byMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userCalendarTitle),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.import_1),
            tooltip: l10n.userCalendarImportIcs,
            onPressed: () => _showImportIcsDialog(context),
          ),
          IconButton(
            icon: const Icon(Iconsax.calendar_add),
            tooltip: l10n.userCalendarImportPortfolioBatch,
            onPressed: plan.events.isEmpty
                ? null
                : () => _batchImportPortfolio(context, plan, l10n),
          ),
          if (plan.events.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Iconsax.document),
              tooltip: l10n.userCalendarExportIcs,
              onPressed: () {
                final manual = ref.read(userCalendarProvider);
                if (manual.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.userCalendarExportIcsEmpty),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                Share.share(
                  buildUserCalendarIcs(
                    manual,
                    calendarName: l10n.userCalendarTitle,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.export_3),
              tooltip: l10n.userCalendarShare,
              onPressed: () => Share.share(
                buildUserCalendarShareText(l10n, plan),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showUserCalendarEventForm(context),
        icon: const Icon(Iconsax.add),
        label: Text(l10n.userCalendarAddEvent),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.userCalendarSubtitle,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
          ),
          const Gap(12),
          UserCalendarMonthGrid(
            eventDates: eventDatesFromPlan(plan),
            locale: locale,
            onDaySelected: (day) => setState(() => _gridSelectedDay = day),
          ),
          if (_gridSelectedDay != null) ...[
            const Gap(8),
            Text(
              l10n.userCalendarDayEvents(
                MaterialLocalizations.of(context)
                    .formatFullDate(_gridSelectedDay!),
              ),
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13,
              ),
            ),
            const Gap(8),
            ...plan.events
                .where(
                  (e) =>
                      e.date.year == _gridSelectedDay!.year &&
                      e.date.month == _gridSelectedDay!.month &&
                      e.date.day == _gridSelectedDay!.day,
                )
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _CalendarEventTile(
                      item: item,
                      onTap: () => _openDetail(context, item),
                      onLongPress: () => _showEventQuickMenu(context, item),
                    ),
                  ),
                ),
            const Gap(8),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.userCalendarShowPortfolio),
            subtitle: Text(
              l10n.userCalendarShowPortfolioHint,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            value: settings.showPortfolioEvents,
            onChanged: (v) => ref
                .read(userCalendarSettingsProvider.notifier)
                .setShowPortfolioEvents(v),
          ),
          const Gap(8),
          Wrap(
            spacing: 8,
            children: [
              _HorizonChip(
                label: l10n.userCalendarHorizon30,
                selected: _horizonDays == 30,
                onTap: () => setState(() => _horizonDays = 30),
              ),
              _HorizonChip(
                label: l10n.userCalendarHorizon90,
                selected: _horizonDays == 90,
                onTap: () => setState(() => _horizonDays = 90),
              ),
              _HorizonChip(
                label: l10n.userCalendarHorizon365,
                selected: _horizonDays == 365,
                onTap: () => setState(() => _horizonDays = 365),
              ),
            ],
          ),
          const Gap(16),
          Text(
            l10n.userCalendarTotalsTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const Gap(8),
          if (plan.totalsByCurrency.isEmpty)
            Text(
              l10n.userCalendarTotalsEmpty,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in plan.totalsByCurrency.entries)
                  _TotalChip(
                    label: formatCalendarAmount(entry.value, entry.key),
                    palette: palette,
                  ),
              ],
            ),
          const Gap(20),
          if (plan.events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  l10n.userCalendarEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: palette.textSecondary),
                ),
              ),
            )
          else ...[
            for (final month in monthEntries) ...[
              Text(
                monthLabel(month.key, locale),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: palette.accent,
                  fontSize: 15,
                ),
              ),
              const Gap(8),
              Card(
                child: Column(
                  children: [
                    for (var i = 0; i < month.value.length; i++) ...[
                      _CalendarEventTile(
                        item: month.value[i],
                        onTap: () => _openDetail(context, month.value[i]),
                        onLongPress: () =>
                            _showEventQuickMenu(context, month.value[i]),
                      ),
                      if (i < month.value.length - 1)
                        Divider(height: 1, color: palette.border),
                    ],
                  ],
                ),
              ),
              const Gap(16),
            ],
          ],
          const Gap(64),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, UserCalendarPlanItem item) {
    if (item.source == UserCalendarEventSource.manual &&
        item.manualEventId != null) {
      _showManualDetail(context, item);
    } else {
      _showPortfolioDetail(context, item);
    }
  }

  Future<void> _showEventQuickMenu(
    BuildContext context,
    UserCalendarPlanItem item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isManual =
        item.source == UserCalendarEventSource.manual &&
            item.manualEventId != null;

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.eye),
              title: Text(l10n.userCalendarViewDetails),
              onTap: () => Navigator.pop(ctx, 'detail'),
            ),
            if (isManual) ...[
              ListTile(
                leading: const Icon(Iconsax.copy),
                title: Text(l10n.userCalendarDuplicateEvent),
                onTap: () => Navigator.pop(ctx, 'duplicate'),
              ),
              ListTile(
                leading: const Icon(Iconsax.edit),
                title: Text(l10n.userCalendarEditEvent),
                onTap: () => Navigator.pop(ctx, 'edit'),
              ),
              ListTile(
                leading: Icon(Iconsax.trash, color: AppPalette.of(ctx).negative),
                title: Text(l10n.userCalendarDelete),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
            ] else
              ListTile(
                leading: const Icon(Iconsax.calendar_add),
                title: Text(l10n.userCalendarImportFromPortfolio),
                onTap: () => Navigator.pop(ctx, 'import'),
              ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    switch (action) {
      case 'detail':
        _openDetail(context, item);
      case 'duplicate':
        if (item.manualEventId == null) return;
        await ref.read(userCalendarProvider.notifier).duplicateEvent(
              item.manualEventId!,
              titleSuffix: l10n.userCalendarDuplicateSuffix,
            );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.userCalendarDuplicateDone),
            behavior: SnackBarBehavior.floating,
          ),
        );
      case 'edit':
        if (item.manualEventId == null) return;
        final events = ref.read(userCalendarProvider);
        UserCalendarEvent? event;
        for (final e in events) {
          if (e.id == item.manualEventId) {
            event = e;
            break;
          }
        }
        if (event == null) return;
        await showUserCalendarEventForm(context, existing: event);
      case 'delete':
        if (item.manualEventId == null) return;
        final ok = await showDialog<bool>(
          context: context,
          builder: (dCtx) => AlertDialog(
            content: Text(l10n.userCalendarDeleteConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dCtx, false),
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dCtx, true),
                child: Text(l10n.userCalendarDelete),
              ),
            ],
          ),
        );
        if (ok == true && mounted) {
          await ref
              .read(userCalendarProvider.notifier)
              .deleteEvent(item.manualEventId!);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.userCalendarDeleted),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      case 'import':
        await _importPortfolioEvent(context, item, l10n);
    }
  }

  void _showPortfolioDetail(BuildContext context, UserCalendarPlanItem item) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    showAppBottomSheet(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              calendarItemTitle(l10n, item),
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const Gap(8),
            Text(
              DateFormat.yMMMd(locale).format(item.date),
              style: TextStyle(color: palette.textSecondary),
            ),
            if (item.amount != null) ...[
              const Gap(8),
              Text(
                formatCalendarAmount(item.amount!, item.currency),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: palette.positive,
                ),
              ),
            ],
            if (item.isEstimate) ...[
              const Gap(8),
              Chip(
                label: Text(l10n.userCalendarEstimateBadge),
                visualDensity: VisualDensity.compact,
              ),
            ],
            const Gap(16),
            FilledButton.icon(
              onPressed: () => _importPortfolioEvent(context, item, l10n),
              icon: const Icon(Iconsax.calendar_add, size: 18),
              label: Text(l10n.userCalendarImportFromPortfolio),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importPortfolioEvent(
    BuildContext context,
    UserCalendarPlanItem item,
    AppLocalizations l10n,
  ) async {
    final draft = draftFromPortfolioPlanItem(l10n, item);
    await ref.read(userCalendarProvider.notifier).addEvent(
          title: draft.title,
          date: draft.date,
          amount: draft.amount > 0 ? draft.amount : null,
          currency: draft.currency,
          note: draft.note,
        );
    if (!context.mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.userCalendarImportFromPortfolioDone),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showManualDetail(BuildContext context, UserCalendarPlanItem item) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final events = ref.read(userCalendarProvider);
    final event = events.firstWhere((e) => e.id == item.manualEventId);

    showAppBottomSheet(
      context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(event.title, style: Theme.of(ctx).textTheme.titleMedium),
            const Gap(8),
            Text(
              DateFormat.yMMMd(locale).format(event.date),
              style: TextStyle(color: palette.textSecondary),
            ),
            if (event.isRecurring) ...[
              const Gap(8),
              Chip(
                label: Text(calendarRecurrenceLabel(l10n, event.recurrence)),
                visualDensity: VisualDensity.compact,
              ),
            ],
            if (event.reminderDaysBefore.isNotEmpty) ...[
              const Gap(8),
              Text(
                '${l10n.userCalendarFieldReminders}: '
                '${event.reminderDaysBefore.map((d) => l10n.userCalendarReminderDays(d)).join(', ')}',
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              ),
            ],
            if (event.amount != null) ...[
              const Gap(8),
              Text(
                formatCalendarAmount(event.amount!, event.currency),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: palette.positive,
                ),
              ),
            ],
            if (event.note != null && event.note!.isNotEmpty) ...[
              const Gap(12),
              Text(event.note!),
            ],
            if (event.hasAttachment) ...[
              const Gap(12),
              FilledButton.icon(
                onPressed: () => CalendarAttachmentPreviewScreen.open(
                  context,
                  event,
                ),
                icon: const Icon(Iconsax.eye, size: 18),
                label: Text(l10n.userCalendarViewAttachment),
              ),
              const Gap(8),
              OutlinedButton.icon(
                onPressed: () => _shareAttachment(context, event),
                icon: const Icon(Iconsax.export_3, size: 18),
                label: Text(l10n.userCalendarAttachmentShare),
              ),
            ],
            const Gap(16),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(ctx);
                await ref.read(userCalendarProvider.notifier).duplicateEvent(
                      event.id,
                      titleSuffix: l10n.userCalendarDuplicateSuffix,
                    );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.userCalendarDuplicateDone),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Iconsax.copy, size: 18),
              label: Text(l10n.userCalendarDuplicateEvent),
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await showUserCalendarEventForm(context, existing: event);
                    },
                    child: Text(l10n.userCalendarEditEvent),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.negative,
                    ),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (dCtx) => AlertDialog(
                          content: Text(l10n.userCalendarDeleteConfirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, false),
                              child: Text(MaterialLocalizations.of(context)
                                  .cancelButtonLabel),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(dCtx, true),
                              child: Text(l10n.userCalendarDelete),
                            ),
                          ],
                        ),
                      );
                      if (ok == true && context.mounted) {
                        await ref
                            .read(userCalendarProvider.notifier)
                            .deleteEvent(event.id);
                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.userCalendarDeleted),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(l10n.userCalendarDelete),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _batchImportPortfolio(
    BuildContext context,
    UserCalendarPlan plan,
    AppLocalizations l10n,
  ) async {
    final manual = ref.read(userCalendarProvider);
    final pending = portfolioItemsNotYetManual(plan, manual, l10n);
    if (pending.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userCalendarImportPortfolioBatchEmpty),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: Text(l10n.userCalendarImportPortfolioBatch),
        content: Text(l10n.userCalendarImportPortfolioBatchConfirm(pending.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dCtx, true),
            child: Text(l10n.userCalendarImportFromPortfolio),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    var imported = 0;
    for (final item in pending) {
      final draft = draftFromPortfolioPlanItem(l10n, item);
      await ref.read(userCalendarProvider.notifier).addEvent(
            title: draft.title,
            date: draft.date,
            amount: draft.amount > 0 ? draft.amount : null,
            currency: draft.currency,
            note: draft.note,
          );
      imported++;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.userCalendarImportPortfolioBatchDone(imported)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareAttachment(
    BuildContext context,
    UserCalendarEvent event,
  ) async {
    final bytes = CalendarAttachmentStorage.loadBytes(event.id);
    if (bytes == null) return;
    final name = event.attachmentName ?? 'attachment';
    await Share.shareXFiles(
      [XFile.fromData(bytes, name: name, mimeType: event.attachmentMime)],
    );
  }

  Future<void> _showImportIcsDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final ok = await showDialog<Object?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.userCalendarImportIcs),
        content: TextField(
          controller: controller,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: l10n.userCalendarImportIcsHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'file'),
            child: Text(l10n.userCalendarImportIcsFile),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.userCalendarImportIcs),
          ),
        ],
      ),
    );

    if (ok == 'file') {
      controller.dispose();
      if (!context.mounted) return;
      await _importIcsFromFile(context);
      return;
    }

    if (ok != true || !context.mounted) {
      controller.dispose();
      return;
    }

    final drafts = parseIcsText(controller.text);
    controller.dispose();

    if (drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userCalendarImportIcsEmpty),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final imported = await ref.read(userCalendarProvider.notifier).importIcsDrafts(drafts);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.userCalendarImportIcsDone(imported)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _importIcsFromFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ics', 'ical'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.single.bytes;
    if (bytes == null || bytes.isEmpty) return;

    final drafts = parseIcsText(utf8.decode(bytes));
    if (drafts.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userCalendarImportIcsEmpty),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final imported = await ref.read(userCalendarProvider.notifier).importIcsDrafts(drafts);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.userCalendarImportIcsDone(imported)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _HorizonChip extends StatelessWidget {
  const _HorizonChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: palette.accent.withValues(alpha: 0.2),
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({required this.label, required this.palette});

  final String label;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
      ),
    );
  }
}

class _CalendarEventTile extends StatelessWidget {
  const _CalendarEventTile({
    required this.item,
    required this.onTap,
    this.onLongPress,
  });

  final UserCalendarPlanItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isManual = item.source == UserCalendarEventSource.manual;

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor: isManual
            ? palette.accent.withValues(alpha: 0.15)
            : palette.positive.withValues(alpha: 0.15),
        child: Icon(
          isManual ? Iconsax.edit : Iconsax.wallet_3,
          size: 18,
          color: isManual ? palette.accent : palette.positive,
        ),
      ),
      title: Text(calendarItemTitle(l10n, item)),
      subtitle: Row(
        children: [
          Text(DateFormat.MMMd(locale).format(item.date)),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: palette.surfaceLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isManual
                  ? l10n.userCalendarManualBadge
                  : l10n.userCalendarPortfolioBadge,
              style: TextStyle(fontSize: 10, color: palette.textSecondary),
            ),
          ),
          if (item.isEstimate) ...[
            const Gap(4),
            Text(
              l10n.userCalendarEstimateBadge,
              style: TextStyle(fontSize: 10, color: palette.textSecondary),
            ),
          ],
          if (item.hasAttachment) ...[
            const Gap(4),
            Icon(Iconsax.paperclip, size: 12, color: palette.textSecondary),
          ],
          if (item.recurrence != UserCalendarRecurrence.none) ...[
            const Gap(4),
            Icon(Iconsax.refresh, size: 12, color: palette.textSecondary),
          ],
        ],
      ),
      trailing: item.amount != null
          ? Text(
              formatCalendarAmount(item.amount!, item.currency),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.positive,
              ),
            )
          : null,
    );
  }
}
