// =============================================================================
// EcoPulse · lib/core/services/assistant/intent_router.dart
// Автор: Цымбал Е. В.
// Дата: 27.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: intent_router.
// =============================================================================

import '../../constants/bond_analytics_deep_link.dart';

/// Локальные интенты ассистента (распознавание без Gemini).
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
enum AssistantIntent {
  /// Запрос котировки («курс доллара», «btc»).
  priceQuery,

  /// Переход на экран (home, currency, inflation…).
  navigate,

  /// Создание price alert.
  setAlert,

  /// Сводка по бумажному портфелю.
  portfolio,

  /// FAQ / объяснение термина → глава курса.
  explain,

  /// Утренняя/текущая экономическая сводка.
  brief,

  /// Pull-to-refresh данных.
  refresh,

  /// Открыть курс «Основы инвестора».
  course,

  /// Deep link в аналитику облигаций (ladder, calendar, yield).
  bondMarket,

  /// Не распознано → Gemini или fallback.
  general,
}

/// Целевой таб shell для интента [navigate].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
enum NavigationTarget {
  /// Главная (индекс 0).
  home,

  /// Валюты (индекс 1).
  currency,

  /// Инфляция (индекс 2).
  inflation,

  /// Рынки (индекс 3).
  markets,

  /// Настройки (индекс 4).
  settings,
}

/// Символы для [AssistantIntent.priceQuery].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
enum PriceSymbol {
  /// USD/RUB.
  usdRub,

  /// EUR/RUB.
  eurRub,

  /// Bitcoin.
  btc,

  /// Ethereum.
  eth,
}

/// Класс [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
class IntentMatch {
/// Создаёт [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  const IntentMatch({
    required this.intent,
    this.navigation,
    this.priceSymbol,
    this.explainTopic,
    this.alertSymbol,
    this.alertThreshold,
    this.alertAbove = true,
    this.bondDeepLink,
  });

/// Поле [intent] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final AssistantIntent intent;
/// Поле [navigation] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final NavigationTarget? navigation;
/// Поле [priceSymbol] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final PriceSymbol? priceSymbol;
/// Поле [explainTopic] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  final String? explainTopic;
/// Поле [alertSymbol] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final String? alertSymbol;
/// Поле [alertThreshold] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final double? alertThreshold;
/// Поле [alertAbove] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final bool alertAbove;
/// Поле [bondDeepLink] класса [IntentMatch].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final BondAnalyticsDeepLink? bondDeepLink;
}

/// Класс [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
class IntentRouter {
/// Метод [route] класса [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  static IntentMatch route(String input) {
    final text = input.trim().toLowerCase();

    final explain = _matchExplain(text);
    if (explain != null) {
      return IntentMatch(intent: AssistantIntent.explain, explainTopic: explain);
    }

    if (_matches(text, [
      'кривая доходности',
      'кривая офз',
      'yield curve',
    ])) {
      return const IntentMatch(
        intent: AssistantIntent.bondMarket,
        bondDeepLink: BondAnalyticsDeepLink.yieldCurve,
      );
    }

    if (_matches(text, [
      'лестница облигаций',
      'bond ladder',
    ])) {
      return const IntentMatch(
        intent: AssistantIntent.bondMarket,
        bondDeepLink: BondAnalyticsDeepLink.ladder,
      );
    }

    if (_matches(text, [
      'календарь облигаций',
      'bond calendar',
      'когда купон',
      'когда купоны',
      'ближайшие купоны',
      'upcoming coupons',
    ])) {
      return const IntentMatch(
        intent: AssistantIntent.bondMarket,
        bondDeepLink: BondAnalyticsDeepLink.calendar,
      );
    }

    if (_matches(text, [
      'облигации',
      'bonds tab',
      'ofz',
    ])) {
      return const IntentMatch(intent: AssistantIntent.bondMarket);
    }

    final nav = _matchNavigation(text);
    if (nav != null) {
      return IntentMatch(intent: AssistantIntent.navigate, navigation: nav);
    }

    if (_matches(text, [
      'обнови',
      'refresh',
      'обновить данные',
      'update data',
    ])) {
      return const IntentMatch(intent: AssistantIntent.refresh);
    }

    if (_matches(text, [
      'сводка',
      'что сегодня',
      'brief',
      'today',
      'пульс',
      'что нового',
    ])) {
      return const IntentMatch(intent: AssistantIntent.brief);
    }

    if (_matches(text, [
      'курс инвест',
      'курс по инвест',
      'обучение',
      'учебник',
      'книга',
      'course',
      'investing course',
      'learn investing',
      'открой курс',
      'open course',
    ])) {
      return const IntentMatch(intent: AssistantIntent.course);
    }

    if (_matches(text, [
      'портфель',
      'portfolio',
      'p&l',
      'pnl',
      'мой портфель',
      'my portfolio',
    ])) {
      return const IntentMatch(intent: AssistantIntent.portfolio);
    }

