import '../../core/utils/formatters.dart';
import '../../core/utils/user_calendar_plan.dart';
import '../../l10n/app_localizations.dart';

/// Текст для share ближайших событий календаря.
String buildUserCalendarShareText(
  AppLocalizations l10n,
  UserCalendarPlan plan,
) {
  if (plan.events.isEmpty) return l10n.userCalendarShareEmpty;

  final buffer = StringBuffer('${l10n.userCalendarTitle}\n\n');
  for (final item in plan.events.take(50)) {
    final amount = item.amount != null && item.amount! > 0
        ? ' · ${item.currency == 'RUB' ? Formatters.rub(item.amount!) : Formatters.price(item.amount!, symbol: item.currency == 'USD' ? '\$' : '${item.currency} ')}'
        : '';
    buffer.writeln('${Formatters.date(item.date)} · ${item.title}$amount');
  }
  if (plan.events.length > 50) {
    buffer.writeln('\n${l10n.userCalendarShareMore(plan.events.length - 50)}');
  }
  return buffer.toString().trim();
}
