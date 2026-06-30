// =============================================================================
// EcoPulse · lib/core/services/home_widget_service.dart
// Автор: Цымбал Е. В.
// Дата: 29.05.2026
// Android home widget: compact 4×1 и expanded 2×2.
// =============================================================================

import 'package:home_widget/home_widget.dart';

import '../../core/utils/formatters.dart';
import '../../core/utils/home_widget_context_strip.dart';
import '../../core/utils/home_widget_data.dart';
import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/inflation_point.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_position.dart';
import '../../providers/widget_config_provider.dart';

class HomeWidgetService {
  HomeWidgetService._();

  static const androidProvider = 'EcoPulseWidgetProvider';

  static Future<void> update({
    List<CurrencyRate>? rates,
    List<MarketAsset>? crypto,
    List<MarketAsset>? stocks,
    List<CommodityQuote>? commodities,
    KeyRateSnapshot? keyRate,
    PortfolioSnapshot? portfolio,
    List<InflationPoint>? inflation,
    WidgetConfig? config,
    HomeWidgetContextStrip? contextStrip,
  }) async {
    try {
      final cfg = config ??
          const WidgetConfig(
            layout: WidgetLayout.auto,
            slot1: WidgetMetric.usdRub,
            slot2: WidgetMetric.btc,
            slot3: WidgetMetric.keyRate,
            slot4: WidgetMetric.imoex,
          );

      final slots = buildHomeWidgetSlots(
        config: cfg,
        rates: rates,
        crypto: crypto,
        stocks: stocks,
        commodities: commodities,
        keyRate: keyRate,
        portfolio: portfolio,
        inflation: inflation,
      );

      await _saveSlot(1, slots.elementAtOrNull(0));
      await _saveSlot(2, slots.elementAtOrNull(1));
      await _saveSlot(3, slots.elementAtOrNull(2));
      await _saveSlot(4, slots.elementAtOrNull(3));

      // Legacy keys
      if (slots.isNotEmpty) {
        await HomeWidget.saveWidgetData<String>('usd_rub', slots[0].value);
        await HomeWidget.saveWidgetData<String>('usd_rub_change', slots[0].change);
      }
      if (slots.length > 1) {
        await HomeWidget.saveWidgetData<String>('btc_usd', slots[1].value);
        await HomeWidget.saveWidgetData<String>('btc_change', slots[1].change);
      }

      await HomeWidget.saveWidgetData<String>('widget_layout', cfg.layout.name);
      await HomeWidget.saveWidgetData<String>(
        'widget_updated',
        Formatters.formatDateTime(DateTime.now(), includeDate: false),
      );

      final strip = contextStrip ??
          buildHomeWidgetContextStrip(portfolio: portfolio);
      await _saveContextStrip(strip);

      await HomeWidget.updateWidget(androidName: androidProvider);
    } catch (_) {}
  }

  static Future<void> _saveSlot(int index, HomeWidgetSlotData? slot) async {
    if (slot == null) return;
    await HomeWidget.saveWidgetData<String>('slot${index}_label', slot.label);
    await HomeWidget.saveWidgetData<String>('slot${index}_value', slot.value);
    await HomeWidget.saveWidgetData<String>('slot${index}_change', slot.change);
  }

  static Future<void> _saveContextStrip(HomeWidgetContextStrip strip) async {
    await HomeWidget.saveWidgetData<String>(
      'widget_ctx_portfolio_label',
      strip.portfolioLabel,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_ctx_portfolio_value',
      strip.portfolioValue,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_ctx_portfolio_change',
      strip.portfolioChange,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_ctx_calendar_label',
      strip.calendarLabel,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_ctx_calendar_title',
      strip.calendarTitle,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_ctx_calendar_date',
      strip.calendarDate,
    );
    await HomeWidget.saveWidgetData<String>(
      'widget_calendar_event_id',
      strip.calendarEventId ?? '',
    );
  }
}

extension _ElementAtOrNull<E> on List<E> {
  E? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
