# iOS build & TestFlight

EcoPulse targets **Android first**. iOS platform files are generated via Flutter; TestFlight requires macOS and an Apple Developer account.

## 1. Generate iOS project (any OS)

From the repo root:

```bash
flutter create --platforms=ios .
```

This adds `ios/` with Runner, Info.plist, and Xcode project.

## 2. Requirements (macOS only for archive)

- Mac with Xcode 15+
- Apple Developer Program ($99/year)
- Bundle ID: `com.ecopulse.ecopulse` (match Android applicationId)

## 3. Configure signing

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** → **Signing & Capabilities**
3. Team: your Apple Developer team
4. Enable **Automatically manage signing**

## 4. Permissions (Info.plist)

Add usage descriptions if enabling features on iOS:

```xml
<key>NSFaceIDUsageDescription</key>
<string>EcoPulse uses Face ID to lock the app</string>
<key>NSMicrophoneUsageDescription</key>
<string>Voice input for the assistant</string>
<key>NSUserNotificationsUsageDescription</key>
<string>Price alerts and chat notifications</string>
```

## 5. Build & upload

```bash
flutter build ipa --release \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=...
```

Or in Xcode: **Product → Archive → Distribute App → App Store Connect**.

## 6. TestFlight

1. [App Store Connect](https://appstoreconnect.apple.com) → **My Apps** → create **EcoPulse**
2. Upload IPA (Transporter or Xcode)
3. **TestFlight** → Internal testing → add testers
4. Paste listing copy from `docs/PLAY_STORE_LISTING.md` (adapt for App Store)

## 7. Known gaps (🟡)

- Firebase iOS: add `GoogleService-Info.plist` or use Dart `FirebaseOptions` (same dart-define as Android)
- Home widget: Android only today
- Workmanager background tasks: limited on iOS; use FCM for message push

## 8. CI (optional)

Use a macOS GitHub Actions runner + `fastlane pilot upload` when signing secrets are configured. Not enabled in this repo by default.
