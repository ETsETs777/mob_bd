# Скрипты запуска EcoPulse (Windows PowerShell)

## 1. Физический телефон (рекомендуется)

```powershell
# Подключите телефон по USB, включите USB-отладку
$env:Path = "C:\Users\9571\flutter\bin;C:\Users\9571\AppData\Local\Android\Sdk\platform-tools;" + $env:Path
adb devices
cd C:\Users\9571\Desktop\mob
flutter run
```

## 2. Эмулятор Android Studio

```powershell
$env:Path = "C:\Users\9571\flutter\bin;C:\Users\9571\AppData\Local\Android\Sdk\emulator;C:\Users\9571\AppData\Local\Android\Sdk\platform-tools;" + $env:Path

# Если эмулятор не стартует — установите Hypervisor (от администратора, затем перезагрузка):
# C:\Users\9571\AppData\Local\Android\Sdk\extras\google\Android_Emulator_Hypervisor_Driver\silent_install.bat

flutter emulators --launch Pixel_10_Pro_XL
# Подождите 1–2 минуты загрузки
flutter devices
cd C:\Users\9571\Desktop\mob
flutter run
```

## 3. Chrome (быстрая проверка UI)

```powershell
$env:Path = "C:\Users\9571\flutter\bin;" + $env:Path
cd C:\Users\9571\Desktop\mob
flutter create . --platforms=web
flutter run -d chrome
```

## 4. Release APK на телефон

```powershell
flutter install --release
# или вручную: build\app\outputs\flutter-apk\app-release.apk
```
