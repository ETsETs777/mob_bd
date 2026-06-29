# EcoPulse lib/ restructure — moves files and rewrites import paths.
# Run from repo root: powershell -ExecutionPolicy Bypass -File tool/restructure_lib.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

function Ensure-Dir($path) {
  if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
}

function Move-File($from, $to) {
  if (-not (Test-Path $from)) { return }
  Ensure-Dir (Split-Path $to -Parent)
  if (Test-Path $to) { Remove-Item $to -Force }
  Move-Item $from $to -Force
  Write-Host "  $from -> $to"
}

Write-Host "=== Creating directories ==="
$dirs = @(
  "lib/app/state",
  "lib/shared/widgets",
  "lib/features/customization/data",
  "lib/features/customization/domain",
  "lib/features/customization/presentation",
  "lib/features/customization/state",
  "lib/features/assistant/domain",
  "lib/features/assistant/presentation",
  "lib/features/assistant/state",
  "lib/features/markets/state",
  "lib/features/portfolio/state",
  "lib/features/settings/state",
  "lib/features/alerts/state",
  "lib/features/profile/state",
  "lib/features/messages/state",
  "lib/features/learn/state",
  "lib/features/admin/state"
)
foreach ($d in $dirs) { Ensure-Dir $d }

Write-Host "=== Moving app ==="
Move-File "lib/app.dart" "lib/app/app.dart"

Write-Host "=== Moving shared widgets ==="
Get-ChildItem "lib/features/shared/widgets" -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
  Move-File $_.FullName.Replace("$root\", "").Replace("\", "/") "lib/shared/widgets/$($_.Name)"
}
Move-File "lib/features/shared/app_actions.dart" "lib/shared/app_actions.dart"

Write-Host "=== Moving customization domain ==="
Get-ChildItem "lib/core/customization" -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
  Move-File "lib/core/customization/$($_.Name)" "lib/features/customization/domain/$($_.Name)"
}

Write-Host "=== Moving customization data ==="
Move-File "lib/data/models/user_customization.dart" "lib/features/customization/data/user_customization.dart"

Write-Host "=== Moving customization presentation ==="
Get-ChildItem "lib/features/customization" -Filter "*.dart" -File -ErrorAction SilentlyContinue | ForEach-Object {
  Move-File "lib/features/customization/$($_.Name)" "lib/features/customization/presentation/$($_.Name)"
}

Write-Host "=== Moving customization state ==="
$customProviders = @(
  "customization_provider.dart",
  "customization_presets_provider.dart",
  "customization_cloud_sync_provider.dart",
  "widget_config_provider.dart",
  "widget_customization_provider.dart",
  "markets_customization_provider.dart",
  "portfolio_customization_provider.dart",
  "data_display_customization_provider.dart",
  "navigation_customization_provider.dart",
  "home_customization_provider.dart",
  "appearance_provider.dart",
  "chart_customization_provider.dart",
  "assistant_customization_provider.dart"
)
foreach ($f in $customProviders) {
  Move-File "lib/providers/$f" "lib/features/customization/state/$f"
}

Write-Host "=== Moving assistant ==="
Get-ChildItem "lib/core/services/assistant" -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
  Move-File "lib/core/services/assistant/$($_.Name)" "lib/features/assistant/domain/$($_.Name)"
}
Get-ChildItem "lib/features/assistant" -Filter "*.dart" -File -ErrorAction SilentlyContinue | ForEach-Object {
  Move-File "lib/features/assistant/$($_.Name)" "lib/features/assistant/presentation/$($_.Name)"
}
Move-File "lib/providers/assistant_provider.dart" "lib/features/assistant/state/assistant_provider.dart"

Write-Host "=== Moving app state ==="
$appState = @(
  "app_providers.dart", "locale_provider.dart", "theme_provider.dart",
  "accent_provider.dart", "background_provider.dart", "demo_mode_provider.dart",
  "security_provider.dart", "onboarding_provider.dart", "default_tab_provider.dart",
  "compact_home_provider.dart", "home_layout_provider.dart", "feature_flags_provider.dart",
  "base_currency_provider.dart"
)
foreach ($f in $appState) { Move-File "lib/providers/$f" "lib/app/state/$f" }

