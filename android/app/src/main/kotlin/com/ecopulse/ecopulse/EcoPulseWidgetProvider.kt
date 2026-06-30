package com.ecopulse.ecopulse

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class EcoPulseWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            updateWidget(context, appWidgetManager, widgetId, widgetData, options)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        val widgetData = context.getSharedPreferences(
            "HomeWidgetPreferences",
            Context.MODE_PRIVATE,
        )
        updateWidget(context, appWidgetManager, appWidgetId, widgetData, newOptions)
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        widgetData: SharedPreferences,
        options: Bundle?,
    ) {
        val layoutPref = widgetData.getString("widget_layout", "auto") ?: "auto"
        val minHeight = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 80) ?: 80
        val useExpanded = when (layoutPref) {
            "expanded" -> true
            "compact" -> false
            else -> minHeight >= 100
        }

        val layoutId = if (useExpanded) {
            R.layout.ecopulse_widget_expanded
        } else {
            R.layout.ecopulse_widget
        }

        val slot1Label = widgetData.getString("slot1_label", "USD/RUB") ?: "USD/RUB"
        val slot1Value = widgetData.getString("slot1_value", widgetData.getString("usd_rub", "—")) ?: "—"
        val slot1Change = widgetData.getString("slot1_change", widgetData.getString("usd_rub_change", "")) ?: ""
        val slot2Label = widgetData.getString("slot2_label", "BTC") ?: "BTC"
        val slot2Value = widgetData.getString("slot2_value", widgetData.getString("btc_usd", "—")) ?: "—"
        val slot2Change = widgetData.getString("slot2_change", widgetData.getString("btc_change", "")) ?: ""
        val slot3Label = widgetData.getString("slot3_label", "CBR") ?: "CBR"
        val slot3Value = widgetData.getString("slot3_value", "—") ?: "—"
        val slot3Change = widgetData.getString("slot3_change", "") ?: ""
        val slot4Label = widgetData.getString("slot4_label", "IMOEX") ?: "IMOEX"
        val slot4Value = widgetData.getString("slot4_value", "—") ?: "—"
        val slot4Change = widgetData.getString("slot4_change", "") ?: ""
        val updated = widgetData.getString("widget_updated", "") ?: ""

        val ctxPortfolioLabel = widgetData.getString("widget_ctx_portfolio_label", "Portfolio") ?: "Portfolio"
        val ctxPortfolioValue = widgetData.getString("widget_ctx_portfolio_value", "—") ?: "—"
        val ctxPortfolioChange = widgetData.getString("widget_ctx_portfolio_change", "") ?: ""
        val ctxCalendarLabel = widgetData.getString("widget_ctx_calendar_label", "Next") ?: "Next"
        val ctxCalendarTitle = widgetData.getString("widget_ctx_calendar_title", "—") ?: "—"
        val ctxCalendarDate = widgetData.getString("widget_ctx_calendar_date", "") ?: ""
        val calendarEventId = widgetData.getString("widget_calendar_event_id", "") ?: ""

        val accentColor = readAccentColor(widgetData)
        val backgroundColor = if (widgetData.getBoolean("widget_theme_dark", true)) {
            0xFF161B22.toInt()
        } else {
            0xFFF6F8FA.toInt()
        }
        val primaryText = if (widgetData.getBoolean("widget_theme_dark", true)) {
            0xFFF0F6FC.toInt()
        } else {
            0xFF1F2328.toInt()
        }

        val views = RemoteViews(context.packageName, layoutId).apply {
            setInt(R.id.widget_root, "setBackgroundColor", backgroundColor)
            setTextViewText(R.id.widget_brand, "EcoPulse")
            setTextColor(R.id.widget_brand, accentColor)
            setTextViewText(R.id.widget_slot1_label, slot1Label)
            setTextViewText(R.id.widget_slot1_value, slot1Value)
            setTextViewText(R.id.widget_slot1_change, slot1Change)
            setTextViewText(R.id.widget_slot2_label, slot2Label)
            setTextViewText(R.id.widget_slot2_value, slot2Value)
            setTextViewText(R.id.widget_slot2_change, slot2Change)
            setTextViewText(R.id.widget_updated, if (updated.isNotEmpty()) "↻ $updated" else "")

            setTextColor(R.id.widget_slot1_value, primaryText)
            setTextColor(R.id.widget_slot2_value, primaryText)
            setTextColor(R.id.widget_slot1_change, changeColor(slot1Change))
            setTextColor(R.id.widget_slot2_change, changeColor(slot2Change))

            setTextViewText(R.id.widget_ctx_portfolio_label, ctxPortfolioLabel)
            setTextViewText(R.id.widget_ctx_portfolio_value, ctxPortfolioValue)
            setTextViewText(R.id.widget_ctx_portfolio_change, ctxPortfolioChange)
            setTextViewText(R.id.widget_ctx_calendar_label, ctxCalendarLabel)
            setTextViewText(R.id.widget_ctx_calendar_title, ctxCalendarTitle)
            setTextViewText(R.id.widget_ctx_calendar_date, ctxCalendarDate)
            setTextColor(R.id.widget_ctx_portfolio_value, primaryText)
            setTextColor(R.id.widget_ctx_calendar_title, primaryText)
            setTextColor(R.id.widget_ctx_portfolio_change, changeColor(ctxPortfolioChange))

            if (useExpanded) {
                setTextViewText(R.id.widget_slot3_label, slot3Label)
                setTextViewText(R.id.widget_slot3_value, slot3Value)
                setTextViewText(R.id.widget_slot3_change, slot3Change)
                setTextViewText(R.id.widget_slot4_label, slot4Label)
                setTextViewText(R.id.widget_slot4_value, slot4Value)
                setTextViewText(R.id.widget_slot4_change, slot4Change)
                setTextColor(R.id.widget_slot3_value, primaryText)
                setTextColor(R.id.widget_slot4_value, primaryText)
                setTextColor(R.id.widget_slot3_change, changeColor(slot3Change))
                setTextColor(R.id.widget_slot4_change, changeColor(slot4Change))
            }

            if (calendarEventId.isNotEmpty()) {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("ecopulse://calendar/$calendarEventId"))
                intent.setPackage(context.packageName)
                val pending = PendingIntent.getActivity(
                    context,
                    widgetId,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
                setOnClickPendingIntent(R.id.widget_ctx_calendar, pending)
            }
        }

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun readAccentColor(widgetData: SharedPreferences): Int {
        val stored = widgetData.getInt("widget_accent_color", 0)
        return if (stored != 0) stored else 0xFF58A6FF.toInt()
    }

    private fun changeColor(change: String): Int {
        if (change.startsWith("-")) return 0xFFF85149.toInt()
        if (change.startsWith("+") || change.contains("%")) return 0xFF3FB950.toInt()
        return 0xFF8B949E.toInt()
    }
}
