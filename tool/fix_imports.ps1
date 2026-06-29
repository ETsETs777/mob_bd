# Fix broken relative imports after restructure.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$replacements = [ordered]@{
  "../features/customization/domain/" = "../domain/"
  "../features/customization/data/" = "../data/"
  "../features/customization/state/" = "../state/"
  "../features/customization/presentation/" = "../presentation/"
  "../../features/customization/domain/" = "../domain/"
  "../../features/customization/data/" = "../data/"
  "../../features/customization/state/" = "../state/"
  "../../features/customization/presentation/" = "../presentation/"
  "../customization/widget_slot_key.dart" = "../domain/widget_slot_key.dart"
  "../customization/display_formatters.dart" = "../features/customization/domain/display_formatters.dart"
  "../customization/" = "../features/customization/domain/"
  "../../features/customization/" = "../customization/"
  "../customization/customization_screen.dart" = "../customization/presentation/customization_screen.dart"
  "../customization/widget_settings.dart" = "../settings/widget_settings.dart"
  "../features/assistant/domain/" = "../domain/"
  "../../features/assistant/domain/" = "../domain/"
  "../../features/assistant/presentation/" = "../presentation/"
  "../../features/assistant/state/" = "../state/"
  "../features/assistant/" = "../assistant/"
}

$dartFiles = Get-ChildItem -Path "lib","test" -Filter "*.dart" -Recurse
foreach ($file in $dartFiles) {
  $content = Get-Content $file.FullName -Raw -Encoding UTF8
  $original = $content
  foreach ($key in $replacements.Keys) {
    $content = $content.Replace($key, $replacements[$key])
  }
  if ($content -ne $original) {
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
    Write-Host "fixed: $($file.FullName.Replace("$root\", ''))"
  }
}

Write-Host "Done"
