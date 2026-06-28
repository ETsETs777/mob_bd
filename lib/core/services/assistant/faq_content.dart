// =============================================================================
// EcoPulse · lib/core/services/assistant/faq_content.dart
// Автор: Цымбал Е. В.
// Дата: 27.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: faq_content.
// =============================================================================

/// Класс [FaqContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
class FaqContent {
/// Метод [topic] класса [FaqContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static String topic(String topic, {required bool isRu}) {
    final entries = isRu ? _ru : _en;
    return entries[topic] ?? entries['inflation']!;
  }

/// Поле [_ru] класса [FaqContent].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
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
