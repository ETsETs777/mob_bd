// =============================================================================
// EcoPulse · test/macro_week_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit-тест: macro_week plan builder.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/utils/macro_week.dart';
import 'package:ecopulse/data/models/key_rate_point.dart';
import 'package:ecopulse/data/models/macro_event.dart';

void main() {
  test('buildMacroWeekPlan groups macro events by day within 7 days', () {
    final asOf = DateTime(2026, 6, 28);
    final events = [
      MacroEvent(
        event: 'CPI',
        country: 'US',
        date: DateTime(2026, 6, 28),
        impact: 'high',
      ),
      MacroEvent(
        event: 'GDP',
        country: 'EU',
        date: DateTime(2026, 6, 30),
      ),
      MacroEvent(
        event: 'Old',
        country: 'US',
        date: DateTime(2026, 6, 20),
      ),
      MacroEvent(
        event: 'Far',
        country: 'US',
        date: DateTime(2026, 7, 10),
      ),
    ];

    final plan = buildMacroWeekPlan(
      macroEvents: events,
      asOf: asOf,
    );

    expect(plan.days.length, 7);
    expect(plan.totalMacroEvents, 2);
    expect(plan.daysWithEvents, 2);
    expect(plan.days.first.isToday, isTrue);
    expect(plan.days.first.events.length, 1);
    expect(plan.days.first.events.first.title, 'CPI');
    expect(plan.days[2].events.single.title, 'GDP');
  });

  test('buildMacroWeekPlan adds key rate on today', () {
    final asOf = DateTime(2026, 6, 28);
    final keyRate = KeyRateSnapshot(
      current: 21.0,
      history: const [],
      updatedAt: asOf,
    );

    final plan = buildMacroWeekPlan(
      keyRate: keyRate,
      asOf: asOf,
    );

    expect(plan.keyRatePercent, 21.0);
    expect(plan.days.first.events.first.kind, MacroWeekEventKind.keyRate);
    expect(plan.days[1].events, isEmpty);
  });

  test('buildMacroWeekPlan weekEnd is six days after start', () {
    final asOf = DateTime(2026, 6, 28);
    final plan = buildMacroWeekPlan(asOf: asOf);

    expect(plan.weekStart, DateTime(2026, 6, 28));
    expect(plan.weekEnd, DateTime(2026, 7, 4));
  });
}
