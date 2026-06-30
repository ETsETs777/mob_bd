import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/user_calendar_plan.dart';
import '../portfolio_income_provider.dart';
import 'user_calendar_provider.dart';
import 'user_calendar_settings_provider.dart';

/// Параметры плана календаря (горизонт).
class UserCalendarPlanParams {
  const UserCalendarPlanParams({this.horizonDays = 365});

  final int horizonDays;

  @override
  bool operator ==(Object other) =>
      other is UserCalendarPlanParams && other.horizonDays == horizonDays;

  @override
  int get hashCode => horizonDays.hashCode;
}

final userCalendarPlanProvider = Provider.family<UserCalendarPlan, int>(
  (ref, horizonDays) {
    final manual = ref.watch(userCalendarProvider);
    final settings = ref.watch(userCalendarSettingsProvider);
    final portfolioPlan = ref.watch(portfolioIncomeProvider);

    return buildUserCalendarPlan(
      manualEvents: manual,
      portfolioPlan: portfolioPlan,
      showPortfolioEvents: settings.showPortfolioEvents,
      horizonDays: horizonDays,
    );
  },
);