    final alert = _matchAlert(text);
    if (alert != null) return alert;

    final price = _matchPrice(text);
    if (price != null) {
      return IntentMatch(intent: AssistantIntent.priceQuery, priceSymbol: price);
    }

    return const IntentMatch(intent: AssistantIntent.general);
  }

/// Приватный метод [_matchNavigation] класса [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  static NavigationTarget? _matchNavigation(String text) {
    if (_matches(text, ['главн', 'home', 'dashboard', 'пульс'])) {
      return NavigationTarget.home;
    }
    if (_matches(text, ['валют', 'currency', 'конвертер', 'converter'])) {
      return NavigationTarget.currency;
    }
    if (_matches(text, ['инфляц', 'inflation', 'cpi'])) {
      return NavigationTarget.inflation;
    }
    if (_matches(text, ['рынк', 'market', 'акци', 'stock', 'крипто', 'crypto'])) {
      return NavigationTarget.markets;
    }
    if (_matches(text, ['настрой', 'settings', 'setting'])) {
      return NavigationTarget.settings;
    }
    if (text.contains('открой') ||
        text.contains('open') ||
        text.contains('перейди') ||
        text.contains('go to')) {
      if (text.contains('валют') || text.contains('currency')) {
        return NavigationTarget.currency;
      }
      if (text.contains('инфля') || text.contains('inflation')) {
        return NavigationTarget.inflation;
      }
      if (text.contains('рын') || text.contains('market')) {
        return NavigationTarget.markets;
      }
      if (text.contains('настрой') || text.contains('settings')) {
        return NavigationTarget.settings;
      }
    }
    return null;
  }

/// Приватный метод [_matchPrice] класса [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static PriceSymbol? _matchPrice(String text) {
    if (_matches(text, ['btc', 'битко', 'bitcoin'])) return PriceSymbol.btc;
    if (_matches(text, ['eth', 'эфир', 'ethereum'])) return PriceSymbol.eth;
    if (_matches(text, ['eur/rub', 'eur rub', 'евро', 'eur'])) {
      return PriceSymbol.eurRub;
    }
    if (_matches(text, [
      'usd/rub',
      'usd rub',
      'доллар',
      'dollar',
      'usd',
      'курс',
      'rate',
      'сколько стоит',
      'how much',
      'price',
    ])) {
      return PriceSymbol.usdRub;
    }
    return null;
  }

/// Приватный метод [_matchExplain] класса [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  static String? _matchExplain(String text) {
    if (!_matches(text, [
      'что такое',
      'объясни',
      'explain',
      'what is',
      'расскажи',
    ])) {
      return null;
    }
    if (text.contains('инфля')) return 'inflation';
    if (text.contains('ставк') || text.contains('key rate') || text.contains('cbr')) {
      return 'keyRate';
    }
    if (text.contains('fear') || text.contains('greed') || text.contains('жадност')) {
      return 'fearGreed';
    }
    if (text.contains('correl') || text.contains('коррел')) return 'correlation';
    if (text.contains('портфел') || text.contains('portfolio')) return 'portfolio';
    if (text.contains('алерт') || text.contains('alert')) return 'alerts';
    if (text.contains('крив') && text.contains('доход')) return 'yieldCurve';
    if (text.contains('yield curve')) return 'yieldCurve';
    if (text.contains('лестниц') && text.contains('облига')) return 'yieldCurve';
    if (text.contains('облига') ||
        text.contains('bond') ||
        text.contains('офз') ||
        text.contains('ofz')) {
      return 'bonds';
    }
    return null;
  }

/// Приватный метод [_matchAlert] класса [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static IntentMatch? _matchAlert(String text) {
    if (!_matches(text, ['алерт', 'alert', 'уведом', 'notify'])) return null;

    String? symbol;
    if (text.contains('btc') || text.contains('битко')) symbol = 'btc';
    if (text.contains('eth') || text.contains('эфир')) symbol = 'eth';
    if (text.contains('eur')) symbol = 'eurRub';
    if (text.contains('usd') || text.contains('доллар') || symbol == null) {
      symbol ??= 'usdRub';
    }

    final numbers = RegExp(r'(\d+[.,]?\d*)').allMatches(text).map((m) => m.group(1)).toList();
    final threshold = numbers.isNotEmpty
        ? double.tryParse(numbers.last!.replaceAll(',', '.'))
        : null;

    final above = text.contains('выше') ||
        text.contains('above') ||
        text.contains('>') ||
        text.contains('больше');

    return IntentMatch(
      intent: AssistantIntent.setAlert,
      alertSymbol: symbol,
      alertThreshold: threshold ?? 90,
      alertAbove: above || !text.contains('ниже') && !text.contains('below'),
    );
  }

/// Приватный метод [_matches] класса [IntentRouter].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  static bool _matches(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
