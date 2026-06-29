# EcoPulse · tool/reorganize_structure.ps1
# Moves shared widgets, settings panels, test files; adds provider stubs.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

function Ensure-Dir($p) {
  if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
}

function Write-Stub($stubPath, $exportPath) {
  $dir = Split-Path $stubPath -Parent
  Ensure-Dir $dir
  Set-Content -Path $stubPath -Value "export '$exportPath';`n" -Encoding UTF8 -NoNewline
}

Write-Host "=== 1. lib/features/shared -> lib/shared ==="
Ensure-Dir "lib/shared/widgets"

if (Test-Path "lib/features/shared/app_actions.dart") {
  $content = Get-Content "lib/features/shared/app_actions.dart" -Raw -Encoding UTF8
  if ($content -notmatch "^export '") {
    Move-Item "lib/features/shared/app_actions.dart" "lib/shared/app_actions.dart" -Force
    Write-Stub "lib/features/shared/app_actions.dart" "package:ecopulse/shared/app_actions.dart"
    Write-Host "  app_actions.dart -> lib/shared/"
  }
}

Get-ChildItem "lib/features/shared/widgets" -Filter *.dart -File | ForEach-Object {
  $name = $_.Name
  $dest = "lib/shared/widgets/$name"
  if (-not (Test-Path $dest)) {
    Move-Item $_.FullName $dest -Force
  }
  Write-Stub "lib/features/shared/widgets/$name" "package:ecopulse/shared/widgets/$name"
  Write-Host "  widgets/$name -> lib/shared/widgets/"
}

Write-Host "=== 2. settings panels -> settings/panels/ ==="
Ensure-Dir "lib/features/settings/panels"
$settingsPanels = @(
  "cloud_sync_settings.dart",
  "cloud_account_settings.dart",
  "home_server_settings.dart",
  "home_layout_settings.dart",
  "widget_settings.dart",
  "profile_backup_widgets.dart"
)
foreach ($file in $settingsPanels) {
  $src = "lib/features/settings/$file"
  if (-not (Test-Path $src)) { continue }
  $content = Get-Content $src -Raw -Encoding UTF8
  if ($content -match "^export '") { continue }
  $dest = "lib/features/settings/panels/$file"
  Move-Item $src $dest -Force
  Write-Stub $src "panels/$file"
  Write-Host "  settings/$file -> settings/panels/"
}

Write-Host "=== 3. test file moves ==="
Ensure-Dir "test/features/shell"
Ensure-Dir "test/core/utils"
if (Test-Path "test/features/hub_screens_test.dart") {
  Move-Item "test/features/hub_screens_test.dart" "test/features/shell/hub_screens_test.dart" -Force
  Write-Host "  hub_screens_test -> features/shell/"
}
if (Test-Path "test/core/moving_average_test.dart") {
  Move-Item "test/core/moving_average_test.dart" "test/core/utils/moving_average_test.dart" -Force
  Write-Host "  moving_average_test -> core/utils/"
}

Write-Host "=== 4. missing provider stubs ==="
$providerStubs = @{
  "cloud_auth_provider.dart" = "cloud/cloud_auth_provider.dart"
  "cloud_data_sync_provider.dart" = "cloud/cloud_data_sync_provider.dart"
  "message_push_provider.dart" = "messages/message_push_provider.dart"
  "live_crypto_prices_provider.dart" = "markets/live_crypto_prices_provider.dart"
  "tablet_market_selection_provider.dart" = "markets/tablet_market_selection_provider.dart"
  "customization_server_sync_provider.dart" = "customization/customization_server_sync_provider.dart"
  "home_widget_preview_provider.dart" = "customization/home_widget_preview_provider.dart"
  "savings_goals_provider.dart" = "portfolio/savings_goals_provider.dart"
  "live_portfolio_snapshot_provider.dart" = "portfolio/live_portfolio_snapshot_provider.dart"
  "portfolio_tax_report_provider.dart" = "portfolio/portfolio_tax_report_provider.dart"
  "portfolio_robo_advisor_provider.dart" = "portfolio/portfolio_robo_advisor_provider.dart"
  "paper_portfolio_store_provider.dart" = "portfolio/paper_portfolio_store_provider.dart"
}
foreach ($entry in $providerStubs.GetEnumerator()) {
  $stub = "lib/providers/$($entry.Key)"
  $target = $entry.Value
  if ((Test-Path "lib/providers/$target") -and -not (Test-Path $stub)) {
    Write-Stub $stub $target
    Write-Host "  stub $($entry.Key)"
  }
}

Write-Host "=== Done ==="
