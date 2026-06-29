# FCM setup for EcoPulse message push

EcoPulse can deliver **chat message notifications** via Firebase Cloud Messaging when built with Firebase keys. Without FCM, the app still polls the home server every 15 minutes in the background (Workmanager).

## Architecture

1. **Client** registers FCM token with home server: `PUT /v1/profile/push-token`
2. **Home server** sends FCM when a new message is stored (server-side implementation required)
3. **Fallback**: periodic background task compares thread `lastAt` and shows local notifications

## 1. Firebase project

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an **Android app** with package `com.ecopulse.ecopulse`
3. Copy **Project ID**, **App ID**, **API key**, **Sender ID** from project settings

Optional: download `google-services.json` into `android/app/` and apply the Google Services Gradle plugin. Dart-only init (below) works without the JSON file.

## 2. Build with dart-define

```bash
flutter run \
  --dart-define=FIREBASE_PROJECT_ID=your-project \
  --dart-define=FIREBASE_APP_ID=1:123456789:android:abc \
  --dart-define=FIREBASE_API_KEY=AIza... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=123456789
```

Release:

```bash
flutter build appbundle --release \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=...
```

## 3. Home server API

### Register token

```
PUT /v1/profile/push-token
Authorization: Bearer <token>
Content-Type: application/json

{ "token": "<fcm_token>", "platform": "android" }
```

### Unregister

```
DELETE /v1/profile/push-token?token=<fcm_token>
Authorization: Bearer <token>
```

### Recommended FCM payload

```json
{
  "notification": {
    "title": "Alice",
    "body": "Hello!"
  },
  "data": {
    "threadId": "thread-uuid",
    "title": "Alice",
    "body": "Hello!"
  },
  "token": "<device_fcm_token>"
}
```

## 4. In-app

**Profile → Notifications → Chat notifications**

- Requires home server sign-in
- Registers FCM token on enable / login
- Foreground polling also notifies when `lastAt` changes on inactive threads

## 5. Server-side FCM (reference)

Use Firebase Admin SDK on the home server when saving a message:

- Look up recipient device tokens from your DB
- Send multicast via `admin.messaging().sendEachForMulticast(...)`

404 on push-token endpoints is ignored by the client (older server versions).