Write-Host "=== Moving feature state ==="
$marketsState = @("stock_market_provider.dart","watchlist_provider.dart","commodities_provider.dart","news_provider.dart","correlation_provider.dart","indices_provider.dart","compare_assets_provider.dart")
$portfolioState = @("paper_portfolio_provider.dart","portfolio_trade_journal_provider.dart","portfolio_rebalance_provider.dart","portfolio_income_provider.dart","asset_notes_provider.dart")
$settingsState = @("api_keys_provider.dart","cloud_sync_provider.dart","morning_digest_provider.dart")
$alertsState = @("price_alerts_provider.dart","alert_history_provider.dart","alert_quiet_hours_provider.dart")
$profileState = @("user_profile_provider.dart","home_server_provider.dart")
$messagesState = @("messages_provider.dart")
$learnState = @("course_progress_provider.dart","course_reader_prefs_provider.dart")
$adminState = @("admin_provider.dart")

foreach ($f in $marketsState) { Move-File "lib/providers/$f" "lib/features/markets/state/$f" }
foreach ($f in $portfolioState) { Move-File "lib/providers/$f" "lib/features/portfolio/state/$f" }
foreach ($f in $settingsState) { Move-File "lib/providers/$f" "lib/features/settings/state/$f" }
foreach ($f in $alertsState) { Move-File "lib/providers/$f" "lib/features/alerts/state/$f" }
foreach ($f in $profileState) { Move-File "lib/providers/$f" "lib/features/profile/state/$f" }
foreach ($f in $messagesState) { Move-File "lib/providers/$f" "lib/features/messages/state/$f" }
foreach ($f in $learnState) { Move-File "lib/providers/$f" "lib/features/learn/state/$f" }
foreach ($f in $adminState) { Move-File "lib/providers/$f" "lib/features/admin/state/$f" }

