$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$serverDir = Join-Path $root "server"

Set-Location $serverDir
dart pub get
dart run bin/server.dart --host 0.0.0.0 --port 8081
