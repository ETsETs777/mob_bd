import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/savings_goal.dart';
import '../../data/services/cache_service.dart';

final savingsGoalsProvider =
    NotifierProvider<SavingsGoalsNotifier, List<SavingsGoal>>(
  SavingsGoalsNotifier.new,
);

class SavingsGoalsNotifier extends Notifier<List<SavingsGoal>> {
  static const cacheKey = 'savings_goals_v1';
  static const maxGoals = 12;

  @override
  List<SavingsGoal> build() => _load();

  List<SavingsGoal> _load() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => SavingsGoal.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<SavingsGoal?> add({
    required String title,
    required double targetRub,
    required DateTime deadline,
    String? linkedAccountId,
  }) async {
    if (state.length >= maxGoals || targetRub <= 0) return null;
    final goal = SavingsGoal(
      id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      targetRub: targetRub,
      deadline: deadline,
      linkedAccountId: linkedAccountId,
      createdAt: DateTime.now().toUtc(),
    );
    state = [...state, goal];
    await _persist();
    return goal;
  }

  Future<bool> remove(String id) async {
    final next = state.where((g) => g.id != id).toList();
    if (next.length == state.length) return false;
    state = next;
    await _persist();
    return true;
  }

  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.map((g) => g.toJson()).toList()),
    );
  }
}