Write-Host "=== Rewriting imports ==="
$replacements = [ordered]@{
  "package:ecopulse/app.dart" = "package:ecopulse/app/app.dart"
  "package:ecopulse/core/customization/" = "package:ecopulse/features/customization/domain/"
  "package:ecopulse/data/models/user_customization.dart" = "package:ecopulse/features/customization/data/user_customization.dart"
  "package:ecopulse/core/services/assistant/" = "package:ecopulse/features/assistant/domain/"
  "package:ecopulse/features/shared/widgets/" = "package:ecopulse/shared/widgets/"
  "package:ecopulse/features/shared/app_actions.dart" = "package:ecopulse/shared/app_actions.dart"
  "package:ecopulse/providers/app_providers.dart" = "package:ecopulse/app/state/app_providers.dart"
  "package:ecopulse/providers/locale_provider.dart" = "package:ecopulse/app/state/locale_provider.dart"
  "package:ecopulse/providers/theme_provider.dart" = "package:ecopulse/app/state/theme_provider.dart"
  "package:ecopulse/providers/accent_provider.dart" = "package:ecopulse/app/state/accent_provider.dart"
  "package:ecopulse/providers/background_provider.dart" = "package:ecopulse/app/state/background_provider.dart"
  "package:ecopulse/providers/demo_mode_provider.dart" = "package:ecopulse/app/state/demo_mode_provider.dart"
  "package:ecopulse/providers/security_provider.dart" = "package:ecopulse/app/state/security_provider.dart"
  "package:ecopulse/providers/onboarding_provider.dart" = "package:ecopulse/app/state/onboarding_provider.dart"
  "package:ecopulse/providers/default_tab_provider.dart" = "package:ecopulse/app/state/default_tab_provider.dart"
  "package:ecopulse/providers/compact_home_provider.dart" = "package:ecopulse/app/state/compact_home_provider.dart"
  "package:ecopulse/providers/home_layout_provider.dart" = "package:ecopulse/app/state/home_layout_provider.dart"
  "package:ecopulse/providers/feature_flags_provider.dart" = "package:ecopulse/app/state/feature_flags_provider.dart"
  "package:ecopulse/providers/base_currency_provider.dart" = "package:ecopulse/app/state/base_currency_provider.dart"
  "package:ecopulse/providers/stock_market_provider.dart" = "package:ecopulse/features/markets/state/stock_market_provider.dart"
  "package:ecopulse/providers/watchlist_provider.dart" = "package:ecopulse/features/markets/state/watchlist_provider.dart"
  "package:ecopulse/providers/commodities_provider.dart" = "package:ecopulse/features/markets/state/commodities_provider.dart"
  "package:ecopulse/providers/news_provider.dart" = "package:ecopulse/features/markets/state/news_provider.dart"
  "package:ecopulse/providers/correlation_provider.dart" = "package:ecopulse/features/markets/state/correlation_provider.dart"
  "package:ecopulse/providers/indices_provider.dart" = "package:ecopulse/features/markets/state/indices_provider.dart"
  "package:ecopulse/providers/compare_assets_provider.dart" = "package:ecopulse/features/markets/state/compare_assets_provider.dart"
  "package:ecopulse/providers/paper_portfolio_provider.dart" = "package:ecopulse/features/portfolio/state/paper_portfolio_provider.dart"
  "package:ecopulse/providers/portfolio_trade_journal_provider.dart" = "package:ecopulse/features/portfolio/state/portfolio_trade_journal_provider.dart"
  "package:ecopulse/providers/portfolio_rebalance_provider.dart" = "package:ecopulse/features/portfolio/state/portfolio_rebalance_provider.dart"
  "package:ecopulse/providers/portfolio_income_provider.dart" = "package:ecopulse/features/portfolio/state/portfolio_income_provider.dart"
  "package:ecopulse/providers/asset_notes_provider.dart" = "package:ecopulse/features/portfolio/state/asset_notes_provider.dart"
  "package:ecopulse/providers/api_keys_provider.dart" = "package:ecopulse/features/settings/state/api_keys_provider.dart"
  "package:ecopulse/providers/cloud_sync_provider.dart" = "package:ecopulse/features/settings/state/cloud_sync_provider.dart"
  "package:ecopulse/providers/morning_digest_provider.dart" = "package:ecopulse/features/settings/state/morning_digest_provider.dart"
  "package:ecopulse/providers/price_alerts_provider.dart" = "package:ecopulse/features/alerts/state/price_alerts_provider.dart"
  "package:ecopulse/providers/alert_history_provider.dart" = "package:ecopulse/features/alerts/state/alert_history_provider.dart"
  "package:ecopulse/providers/alert_quiet_hours_provider.dart" = "package:ecopulse/features/alerts/state/alert_quiet_hours_provider.dart"
  "package:ecopulse/providers/user_profile_provider.dart" = "package:ecopulse/features/profile/state/user_profile_provider.dart"
  "package:ecopulse/providers/home_server_provider.dart" = "package:ecopulse/features/profile/state/home_server_provider.dart"
  "package:ecopulse/providers/messages_provider.dart" = "package:ecopulse/features/messages/state/messages_provider.dart"
  "package:ecopulse/providers/course_progress_provider.dart" = "package:ecopulse/features/learn/state/course_progress_provider.dart"
  "package:ecopulse/providers/course_reader_prefs_provider.dart" = "package:ecopulse/features/learn/state/course_reader_prefs_provider.dart"
  "package:ecopulse/providers/admin_provider.dart" = "package:ecopulse/features/admin/state/admin_provider.dart"
  "package:ecopulse/providers/customization_provider.dart" = "package:ecopulse/features/customization/state/customization_provider.dart"
  "package:ecopulse/providers/customization_presets_provider.dart" = "package:ecopulse/features/customization/state/customization_presets_provider.dart"
  "package:ecopulse/providers/customization_cloud_sync_provider.dart" = "package:ecopulse/features/customization/state/customization_cloud_sync_provider.dart"
  "package:ecopulse/providers/widget_config_provider.dart" = "package:ecopulse/features/customization/state/widget_config_provider.dart"
  "package:ecopulse/providers/widget_customization_provider.dart" = "package:ecopulse/features/customization/state/widget_customization_provider.dart"
  "package:ecopulse/providers/markets_customization_provider.dart" = "package:ecopulse/features/customization/state/markets_customization_provider.dart"
  "package:ecopulse/providers/portfolio_customization_provider.dart" = "package:ecopulse/features/customization/state/portfolio_customization_provider.dart"
  "package:ecopulse/providers/data_display_customization_provider.dart" = "package:ecopulse/features/customization/state/data_display_customization_provider.dart"
  "package:ecopulse/providers/navigation_customization_provider.dart" = "package:ecopulse/features/customization/state/navigation_customization_provider.dart"
  "package:ecopulse/providers/home_customization_provider.dart" = "package:ecopulse/features/customization/state/home_customization_provider.dart"
  "package:ecopulse/providers/appearance_provider.dart" = "package:ecopulse/features/customization/state/appearance_provider.dart"
  "package:ecopulse/providers/chart_customization_provider.dart" = "package:ecopulse/features/customization/state/chart_customization_provider.dart"
  "package:ecopulse/providers/assistant_customization_provider.dart" = "package:ecopulse/features/customization/state/assistant_customization_provider.dart"
  "package:ecopulse/providers/assistant_provider.dart" = "package:ecopulse/features/assistant/state/assistant_provider.dart"
  "core/customization/" = "features/customization/domain/"
  "data/models/user_customization.dart" = "features/customization/data/user_customization.dart"
  "core/services/assistant/" = "features/assistant/domain/"
  "features/shared/widgets/" = "shared/widgets/"
  "features/shared/app_actions.dart" = "shared/app_actions.dart"
  "providers/app_providers.dart" = "app/state/app_providers.dart"
  "providers/locale_provider.dart" = "app/state/locale_provider.dart"
  "providers/theme_provider.dart" = "app/state/theme_provider.dart"
  "providers/accent_provider.dart" = "app/state/accent_provider.dart"
  "providers/background_provider.dart" = "app/state/background_provider.dart"
  "providers/demo_mode_provider.dart" = "app/state/demo_mode_provider.dart"
  "providers/security_provider.dart" = "app/state/security_provider.dart"
  "providers/onboarding_provider.dart" = "app/state/onboarding_provider.dart"
  "providers/default_tab_provider.dart" = "app/state/default_tab_provider.dart"
  "providers/compact_home_provider.dart" = "app/state/compact_home_provider.dart"
  "providers/home_layout_provider.dart" = "app/state/home_layout_provider.dart"
  "providers/feature_flags_provider.dart" = "app/state/feature_flags_provider.dart"
  "providers/base_currency_provider.dart" = "app/state/base_currency_provider.dart"
  "providers/stock_market_provider.dart" = "features/markets/state/stock_market_provider.dart"
  "providers/watchlist_provider.dart" = "features/markets/state/watchlist_provider.dart"
  "providers/commodities_provider.dart" = "features/markets/state/commodities_provider.dart"
  "providers/news_provider.dart" = "features/markets/state/news_provider.dart"
  "providers/correlation_provider.dart" = "features/markets/state/correlation_provider.dart"
  "providers/indices_provider.dart" = "features/markets/state/indices_provider.dart"
  "providers/compare_assets_provider.dart" = "features/markets/state/compare_assets_provider.dart"
  "providers/paper_portfolio_provider.dart" = "features/portfolio/state/paper_portfolio_provider.dart"
  "providers/portfolio_trade_journal_provider.dart" = "features/portfolio/state/portfolio_trade_journal_provider.dart"
  "providers/portfolio_rebalance_provider.dart" = "features/portfolio/state/portfolio_rebalance_provider.dart"
  "providers/portfolio_income_provider.dart" = "features/portfolio/state/portfolio_income_provider.dart"
  "providers/asset_notes_provider.dart" = "features/portfolio/state/asset_notes_provider.dart"
  "providers/api_keys_provider.dart" = "features/settings/state/api_keys_provider.dart"
  "providers/cloud_sync_provider.dart" = "features/settings/state/cloud_sync_provider.dart"
  "providers/morning_digest_provider.dart" = "features/settings/state/morning_digest_provider.dart"
  "providers/price_alerts_provider.dart" = "features/alerts/state/price_alerts_provider.dart"
  "providers/alert_history_provider.dart" = "features/alerts/state/alert_history_provider.dart"
  "providers/alert_quiet_hours_provider.dart" = "features/alerts/state/alert_quiet_hours_provider.dart"
  "providers/user_profile_provider.dart" = "features/profile/state/user_profile_provider.dart"
  "providers/home_server_provider.dart" = "features/profile/state/home_server_provider.dart"
  "providers/messages_provider.dart" = "features/messages/state/messages_provider.dart"
  "providers/course_progress_provider.dart" = "features/learn/state/course_progress_provider.dart"
  "providers/course_reader_prefs_provider.dart" = "features/learn/state/course_reader_prefs_provider.dart"
  "providers/admin_provider.dart" = "features/admin/state/admin_provider.dart"
  "providers/customization_provider.dart" = "features/customization/state/customization_provider.dart"
  "providers/customization_presets_provider.dart" = "features/customization/state/customization_presets_provider.dart"
  "providers/customization_cloud_sync_provider.dart" = "features/customization/state/customization_cloud_sync_provider.dart"
  "providers/widget_config_provider.dart" = "features/customization/state/widget_config_provider.dart"
  "providers/widget_customization_provider.dart" = "features/customization/state/widget_customization_provider.dart"
  "providers/markets_customization_provider.dart" = "features/customization/state/markets_customization_provider.dart"
  "providers/portfolio_customization_provider.dart" = "features/customization/state/portfolio_customization_provider.dart"
  "providers/data_display_customization_provider.dart" = "features/customization/state/data_display_customization_provider.dart"
  "providers/navigation_customization_provider.dart" = "features/customization/state/navigation_customization_provider.dart"
  "providers/home_customization_provider.dart" = "features/customization/state/home_customization_provider.dart"
  "providers/appearance_provider.dart" = "features/customization/state/appearance_provider.dart"
  "providers/chart_customization_provider.dart" = "features/customization/state/chart_customization_provider.dart"
  "providers/assistant_customization_provider.dart" = "features/customization/state/assistant_customization_provider.dart"
  "providers/assistant_provider.dart" = "features/assistant/state/assistant_provider.dart"
  "import 'app.dart'" = "import 'app/app.dart'"
  "features/customization/customization_screen.dart" = "features/customization/presentation/customization_screen.dart"
  "features/customization/customization_" = "features/customization/presentation/customization_"
  "features/customization/appearance_" = "features/customization/presentation/appearance_"
  "features/customization/home_" = "features/customization/presentation/home_"
  "features/customization/navigation_" = "features/customization/presentation/navigation_"
  "features/customization/markets_" = "features/customization/presentation/markets_"
  "features/customization/portfolio_" = "features/customization/presentation/portfolio_"
  "features/customization/widget_" = "features/customization/presentation/widget_"
  "features/customization/data_display_" = "features/customization/presentation/data_display_"
  "features/customization/assistant_" = "features/customization/presentation/assistant_"
  "features/assistant/assistant_" = "features/assistant/presentation/assistant_"
}

$dartFiles = Get-ChildItem -Path "lib","test" -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue
foreach ($file in $dartFiles) {
  $content = Get-Content $file.FullName -Raw -Encoding UTF8
  $original = $content
  foreach ($key in $replacements.Keys) {
    $content = $content.Replace($key, $replacements[$key])
  }
  if ($content -ne $original) {
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    Write-Host "  updated: $($file.FullName.Replace("$root\", ''))"
  }
}

Write-Host "=== Done. Run: flutter test ==="
