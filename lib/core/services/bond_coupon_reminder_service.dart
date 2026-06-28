import 'dart:convert';

import '../../core/utils/bond_analytics.dart';
import '../../data/models/market_asset.dart';
import '../../data/services/cache_service.dart';
import 'notification_service.dart';

/// Локальные напоминания о ближайших купонах и погашениях облигаций.
class BondCouponReminderService {
/// Создаёт [BondCouponReminderService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  BondCouponReminderService._();
/// Поле [instance] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  static final instance = BondCouponReminderService._();

/// Поле [_notifiedKey] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static const _notifiedKey = 'bond_coupon_notified_v1';
/// Поле [_horizonDays] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  static const _horizonDays = 3;
/// Поле [_baseNotificationId] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  static const _baseNotificationId = 7000;

/// Метод [evaluate] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  Future<void> evaluate({
    required List<MarketAsset> bonds,
    required Set<String> trackedKeys,
    required bool isRu,
  }) async {
    if (trackedKeys.isEmpty || bonds.isEmpty) return;

    final tracked = bonds
        .where((b) => trackedKeys.contains('${b.type.name}:${b.id}'))
        .toList();
    if (tracked.isEmpty) return;

    final events = buildBondCalendarEvents(
      tracked,
      horizonDays: _horizonDays,
    );
    if (events.isEmpty) return;

    final notified = _loadNotified();
    var changed = false;

    for (var i = 0; i < events.length; i++) {
      final event = events[i];
      final key = _eventKey(event);
      if (notified.contains(key)) continue;

      final title = isRu ? 'EcoPulse · Облигации' : 'EcoPulse · Bonds';
      final body = _bodyFor(event, isRu);
      await NotificationService.instance.showBondEvent(
        id: _baseNotificationId + (key.hashCode.abs() % 900),
        title: title,
        body: body,
      );
      notified.add(key);
      changed = true;
    }

    if (changed) await _saveNotified(notified);
  }

/// Приватный метод [_eventKey] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  String _eventKey(BondCalendarEvent event) {
    final d = event.date.toIso8601String().substring(0, 10);
    return '${event.bond.id}:$d:${event.type.name}';
  }

/// Приватный метод [_bodyFor] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  String _bodyFor(BondCalendarEvent event, bool isRu) {
    final name = event.bond.symbol;
    final date = '${event.date.day.toString().padLeft(2, '0')}.'
        '${event.date.month.toString().padLeft(2, '0')}';
    return switch (event.type) {
      BondCalendarEventType.maturity => isRu
          ? '$name · погашение $date'
          : '$name · maturity $date',
      BondCalendarEventType.coupon ||
      BondCalendarEventType.couponEstimate =>
        event.bond.couponValueRub != null
            ? (isRu
                ? '$name · купон $date · ${event.bond.couponValueRub!.toStringAsFixed(0)} ₽'
                : '$name · coupon $date · ${event.bond.couponValueRub!.toStringAsFixed(0)} ₽')
            : (isRu ? '$name · купон $date' : '$name · coupon $date'),
    };
  }

/// Приватный метод [_loadNotified] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  Set<String> _loadNotified() {
    final raw = CacheService.instance.getString(_notifiedKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      return (jsonDecode(raw) as List<dynamic>).map((e) => e.toString()).toSet();
    } catch (_) {
      return {};
    }
  }

/// Приватный метод [_saveNotified] класса [BondCouponReminderService].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  Future<void> _saveNotified(Set<String> keys) async {
    final pruned = keys.toList();
    if (pruned.length > 200) {
      pruned.removeRange(0, pruned.length - 200);
    }
    await CacheService.instance.putString(_notifiedKey, jsonEncode(pruned));
  }
}

/// Функция [evaluateBondReminders] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
Future<void> evaluateBondReminders({
  required List<MarketAsset> bonds,
  required Set<String> trackedKeys,
  required bool isRu,
}) {
  return BondCouponReminderService.instance.evaluate(
    bonds: bonds,
    trackedKeys: trackedKeys,
    isRu: isRu,
  );
}
