// =============================================================================
// EcoPulse · lib/core/services/assistant/local_responder.dart
// Автор: Цымбал Е. В.
// Дата: 27.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: local_responder.
// =============================================================================

import '../../constants/bond_analytics_deep_link.dart';
import 'intent_router.dart';
import 'assistant_context.dart';
import 'faq_content.dart';
import '../../content/course_chapter_map.dart';

/// Класс [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
class AssistantAction {
/// Создаёт [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  const AssistantAction({
    this.navigateTo,
    this.refreshData = false,
    this.openCourseLibrary = false,
    this.openCourseChapterIndex,
    this.openMarketsTab,
    this.bondDeepLink,
  });

/// Поле [navigateTo] класса [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final NavigationTarget? navigateTo;
/// Поле [refreshData] класса [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  final bool refreshData;
/// Поле [openCourseLibrary] класса [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final bool openCourseLibrary;
/// Поле [openCourseChapterIndex] класса [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final int? openCourseChapterIndex;
  /// 0 crypto, 1 stocks, 2 bonds — после перехода на «Рынки».
  final int? openMarketsTab;
/// Поле [bondDeepLink] класса [AssistantAction].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final BondAnalyticsDeepLink? bondDeepLink;
}

/// Класс [LocalResponse].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
class LocalResponse {
/// Создаёт [LocalResponse].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  const LocalResponse({
    required this.text,
    this.action,
  });

/// Поле [text] класса [LocalResponse].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final String text;
/// Поле [action] класса [LocalResponse].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final AssistantAction? action;
}

/// Класс [LocalResponder].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
class LocalResponder {
/// Метод [respond] класса [LocalResponder].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  static LocalResponse respond(IntentMatch match, AssistantContext ctx) {
    switch (match.intent) {
      case AssistantIntent.priceQuery:
        return LocalResponse(text: _priceText(match.priceSymbol, ctx));
      case AssistantIntent.navigate:
        return LocalResponse(
          text: ctx.isRu
              ? 'Открываю ${_navLabel(match.navigation, true)}…'
              : 'Opening ${_navLabel(match.navigation, false)}…',
          action: AssistantAction(navigateTo: match.navigation),
        );
      case AssistantIntent.brief:
        return LocalResponse(text: _briefText(ctx));
      case AssistantIntent.portfolio:
        return LocalResponse(text: _portfolioText(ctx));
      case AssistantIntent.explain:
        final topic = match.explainTopic ?? 'inflation';
        final chapterIdx = courseChapterIndexForTopic(topic);
        final faq = FaqContent.topic(topic, isRu: ctx.isRu);
        if (chapterIdx == null) {
          return LocalResponse(text: faq);
        }
        return LocalResponse(
          text: ctx.isRu
              ? '$faq\n\n📖 Подробнее — глава ${chapterIdx + 1} курса.'
              : '$faq\n\n📖 See course chapter ${chapterIdx + 1} for more.',
          action: AssistantAction(
            openCourseChapterIndex: chapterIdx,
            openMarketsTab: topic == 'bonds' ? 2 : null,
            bondDeepLink:
                topic == 'yieldCurve' ? BondAnalyticsDeepLink.yieldCurve : null,
          ),
        );
      case AssistantIntent.bondMarket:
        return LocalResponse(
          text: match.bondDeepLink == BondAnalyticsDeepLink.yieldCurve
              ? (ctx.isRu
                  ? 'Открываю кривую доходности ОФЗ…'
                  : 'Opening the OFZ yield curve…')
              : match.bondDeepLink == BondAnalyticsDeepLink.ladder
                  ? (ctx.isRu
                      ? 'Открываю лестницу ОФЗ…'
                      : 'Opening the OFZ bond ladder…')
                  : match.bondDeepLink == BondAnalyticsDeepLink.calendar
                      ? (ctx.isRu
                          ? 'Открываю календарь облигаций…'
                          : 'Opening the bond calendar…')
                      : (ctx.isRu
                          ? 'Открываю облигации: кривая ОФЗ, лестница и календарь…'
                          : 'Opening bonds: OFZ curve, ladder and calendar…'),
          action: AssistantAction(
            openMarketsTab: 2,
            bondDeepLink: match.bondDeepLink,
          ),
        );
      case AssistantIntent.refresh:
        return LocalResponse(
          text: ctx.isRu ? 'Обновляю данные…' : 'Refreshing data…',
          action: const AssistantAction(refreshData: true),
        );
      case AssistantIntent.course:
        return LocalResponse(
          text: ctx.isRu
              ? 'Открываю курс «Основы инвестирования»…'
              : 'Opening the Investing Basics course…',
          action: const AssistantAction(openCourseLibrary: true),
        );
      case AssistantIntent.setAlert:
      case AssistantIntent.general:
        return LocalResponse(
          text: ctx.isRu
              ? 'Не удалось обработать локально. Добавьте Gemini API ключ в настройках для сложных вопросов.'
              : 'Could not handle locally. Add a Gemini API key in Settings for complex questions.',
        );
    }
  }

