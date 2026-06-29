// =============================================================================
// EcoPulse · lib/core/services/assistant/faq_content.dart
// Автор: Цымбал Е. В.
// Дата: 27.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: faq_content.
// =============================================================================

/// Класс [FaqContent].
class FaqTopic {
  const FaqTopic({required this.id, required this.titleRu, required this.titleEn, required this.bodyRu, required this.bodyEn});

  final String id;
  final String titleRu;
  final String titleEn;
  final String bodyRu;
  final String bodyEn;
}

class FaqContent {
  static String topic(String topic, {required bool isRu}) {
    final entries = isRu ? _ru : _en;
    return entries[topic] ?? entries['inflation']!;
  }

  static List<({String title, String body})> topics({required bool isRu}) {
    return _catalog
        .map(
          (t) => (
            title: isRu ? t.titleRu : t.titleEn,
            body: isRu ? t.bodyRu : t.bodyEn,
          ),
        )
        .toList();
  }

  static const _catalog = [
    FaqTopic(
      id: 'inflation',
      titleRu: 'Что такое инфляция?',
      titleEn: 'What is inflation?',
      bodyRu: 'Инфляция — рост общего уровня цен. EcoPulse показывает CPI по странам (World Bank) и считает, как меняется покупательная способность денег со временем.',
      bodyEn: 'Inflation is the rise in the general price level. EcoPulse shows CPI by country (World Bank) and purchasing power over time.',
    ),
    FaqTopic(
      id: 'keyRate',
      titleRu: 'Ключевая ставка ЦБ',
      titleEn: 'Central bank key rate',
      bodyRu: 'Ключевая ставка ЦБ — основная процентная ставка, которой регулятор управляет экономикой. В EcoPulse она отображается на главной и влияет на вклады и кредиты.',
      bodyEn: 'The key rate is the central bank\'s main policy rate. In EcoPulse it appears on the home screen and affects deposits and loans.',
    ),
    FaqTopic(
      id: 'portfolio',
      titleRu: 'Бумажный портфель',
      titleEn: 'Paper portfolio',
      bodyRu: 'Бумажный портфель — виртуальные 100 000 ₽ для тренировки. Покупайте активы из рынков или избранного и следите за P&L без риска.',
      bodyEn: 'The paper portfolio gives you virtual ₽100,000 to practice. Buy assets from markets or watchlist and track P&L risk-free.',
    ),
    FaqTopic(
      id: 'alerts',
      titleRu: 'Ценовые алерты',
      titleEn: 'Price alerts',
      bodyRu: 'Ценовые алерты — локальные уведомления, когда инструмент пересекает порог. Настраиваются в разделе «Алерты» или через помощника.',
      bodyEn: 'Price alerts are local notifications when an instrument crosses a threshold. Set them in Alerts or via the assistant.',
    ),
    FaqTopic(
      id: 'bonds',
      titleRu: 'Облигации и ОФЗ',
      titleEn: 'Bonds & OFZ',
      bodyRu: 'Облигация — долг: вы даёте деньги эмитенту, он платит купоны и возвращает номинал. ОФЗ — госдолг РФ. На вкладке «Облигации» — цена, YTM и срок погашения с MOEX.',
      bodyEn: 'A bond is debt: you lend money, the issuer pays coupons and repays face value. OFZ are Russian government bonds with MOEX data on the Bonds tab.',
    ),
    FaqTopic(
      id: 'sync',
      titleRu: 'Синхронизация данных',
      titleEn: 'Data sync',
      bodyRu: 'EcoPulse может синхронизировать профиль и настройки через JSON-файл, home server в LAN или EcoPulse Cloud (Supabase). Ключи API хранятся только на устройстве.',
      bodyEn: 'EcoPulse can sync profile and settings via JSON file, LAN home server, or EcoPulse Cloud (Supabase). API keys stay on your device only.',
    ),
  ];

  static const _ru = {
    'inflation': 'Инфляция — рост общего уровня цен. EcoPulse показывает CPI по странам (World Bank) и считает, как меняется покупательная способность денег со временем.',
    'keyRate': 'Ключевая ставка ЦБ — основная процентная ставка, которой регулятор управляет экономикой. В EcoPulse она отображается на главной и влияет на вклады и кредиты.',
    'fearGreed': 'Fear & Greed Index — индекс настроения крипторынка от 0 (страх) до 100 (жадность). Помогает понять, насколько рынок перегрет или напуган.',
    'correlation': 'Корреляция показывает, насколько активы движутся вместе. В EcoPulse можно сравнить BTC, USD/RUB и IMOEX за 30 дней.',
    'portfolio': 'Бумажный портфель — виртуальные 100 000 ₽ для тренировки. Покупайте активы из рынков или избранного и следите за P&L без риска.',
    'alerts': 'Ценовые алерты — локальные уведомления, когда инструмент пересекает порог. Настраиваются в разделе «Алерты» или через помощника.',
      'bonds': 'Облигация — долг: вы даёте деньги эмитенту, он платит купоны и возвращает номинал. ОФЗ — госдолг РФ. В EcoPulse на вкладке «Облигации» — цена, доходность (YTM) и срок погашения с MOEX.',
    'yieldCurve': 'Кривая доходности ОФЗ показывает, как YTM зависит от срока погашения. На вкладке «Облигации» — график, лестница по годам и календарь купонов/погашений.',
  };

/// Поле [_en] класса [FaqContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static const _en = {
    'inflation': 'Inflation is the rise in the general price level. EcoPulse shows CPI by country (World Bank) and purchasing power over time.',
    'keyRate': 'The key rate is the central bank\'s main policy rate. In EcoPulse it appears on the home screen and affects deposits and loans.',
    'fearGreed': 'The Fear & Greed Index measures crypto market sentiment from 0 (fear) to 100 (greed).',
    'correlation': 'Correlation shows how assets move together. EcoPulse lets you compare BTC, USD/RUB and IMOEX over 30 days.',
    'portfolio': 'The paper portfolio gives you virtual ₽100,000 to practice. Buy assets from markets or watchlist and track P&L risk-free.',
    'alerts': 'Price alerts are local notifications when an instrument crosses a threshold. Set them in Alerts or via the assistant.',
    'bonds': 'A bond is debt: you lend money, the issuer pays coupons and repays face value. OFZ are Russian government bonds. EcoPulse Bonds tab shows price, yield (YTM) and maturity from MOEX.',
    'yieldCurve': 'The OFZ yield curve plots YTM vs time to maturity. On the Bonds tab you will find the chart, maturity ladder and coupon/maturity calendar.',
  };
}
