# Global import path fixes after modular restructure.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$replacements = [ordered]@{
  # app/state sibling imports -> feature state
  "import 'commodities_provider.dart'" = "import '../../features/markets/state/commodities_provider.dart'"
  "import 'indices_provider.dart'" = "import '../../features/markets/state/indices_provider.dart'"
  "import 'news_provider.dart'" = "import '../../features/markets/state/news_provider.dart'"
  "import '../domain/accent_resolver.dart'" = "import '../../features/customization/domain/accent_resolver.dart'"
  "import 'appearance_provider.dart'" = "import '../../features/customization/state/appearance_provider.dart'"
  "import 'customization_provider.dart'" = "import '../../features/customization/state/customization_provider.dart'"
  # core/services and core/* -> customization module
  "import '../../domain/" = "import '../../features/customization/domain/"
  "import '../../data/user_customization.dart'" = "import '../../features/customization/data/user_customization.dart'"
  "import '../../state/customization_provider.dart'" = "import '../../features/customization/state/customization_provider.dart'"
  "import '../../state/customization_presets_provider.dart'" = "import '../../features/customization/state/customization_presets_provider.dart'"
  "import '../../state/customization_cloud_sync_provider.dart'" = "import '../../features/customization/state/customization_cloud_sync_provider.dart'"
  "import '../../state/widget_config_provider.dart'" = "import '../../features/customization/state/widget_config_provider.dart'"
  "import '../../state/widget_customization_provider.dart'" = "import '../../features/customization/state/widget_customization_provider.dart'"
  "import '../../state/chart_customization_provider.dart'" = "import '../../features/customization/state/chart_customization_provider.dart'"
  "import '../../state/data_display_customization_provider.dart'" = "import '../../features/customization/state/data_display_customization_provider.dart'"
  "import '../../../state/" = "import '../../../features/customization/state/"
  "import '../../../domain/" = "import '../../../features/customization/domain/"
  "import '../../../data/user_customization.dart'" = "import '../../../features/customization/data/user_customization.dart'"
  # customization domain cache path
  "import '../../data/services/cache_service.dart'" = "import '../../../data/services/cache_service.dart'"
  # shared widgets wrong depth
  "import '../../../features/customization/" = "import '../../features/customization/"
  "import '../../../providers/" = "import '../../../features/customization/state/"
  "import '../../providers/" = "import '../../features/"
  "import '../../features/commodities_provider.dart'" = "import '../../features/markets/state/commodities_provider.dart'"
  "import '../../features/correlation_provider.dart'" = "import '../../features/markets/state/correlation_provider.dart'"
  "import '../../features/morning_digest_provider.dart'" = "import '../../features/settings/state/morning_digest_provider.dart'"
  "import '../../features/news_provider.dart'" = "import '../../features/markets/state/news_provider.dart'"
  "import '../../features/indices_provider.dart'" = "import '../../features/markets/state/indices_provider.dart'"
  "import '../../features/paper_portfolio_provider.dart'" = "import '../../features/portfolio/state/paper_portfolio_provider.dart'"
  "import '../../features/price_alerts_provider.dart'" = "import '../../features/alerts/state/price_alerts_provider.dart'"
  "import '../../features/watchlist_provider.dart'" = "import '../../features/markets/state/watchlist_provider.dart'"
  "import '../../features/widget_customization_provider.dart'" = "import '../../features/customization/state/widget_customization_provider.dart'"
  "import '../../features/app_providers.dart'" = "import '../../app/state/app_providers.dart'"
  # assistant paths in core (if any left)
  "import '../../core/services/assistant/" = "import '../../features/assistant/domain/"
  "import '../core/services/assistant/" = "import '../features/assistant/domain/"
  # settings widget_settings
  "import '../customization/widget_customization_panel.dart'" = "import '../customization/presentation/widget_customization_panel.dart'"
  "import '../customization/presentation/presentation/" = "import '../customization/presentation/"
}

$dartFiles = Get-ChildItem -Path "lib","test" -Filter "*.dart" -Recurse
foreach ($file in $dartFiles) {
  $content = Get-Content $file.FullName -Raw -Encoding UTF8
  $original = $content
  foreach ($key in $replacements.Keys) {
    $content = $content.Replace($key, $replacements[$key])
  }
  if ($content -ne $original) {
    Set-Content $file.FullName $content -Encoding UTF8 -NoNewline
    Write-Host "fixed: $($file.Name)"
  }
}

Write-Host "Done"