/// Приватный метод [_priceText] класса [LocalResponder].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static String _priceText(PriceSymbol? symbol, AssistantContext ctx) {
    switch (symbol) {
      case PriceSymbol.btc:
        if (ctx.btcPrice == null) {
          return ctx.isRu ? 'Нет данных по BTC.' : 'No BTC data available.';
        }
        final ch = ctx.btcChange != null ? ' (${ctx.btcChange!.toStringAsFixed(2)}%)' : '';
        return ctx.isRu
            ? 'BTC: \$${ctx.btcPrice!.toStringAsFixed(2)}$ch'
            : 'BTC: \$${ctx.btcPrice!.toStringAsFixed(2)}$ch';
      case PriceSymbol.eth:
        if (ctx.ethPrice == null) {
          return ctx.isRu ? 'Нет данных по ETH.' : 'No ETH data available.';
        }
        return ctx.isRu
            ? 'ETH: \$${ctx.ethPrice!.toStringAsFixed(2)}'
            : 'ETH: \$${ctx.ethPrice!.toStringAsFixed(2)}';
      case PriceSymbol.eurRub:
        if (ctx.eurRub == null) {
          return ctx.isRu ? 'Нет данных EUR/RUB.' : 'No EUR/RUB data.';
        }
        return 'EUR/RUB: ${ctx.eurRub!.toStringAsFixed(2)} ₽';
      case PriceSymbol.usdRub:
      case null:
        if (ctx.usdRub == null) {
          return ctx.isRu ? 'Нет данных USD/RUB.' : 'No USD/RUB data.';
        }
        return 'USD/RUB: ${ctx.usdRub!.toStringAsFixed(2)} ₽';
    }
  }

/// Приватный метод [_briefText] класса [LocalResponder].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  static String _briefText(AssistantContext ctx) {
    if (ctx.briefLines.isEmpty) {
      return ctx.isRu
          ? 'Сводка пока пуста — обновите данные на главной.'
          : 'Brief is empty — refresh data on Home.';
    }
    final lines = ctx.briefLines.take(5).map((l) => '• ${l.text}').join('\n');
    return ctx.isRu ? 'Сводка на сегодня:\n$lines' : 'Today\'s brief:\n$lines';
  }

/// Приватный метод [_portfolioText] класса [LocalResponder].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  static String _portfolioText(AssistantContext ctx) {
    if (ctx.portfolioTotalRub == null) {
      return ctx.isRu
          ? 'Портфель пуст. Откройте «Бумажный портфель» на главной.'
          : 'Portfolio is empty. Open Paper Portfolio on Home.';
    }
    final pnl = ctx.portfolioPnlPct?.toStringAsFixed(2) ?? '0';
    return ctx.isRu
        ? 'Портфель: ${ctx.portfolioTotalRub!.toStringAsFixed(0)} ₽ · P&L $pnl%'
        : 'Portfolio: ${ctx.portfolioTotalRub!.toStringAsFixed(0)} ₽ · P&L $pnl%';
  }

/// Приватный метод [_navLabel] класса [LocalResponder].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static String _navLabel(NavigationTarget? target, bool isRu) => switch (target) {
        NavigationTarget.home => isRu ? 'главную' : 'Home',
        NavigationTarget.currency => isRu ? 'валюты' : 'Currency',
        NavigationTarget.inflation => isRu ? 'инфляцию' : 'Inflation',
        NavigationTarget.markets => isRu ? 'рынки' : 'Markets',
        NavigationTarget.settings => isRu ? 'настройки' : 'Settings',
        null => isRu ? 'экран' : 'screen',
      };
}
