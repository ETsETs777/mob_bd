@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "FLUTTER=C:\Users\9571\flutter\bin\flutter.bat"
set "ADB=C:\Users\9571\AppData\Local\Android\Sdk\platform-tools"
set "ROOT=%~dp0.."
set "WEB_PORT=9090"

if not exist "%FLUTTER%" (
  echo [ERROR] Flutter not found: %FLUTTER%
  echo Install Flutter or edit FLUTTER path in scripts\EcoPulse.bat
  pause
  exit /b 1
)

set "PATH=C:\Users\9571\flutter\bin;%ADB%;%PATH%"
cd /d "%ROOT%"

if "%~1"=="" goto menu
if /i "%~1"=="web" goto web
if /i "%~1"=="apk" goto apk
if /i "%~1"=="apk-all" goto apk_all
if /i "%~1"=="test" goto test
if /i "%~1"=="stop" goto stop_web
goto menu

:menu
echo.
echo  EcoPulse v1.0.38 — scripts
echo  ===========================
echo   1  Web in Chrome  (http://localhost:%WEB_PORT%)
echo   2  Build APK arm64 (TSEV-arm64-v8a.apk)
echo   3  Build APK all ABIs (split-per-abi)
echo   4  Tests + analyze
echo   5  Stop web on port %WEB_PORT%
echo   0  Exit
echo.
set /p CHOICE="Select [1-5]: "
if "%CHOICE%"=="1" goto web
if "%CHOICE%"=="2" goto apk
if "%CHOICE%"=="3" goto apk_all
if "%CHOICE%"=="4" goto test
if "%CHOICE%"=="5" goto stop_web
if "%CHOICE%"=="0" exit /b 0
goto menu

:stop_web
echo Stopping processes on port %WEB_PORT%...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%WEB_PORT% " ^| findstr LISTENING') do (
  taskkill /F /PID %%a >nul 2>&1
)
echo Done.
if "%~1"=="" pause
exit /b 0

:web
call :stop_web stop
echo.
echo Starting EcoPulse web on http://localhost:%WEB_PORT% ...
echo Press q in this window to quit, or R for hot restart.
echo.
"%FLUTTER%" pub get
"%FLUTTER%" gen-l10n
"%FLUTTER%" run -d chrome --web-port=%WEB_PORT%
exit /b %ERRORLEVEL%

:apk
echo.
echo Building release APK (arm64)...
"%FLUTTER%" pub get
"%FLUTTER%" build apk --release --split-per-abi
if errorlevel 1 (
  echo [ERROR] Build failed.
  pause
  exit /b 1
)
echo.
echo OK: build\app\outputs\apk\release\TSEV-arm64-v8a.apk
pause
exit /b 0

:apk_all
echo.
echo Building release APK (all ABIs)...
"%FLUTTER%" pub get
"%FLUTTER%" build apk --release --split-per-abi
if errorlevel 1 (
  echo [ERROR] Build failed.
  pause
  exit /b 1
)
echo.
echo OK: build\app\outputs\apk\release\
dir /b "build\app\outputs\apk\release\TSEV-*.apk" 2>nul
pause
exit /b 0

:test
echo.
echo Running tests and analyze...
"%FLUTTER%" pub get
"%FLUTTER%" gen-l10n
"%FLUTTER%" test
if errorlevel 1 goto test_fail
"%FLUTTER%" analyze
:test_fail
pause
exit /b %ERRORLEVEL%
