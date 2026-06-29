# Replace sibling provider imports with package: paths after subfolder move.
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$map = @{
  "import 'app_providers.dart'" = "import 'package:ecopulse/providers/app/app_providers.dart'"
  "import 'locale_provider.dart'" = "import 'package:ecopulse/providers/app/locale_provider.dart'"
  "import 'theme_provider.dart'" = "import 'package:ecopulse/providers/app/theme_provider.dart'"
  "import 'accent_provider.dart'" = "import 'package:ecopulse/providers/app/accent_provider.dart'"
  "import 'background_provider.dart'" = "import 'package:ecopulse/providers/app/background_provider.dart'"
  "import 'demo_mode_provider.dart'" = "import 'package:ecopulse/providers/app/demo_mode_provider.dart'"
  "import 'security_provider.dart'" = "import 'package:ecopulse/providers/app/security_provider.dart'"
  "import 'home_layout_provider.dart'" = "import 'package:ecopulse/providers/app/home_layout_provider.dart'"
  "import 'commodities_provider.dart'" = "import 'package:ecopulse/providers/markets/commodities_provider.dart'"
  "import 'indices_provider.dart'" = "import 'package:ecopulse/providers/markets/indices_provider.dart'"
  "import 'news_provider.dart'" = "import 'package:ecopulse/providers/markets/news_provider.dart'"
  "import 'watchlist_provider.dart'" = "import 'package:ecopulse/providers/markets/watchlist_provider.dart'"
  "import 'correlation_provider.dart'" = "import 'package:ecopulse/providers/markets/correlation_provider.dart'"
  "import 'stock_market_provider.dart'" = "import 'package:ecopulse/providers/markets/stock_market_provider.dart'"
  "import 'compare_assets_provider.dart'" = "import 'package:ecopulse/providers/markets/compare_assets_provider.dart'"
  "import 'paper_portfolio_provider.dart'" = "import 'package:ecopulse/providers/portfolio/paper_portfolio_provider.dart'"
  "import 'portfolio_trade_journal_provider.dart'" = "import 'package:ecopulse/providers/portfolio/portfolio_trade_journal_provider.dart'"
  "import 'portfolio_rebalance_provider.dart'" = "import 'package:ecopulse/providers/portfolio/portfolio_rebalance_provider.dart'"
  "import 'portfolio_income_provider.dart'" = "import 'package:ecopulse/providers/portfolio/portfolio_income_provider.dart'"
  "import 'morning_digest_provider.dart'" = "import 'package:ecopulse/providers/settings/morning_digest_provider.dart'"
  "import 'cloud_sync_provider.dart'" = "import 'package:ecopulse/providers/settings/cloud_sync_provider.dart'"
  "import 'price_alerts_provider.dart'" = "import 'package:ecopulse/providers/alerts/price_alerts_provider.dart'"
  "import 'alert_history_provider.dart'" = "import 'package:ecopulse/providers/alerts/alert_history_provider.dart'"
  "import 'alert_quiet_hours_provider.dart'" = "import 'package:ecopulse/providers/alerts/alert_quiet_hours_provider.dart'"
  "import 'user_profile_provider.dart'" = "import 'package:ecopulse/providers/profile/user_profile_provider.dart'"
  "import 'home_server_provider.dart'" = "import 'package:ecopulse/providers/profile/home_server_provider.dart'"
  "import 'messages_provider.dart'" = "import 'package:ecopulse/providers/messages/messages_provider.dart'"
  "import 'customization_provider.dart'" = "import 'package:ecopulse/providers/customization/customization_provider.dart'"
  "import 'customization_presets_provider.dart'" = "import 'package:ecopulse/providers/customization/customization_presets_provider.dart'"
  "import 'widget_config_provider.dart'" = "import 'package:ecopulse/providers/customization/widget_config_provider.dart'"
  "import 'widget_customization_provider.dart'" = "import 'package:ecopulse/providers/customization/widget_customization_provider.dart'"
  "import 'appearance_provider.dart'" = "import 'package:ecopulse/providers/customization/appearance_provider.dart'"
  "import 'assistant_customization_provider.dart'" = "import 'package:ecopulse/providers/customization/assistant_customization_provider.dart'"
}

Get-ChildItem "lib/providers" -Recurse -Filter "*.dart" | ForEach-Object {
  $c = Get-Content $_.FullName -Raw -Encoding UTF8
  $o = $c
  foreach ($k in $map.Keys) { $c = $c.Replace($k, $map[$k]) }
  if ($c -ne $o) { Set-Content $_.FullName $c -Encoding UTF8 -NoNewline; Write-Host $_.Name }
}
