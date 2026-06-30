import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/user_calendar_event.dart';
import '../../data/services/cache_service.dart';
import '../services/notification_service.dart';
import 'user_calendar_plan.dart';

/// Планирует локальные напоминания за 1/3/7 дней до событий календаря.
class UserCalendarReminders {
  UserCalendarReminders._();

  static const scheduleHorizonDays = 180;
  static const reminderHour = 9;
  static const scheduledIdsKey = 'user_calendar_reminder_ids_v1';
  static bool _tzReady = false;

  static Future<void> syncAll(List<UserCalendarEvent> events) async {
    if (kIsWeb) return;

    await NotificationService.instance.init();
    await _ensureTimezone();
    await _cancelPrevious();

    final now = DateTime.now();
    final end = now.add(const Duration(days: scheduleHorizonDays));
    final scheduledIds = <int>[];

    for (final event in events) {
      if (event.reminderDaysBefore.isEmpty) continue;

      final occurrences = expandEventDates(event, now, end);
      for (final occurrence in occurrences) {
        for (final daysBefore in event.reminderDaysBefore) {
          final id = await _scheduleOne(
            event: event,
            occurrence: occurrence,
            daysBefore: daysBefore,
          );
          if (id != null) scheduledIds.add(id);
        }
      }
    }

    await CacheService.instance.putString(
      scheduledIdsKey,
      jsonEncode(scheduledIds),
    );
  }

  static Future<void> _cancelPrevious() async {
    final raw = CacheService.instance.getString(scheduledIdsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final ids = (jsonDecode(raw) as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList();
      for (final id in ids) {
        await NotificationService.instance.cancel(id);
      }
    } catch (_) {
      // ignore corrupt cache
    }
  }

  static Future<int?> _scheduleOne({
    required UserCalendarEvent event,
    required DateTime occurrence,
    required int daysBefore,
  }) async {
    final reminderDay = DateTime(
      occurrence.year,
      occurrence.month,
      occurrence.day,
    ).subtract(Duration(days: daysBefore));

    final scheduledLocal = DateTime(
      reminderDay.year,
      reminderDay.month,
      reminderDay.day,
      reminderHour,
    );

    if (scheduledLocal.isBefore(DateTime.now())) return null;

    final tzTime = tz.TZDateTime.from(scheduledLocal, tz.local);
    final id = _notificationId(event.id, occurrence, daysBefore);

    final body = event.amount != null
        ? '${_formatDate(occurrence)} · ${event.amount!.toStringAsFixed(0)} ${event.currency}'
        : _formatDate(occurrence);

    await NotificationService.instance.scheduleCalendarReminder(
      id: id,
      title: event.title,
      body: body,
      scheduledAt: tzTime,
      eventId: event.id,
    );
    return id;
  }

  static int _notificationId(
    String eventId,
    DateTime occurrence,
    int daysBefore,
  ) {
    final key = '$eventId|${occurrence.toIso8601String()}|$daysBefore';
    return 600000 + (key.hashCode.abs() % 350000);
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  static Future<void> _ensureTimezone() async {
    if (_tzReady) return;
    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final name = info.identifier;
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
    _tzReady = true;
  }
}
