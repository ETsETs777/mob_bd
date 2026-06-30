# EcoPulse Deep Links

Universal links for articles, chat threads, calendar events, and customization presets.

## URL formats

| Target | Custom scheme | HTTPS (App / Universal Links) |
|--------|---------------|----------------------------------|
| Article | `ecopulse://article/{id}` | `https://ecopulse.app/article/{id}` |
| Thread | `ecopulse://thread/{id}` | `https://ecopulse.app/thread/{id}` |
| Calendar event | `ecopulse://calendar/{id}` | `https://ecopulse.app/calendar/{id}` |
| Theme preset | `ecopulse://preset?v=1&d=…` | `https://ecopulse.app/preset?v=1&d=…` |

Legacy chat suffix `article:{id}` in messages is still supported.

## Mobile setup

**Android** — intent filters in `android/app/src/main/AndroidManifest.xml` (`android:autoVerify="true"` on HTTPS filters).

**iOS** — custom URL scheme in `ios/Runner/Info.plist`; Associated Domains in `ios/Runner/Runner.entitlements` (`applinks:ecopulse.app`).

## Server hosting (production)

For verified App Links / Universal Links, host these files on `https://ecopulse.app`:

### `/.well-known/assetlinks.json` (Android)

Replace `SHA256_CERT_FINGERPRINT` with your release keystore fingerprint (`keytool -list -v -keystore …`).

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.ecopulse.ecopulse",
      "sha256_cert_fingerprints": [
        "SHA256_CERT_FINGERPRINT"
      ]
    }
  }
]
```

### `/.well-known/apple-app-site-association` (iOS)

Replace `TEAM_ID` with your Apple Developer Team ID.

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.ecopulse.ecopulse",
        "paths": [
          "/article/*",
          "/thread/*",
          "/calendar/*",
          "/preset"
        ]
      }
    ]
  }
}
```

Serve both without redirects and with `Content-Type: application/json`.

## Code

- Parser: `lib/core/navigation/app_deep_link.dart`
- Navigation: `lib/core/navigation/app_link_navigator.dart`
- Listener: `lib/features/customization/app_link_listener.dart`

Sharing an article appends `https://ecopulse.app/article/{id}` to the share sheet and chat messages.
