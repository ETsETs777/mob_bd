import 'dart:convert';



import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../../core/utils/calendar_attachment_storage.dart';

import '../../core/utils/user_calendar_ics_import.dart';

import '../../core/utils/user_calendar_reminders.dart';
import '../../core/utils/user_local_data_auto_sync.dart';

import '../../data/models/user_calendar_event.dart';

import '../../data/services/cache_service.dart';



final userCalendarProvider =

    NotifierProvider<UserCalendarNotifier, List<UserCalendarEvent>>(

  UserCalendarNotifier.new,

);



class UserCalendarNotifier extends Notifier<List<UserCalendarEvent>> {

  static const cacheKey = 'user_calendar_events_v1';

  static const maxEvents = 200;



  @override

  List<UserCalendarEvent> build() {

    final raw = CacheService.instance.getString(cacheKey);

    if (raw == null || raw.isEmpty) return [];

    try {

      final list = jsonDecode(raw) as List<dynamic>;

      return list

          .map((e) => UserCalendarEvent.fromJson(e as Map<String, dynamic>))

          .toList()

        ..sort((a, b) => a.date.compareTo(b.date));

    } catch (_) {

      return [];

    }

  }



  Future<UserCalendarEvent> addEvent({

    required String title,

    required DateTime date,

    double? amount,

    String currency = 'RUB',

    String? note,

    CalendarAttachmentPick? attachment,

    UserCalendarRecurrence recurrence = UserCalendarRecurrence.none,

    List<int> reminderDaysBefore = const [],

  }) async {

    final id = _newId();

    var event = UserCalendarEvent(

      id: id,

      title: title.trim(),

      date: DateTime(date.year, date.month, date.day),

      amount: amount,

      currency: currency.toUpperCase(),

      note: note?.trim().isEmpty == true ? null : note?.trim(),

      createdAt: DateTime.now(),

      recurrence: recurrence,

      reminderDaysBefore: _normalizeReminders(reminderDaysBefore),

    );



    if (attachment != null) {

      await CalendarAttachmentStorage.saveBytes(id, attachment.bytes);

      event = event.copyWith(

        attachmentName: attachment.name,

        attachmentMime: attachment.mime,

      );

    }



    final next = [...state, event]

      ..sort((a, b) => a.date.compareTo(b.date));

    if (next.length > maxEvents) {

      final removed = next.removeAt(0);

      if (removed.hasAttachment) {

        await CalendarAttachmentStorage.clear(removed.id);

      }

    }

    state = next;

    await _persist();

    return event;

  }



  Future<void> updateEvent(

    String id, {

    required String title,

    required DateTime date,

    double? amount,

    bool clearAmount = false,

    String? currency,

    String? note,

    bool clearNote = false,

    CalendarAttachmentPick? newAttachment,

    bool removeAttachment = false,

    UserCalendarRecurrence? recurrence,

    List<int>? reminderDaysBefore,

  }) async {

    final index = state.indexWhere((e) => e.id == id);

    if (index < 0) return;



    var event = state[index].copyWith(

      title: title.trim(),

      date: DateTime(date.year, date.month, date.day),

      amount: amount,

      clearAmount: clearAmount,

      currency: currency,

      note: note,

      clearNote: clearNote,

      recurrence: recurrence,

      reminderDaysBefore: reminderDaysBefore == null

          ? null

          : _normalizeReminders(reminderDaysBefore),

    );



    if (removeAttachment) {

      await CalendarAttachmentStorage.clear(id);

      event = event.copyWith(clearAttachment: true);

    } else if (newAttachment != null) {

      await CalendarAttachmentStorage.saveBytes(id, newAttachment.bytes);

      event = event.copyWith(

        attachmentName: newAttachment.name,

        attachmentMime: newAttachment.mime,

      );

    }



    final next = [...state];

    next[index] = event;

    next.sort((a, b) => a.date.compareTo(b.date));

    state = next;

    await _persist();

  }



  Future<void> deleteEvent(String id) async {

    await CalendarAttachmentStorage.clear(id);

    state = state.where((e) => e.id != id).toList();

    await _persist();

  }



  Future<UserCalendarEvent?> duplicateEvent(
    String id, {
    required String titleSuffix,
  }) async {
    final source = state.where((e) => e.id == id).firstOrNull;
    if (source == null) return null;
    return addEvent(
      title: '${source.title}$titleSuffix',
      date: source.date,
      amount: source.amount,
      currency: source.currency,
      note: source.note,
      recurrence: source.recurrence,
      reminderDaysBefore: source.reminderDaysBefore,
    );
  }



  Future<int> importDrafts(List<({String title, DateTime date, String? note})> drafts) async {
    var imported = 0;
    for (final draft in drafts) {
      if (state.length >= maxEvents) break;
      await addEvent(
        title: draft.title,
        date: draft.date,
        note: draft.note,
      );
      imported++;
    }
    return imported;
  }

  Future<int> importIcsDrafts(List<IcsEventDraft> drafts) async {
    var imported = 0;
    for (final draft in drafts) {
      if (state.length >= maxEvents) break;
      await addEvent(
        title: draft.title,
        date: draft.date,
        note: draft.note,
        amount: draft.amount,
        currency: draft.currency,
        recurrence: _icsRecurrence(draft.recurrence),
        reminderDaysBefore: draft.reminderDaysBefore,
      );
      imported++;
    }
    return imported;
  }

  UserCalendarRecurrence _icsRecurrence(IcsRecurrence recurrence) {
    return switch (recurrence) {
      IcsRecurrence.none => UserCalendarRecurrence.none,
      IcsRecurrence.monthly => UserCalendarRecurrence.monthly,
      IcsRecurrence.yearly => UserCalendarRecurrence.yearly,
    };
  }



  List<int> _normalizeReminders(List<int> days) {

    return days.where((d) => userCalendarReminderOptions.contains(d)).toSet().toList()

      ..sort();

  }



  Future<void> _persist() async {

    await CacheService.instance.putString(

      cacheKey,

      jsonEncode(state.map((e) => e.toJson()).toList()),

    );

    await UserCalendarReminders.syncAll(state);

    UserLocalDataAutoSync.schedulePush(ref);

  }



  String _newId() =>

      '${DateTime.now().microsecondsSinceEpoch}_${state.length}';

}

