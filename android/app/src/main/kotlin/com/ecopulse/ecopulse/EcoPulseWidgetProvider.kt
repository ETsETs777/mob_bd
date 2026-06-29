package com.ecopulse.ecopulse

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
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
