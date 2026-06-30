import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/utils/calendar_attachment_storage.dart';
import '../../data/models/user_calendar_event.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_calendar_provider.dart';

/// Форма добавления/редактирования события календаря.
class UserCalendarEventForm extends ConsumerStatefulWidget {
  const UserCalendarEventForm({
    super.key,
    this.existing,
  });

  final UserCalendarEvent? existing;

  @override
  ConsumerState<UserCalendarEventForm> createState() =>
      _UserCalendarEventFormState();
}

class _UserCalendarEventFormState extends ConsumerState<UserCalendarEventForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late DateTime _date;
  late String _currency;
  late UserCalendarRecurrence _recurrence;
  late Set<int> _reminderDays;
  CalendarAttachmentPick? _pendingAttachment;
  bool _removeAttachment = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleController = TextEditingController(text: e?.title ?? '');
    _amountController = TextEditingController(
      text: e?.amount != null ? e!.amount!.toString() : '',
    );
    _noteController = TextEditingController(text: e?.note ?? '');
    _date = e?.date ?? DateTime.now();
    _currency = e?.currency ?? 'RUB';
    _recurrence = e?.recurrence ?? UserCalendarRecurrence.none;
    _reminderDays = {...?e?.reminderDaysBefore};
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickAttachment(AppLocalizations l10n) async {
    final pick = await CalendarAttachmentStorage.pickFile();
    if (!mounted) return;
    if (pick == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userCalendarAttachmentFailed),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _pendingAttachment = pick;
      _removeAttachment = false;
    });
  }

  Future<void> _save(AppLocalizations l10n) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final amountRaw = _amountController.text.trim().replaceAll(',', '.');
    final amount = amountRaw.isEmpty ? null : double.tryParse(amountRaw);
    if (amountRaw.isNotEmpty && (amount == null || amount < 0)) return;

    final note = _noteController.text.trim();
    final notifier = ref.read(userCalendarProvider.notifier);

    if (widget.existing == null) {
      await notifier.addEvent(
        title: title,
        date: _date,
        amount: amount,
        currency: _currency,
        note: note.isEmpty ? null : note,
        attachment: _pendingAttachment,
        recurrence: _recurrence,
        reminderDaysBefore: _reminderDays.toList(),
      );
    } else {
      await notifier.updateEvent(
        widget.existing!.id,
        title: title,
        date: _date,
        amount: amount,
        clearAmount: amountRaw.isEmpty,
        currency: _currency,
        note: note.isEmpty ? null : note,
        clearNote: note.isEmpty,
        newAttachment: _pendingAttachment,
        removeAttachment: _removeAttachment,
        recurrence: _recurrence,
        reminderDaysBefore: _reminderDays.toList(),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userCalendarSaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final existing = widget.existing;
    final hasExistingAttachment =
        existing?.hasAttachment == true && !_removeAttachment && _pendingAttachment == null;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              existing == null
                  ? l10n.userCalendarAddEvent
                  : l10n.userCalendarEditEvent,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.userCalendarFieldTitle,
                hintText: l10n.userCalendarFieldTitleHint,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const Gap(12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.userCalendarFieldDate),
              subtitle: Text(DateFormat.yMMMd(locale).format(_date)),
              trailing: const Icon(Iconsax.calendar_1),
              onTap: _pickDate,
            ),
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: l10n.userCalendarFieldAmount,
                      hintText: l10n.userCalendarFieldAmountHint,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: InputDecoration(
                      labelText: l10n.userCalendarFieldCurrency,
                    ),
                    items: [
                      for (final c in userCalendarCurrencies)
                        DropdownMenuItem(value: c, child: Text(c)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _currency = v);
                    },
                  ),
                ),
              ],
            ),
            const Gap(12),
            Text(l10n.userCalendarFieldRecurrence),
            const Gap(8),
            SegmentedButton<UserCalendarRecurrence>(
              segments: [
                ButtonSegment(
                  value: UserCalendarRecurrence.none,
                  label: Text(l10n.userCalendarRecurrenceNone),
                ),
                ButtonSegment(
                  value: UserCalendarRecurrence.monthly,
                  label: Text(l10n.userCalendarRecurrenceMonthly),
                ),
                ButtonSegment(
                  value: UserCalendarRecurrence.yearly,
                  label: Text(l10n.userCalendarRecurrenceYearly),
                ),
              ],
              selected: {_recurrence},
              onSelectionChanged: (values) {
                setState(() => _recurrence = values.first);
              },
            ),
            const Gap(12),
            Text(l10n.userCalendarFieldReminders),
            const Gap(8),
            Wrap(
              spacing: 8,
              children: [
                for (final days in userCalendarReminderOptions)
                  FilterChip(
                    label: Text(l10n.userCalendarReminderDays(days)),
                    selected: _reminderDays.contains(days),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _reminderDays.add(days);
                        } else {
                          _reminderDays.remove(days);
                        }
                      });
                    },
                  ),
              ],
            ),
            const Gap(12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: l10n.userCalendarFieldNote,
                hintText: l10n.userCalendarFieldNoteHint,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const Gap(12),
            if (hasExistingAttachment)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.document),
                title: Text(existing!.attachmentName!),
              ),
            if (_pendingAttachment != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Iconsax.document),
                title: Text(_pendingAttachment!.name),
              ),
            OutlinedButton.icon(
              onPressed: () => _pickAttachment(l10n),
              icon: const Icon(Iconsax.paperclip, size: 18),
              label: Text(l10n.userCalendarAttachFile),
            ),
            if (hasExistingAttachment || _pendingAttachment != null) ...[
              const Gap(8),
              TextButton(
                onPressed: () => setState(() {
                  _pendingAttachment = null;
                  _removeAttachment = true;
                }),
                child: Text(l10n.userCalendarRemoveAttachment),
              ),
            ],
            const Gap(16),
            FilledButton(
              onPressed: () => _save(l10n),
              child: Text(l10n.userCalendarSave),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showUserCalendarEventForm(
  BuildContext context, {
  UserCalendarEvent? existing,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => UserCalendarEventForm(existing: existing),
  );
}
