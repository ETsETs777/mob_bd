# Organize lib/providers into domain subfolders; keep backward-compatible re-exports.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

function Ensure-Dir($p) { if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null } }

$groups = @{
  "app" = @(
    "app_providers.dart","locale_provider.dart","theme_provider.dart","accent_provider.dart",
    "background_provider.dart","demo_mode_provider.dart","security_provider.dart",
    "onboarding_provider.dart","default_tab_provider.dart","compact_home_provider.dart",
    "home_layout_provider.dart","feature_flags_provider.dart","base_currency_provider.dart"
  )
  "markets" = @(
    "stock_market_provider.dart","watchlist_provider.dart","commodities_provider.dart",
    "news_provider.dart","correlation_provider.dart","indices_provider.dart","compare_assets_provider.dart"
  )
  "portfolio" = @(
    "paper_portfolio_provider.dart","portfolio_trade_journal_provider.dart",
    "portfolio_rebalance_provider.dart","portfolio_income_provider.dart","asset_notes_provider.dart"
  )
  "settings" = @("api_keys_provider.dart","cloud_sync_provider.dart","morning_digest_provider.dart")
  "alerts" = @("price_alerts_provider.dart","alert_history_provider.dart","alert_quiet_hours_provider.dart")
  "profile" = @("user_profile_provider.dart","home_server_provider.dart")
  "messages" = @("messages_provider.dart")
  "learn" = @("course_progress_provider.dart","course_reader_prefs_provider.dart")
  "admin" = @("admin_provider.dart")
  "customization" = @(
    "customization_provider.dart","customization_presets_provider.dart",
    "widget_config_provider.dart","widget_customization_provider.dart",
    "markets_customization_provider.dart","portfolio_customization_provider.dart",
    "data_display_customization_provider.dart","navigation_customization_provider.dart",
    "home_customization_provider.dart","appearance_provider.dart","chart_customization_provider.dart",
    "assistant_customization_provider.dart"
  )
  "assistant" = @("assistant_provider.dart")
}

foreach ($group in $groups.Keys) {
  $dir = "lib/providers/$group"
  Ensure-Dir $dir
  foreach ($file in $groups[$group]) {
    $src = "lib/providers/$file"
    if (-not (Test-Path $src)) { continue }
    $content = Get-Content $src -Raw -Encoding UTF8
    if ($content -match "^export '") { continue } # already a stub
    $dest = "$dir/$file"
    Move-Item $src $dest -Force
    Set-Content $src "export '$group/$file';`n" -Encoding UTF8 -NoNewline
    Write-Host "  $file -> providers/$group/"
  }
}

Write-Host "Done. Run: flutter test"
