# Organize test/ to mirror lib/ structure.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$map = @{
  "appearance_resolver_test.dart" = "core/customization"
  "assistant_customization_resolver_test.dart" = "core/customization"
  "chart_context_profiles_test.dart" = "core/customization"
  "chart_registry_test.dart" = "core/customization"
  "chart_visual_utils_test.dart" = "core/customization"
  "customization_model_test.dart" = "core/customization"
  "customization_presets_test.dart" = "core/customization"
  "customization_sync_test.dart" = "core/customization"
  "data_display_customization_resolver_test.dart" = "core/customization"
  "display_formatters_test.dart" = "core/customization"
  "home_customization_resolver_test.dart" = "core/customization"
  "markets_customization_resolver_test.dart" = "core/customization"
  "navigation_customization_resolver_test.dart" = "core/customization"
  "portfolio_customization_resolver_test.dart" = "core/customization"
  "widget_customization_resolver_test.dart" = "core/customization"
  "bond_analytics_test.dart" = "core/utils"
  "bond_catalog_test.dart" = "core/utils"
  "cache_status_test.dart" = "core/utils"
  "chart_events_test.dart" = "core/utils"
  "chart_normalize_test.dart" = "core/utils"
  "correlation_utils_test.dart" = "core/utils"
  "digest_text_test.dart" = "core/utils"
  "economic_radar_test.dart" = "core/utils"
  "finance_math_test.dart" = "core/utils"
  "home_widget_data_test.dart" = "core/utils"
  "inflation_chart_utils_test.dart" = "core/utils"
  "inflation_math_test.dart" = "core/utils"
  "macro_week_test.dart" = "core/utils"
  "moex_candles_test.dart" = "core/utils"
  "moex_sectors_test.dart" = "core/utils"
  "portfolio_export_test.dart" = "core/utils"
  "portfolio_math_test.dart" = "core/utils"
  "portfolio_real_return_test.dart" = "core/utils"
  "price_alert_eval_test.dart" = "core/utils"
  "quick_convert_test.dart" = "core/utils"
  "rate_inflation_utils_test.dart" = "core/utils"
  "watchlist_hero_test.dart" = "core/utils"
  "watchlist_volatility_test.dart" = "core/utils"
  "course_chapter_map_test.dart" = "core/content"
  "news_model_test.dart" = "data/models"
  "assistant_intent_router_test.dart" = "features/assistant"
  "assistant_local_responder_test.dart" = "features/assistant"
  "portfolio_allocation_test.dart" = "features/portfolio"
  "portfolio_income_test.dart" = "features/portfolio"
  "portfolio_rebalance_test.dart" = "features/portfolio"
  "portfolio_scenario_test.dart" = "features/portfolio"
  "portfolio_trade_journal_test.dart" = "features/portfolio"
  "backup_test.dart" = "features/settings"
  "cloud_sync_test.dart" = "features/settings"
  "widget_test.dart" = "app"
}

foreach ($dest in $map.Values) {
  $dir = Join-Path "test" $dest
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
}

foreach ($entry in $map.GetEnumerator()) {
  $src = Join-Path "test" $entry.Key
  $target = Join-Path (Join-Path "test" $entry.Value) $entry.Key
  if (Test-Path $src) {
    Move-Item $src $target -Force
    Write-Host "$($entry.Key) -> test/$($entry.Value)/"
  }
}

Write-Host "Done"
