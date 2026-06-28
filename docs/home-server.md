# EcoPulse Home Server (Windows)

LAN backend for Profile ID, registration, and user-to-user chats.

## Requirements

- Dart SDK 3.12+ (same as Flutter SDK)
- Phone and PC on the same Wi‑Fi
- Windows Firewall: allow inbound TCP **8081** on Private network (once)

## Quick start

```powershell
cd server
dart pub get
dart run bin/server.dart --host 0.0.0.0 --port 8081
```

Or from repo root:

```powershell
.\scripts\run-server.ps1
```

Health check: `http://127.0.0.1:8081/v1/health`

## Find your PC IP

```powershell
ipconfig
```

Use the **IPv4 Address** of your Wi‑Fi adapter, e.g. `http://192.168.1.105:8081`.

Android emulator: `http://10.0.2.2:8081`

## Seed test users

```powershell
cd server
dart run bin/seed_test_users.dart
```

Creates `user1` / `user1pass` and `user2` / `user2pass`.

## App setup

1. Settings → **Home server** → enter URL → **Check connection**
2. Register or sign in → copy **Profile ID**
3. Tab **Messages** → self chat + direct chats
4. **Create test2** for a second account → **Switch account** to test two users

## Data

SQLite database: `server/data/ecopulse.db`

Passwords: bcrypt only. Audit logs: no passwords or message text.

## API

Prefix: `/v1/*`

Client headers:

- `X-App-Version: 1.0.44`
- `X-Api-Version: 1`
- `Authorization: Bearer <JWT>` (after login)

## Security notes (MVP)

- HTTP on LAN only — do not expose port 8081 to the internet
- Change `ECOPULSE_JWT_SECRET` env var for non-dev use
- JWT TTL: 7 days
