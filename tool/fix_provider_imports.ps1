# Fix import depth in lib/providers/*/*.dart after moving one level deeper.
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$fixes = @{
  "import '../data/" = "import '../../data/"
  "import '../core/" = "import '../../core/"
  "import '../features/" = "import '../../features/"
  "import '../l10n/" = "import '../../l10n/"
}

Get-ChildItem "lib/providers" -Directory | ForEach-Object {
  Get-ChildItem $_.FullName -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    $orig = $content
    foreach ($k in $fixes.Keys) { $content = $content.Replace($k, $fixes[$k]) }
    if ($content -ne $orig) {
      Set-Content $_.FullName $content -Encoding UTF8 -NoNewline
      Write-Host "fixed $($_.Name)"
    }
  }
}
