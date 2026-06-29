# Fix relative import depth inside lib/features/customization and lib/app
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

function Fix-File($path, $map) {
  if (-not (Test-Path $path)) { return }
  $content = Get-Content $path -Raw -Encoding UTF8
  $original = $content
  foreach ($k in $map.Keys) { $content = $content.Replace($k, $map[$k]) }
  if ($content -ne $original) {
    Set-Content $path $content -Encoding UTF8 -NoNewline
    Write-Host "  $path"
  }
}

$domainFix = @{
  "../../data/" = "../data/"
  "../../state/" = "../state/"
  "../../domain/" = ""
  "../../app/" = "../../../app/"
  "../../core/" = "../../../core/"
  "../../l10n/" = "../../../l10n/"
  "../../features/markets/" = "../../markets/"
  "../../data/services/" = "../../../data/services/"
  "../../data/models/" = "../../../data/models/"
}

$dataFix = @{ "../../domain/" = "../domain/" }

$presentationFix = @{
  "../../domain/" = "../domain/"
  "../../data/user_customization.dart" = "../data/user_customization.dart"
  "../../state/" = "../state/"
  "../../core/" = "../../../core/"
  "../../app/" = "../../../app/"
  "../../l10n/" = "../../../l10n/"
  "../../data/models/" = "../../../data/models/"
  "../../features/markets/" = "../../markets/"
  "../../features/profile/" = "../../profile/"
}

Get-ChildItem "lib/features/customization/domain" -Filter "*.dart" | ForEach-Object { Fix-File $_.FullName $domainFix }
Get-ChildItem "lib/features/customization/data" -Filter "*.dart" | ForEach-Object { Fix-File $_.FullName $dataFix }
Get-ChildItem "lib/features/customization/presentation" -Filter "*.dart" | ForEach-Object { Fix-File $_.FullName $presentationFix }

# app.dart lives in lib/app/
$appFix = @{
  "import 'core/" = "import '../core/"
  "import 'features/" = "import '../features/"
  "import 'l10n/" = "import '../l10n/"
  "import 'shared/" = "import '../shared/"
  "import 'app/state/" = "import 'state/"
}
Fix-File "lib/app/app.dart" $appFix

# app/state/*.dart need ../../ for data and core
Get-ChildItem "lib/app/state" -Filter "*.dart" | ForEach-Object {
  Fix-File $_.FullName @{
    "import '../data/" = "import '../../data/"
    "import '../core/" = "import '../../core/"
    "import '../features/" = "import '../../features/"
  }
}

Fix-File "lib/core/utils/formatters.dart" @{ "../features/" = "../../features/" }

Write-Host "Done"
