# EcoPulse Home Server

Dart package in `server/` — shelf backend with **SQLite** (default) or **PostgreSQL**.

```powershell
dart pub get
dart run bin/server.dart --host 0.0.0.0 --port 8081
```

See [../docs/home-server.md](../docs/home-server.md) for full setup.

## Database

**SQLite (default)** — single file `data/ecopulse.db`, ideal for one Home Server instance.

**PostgreSQL** — for multi-instance / production deploy behind a load balancer:

```powershell
docker compose -f docker-compose.postgres.yml up -d
$env:ECOPULSE_DB_BACKEND = "postgres"
$env:ECOPULSE_DATABASE_URL = "postgresql://ecopulse:ecopulse@127.0.0.1:5432/ecopulse"
dart run bin/server.dart
```

Health check includes `"database": "sqlite"` or `"postgres"`.

## Backups

Automatic DB snapshots (default: every **24 hours**, keep **14** files in `data/backups/`):

```powershell
$env:ECOPULSE_BACKUP_INTERVAL_HOURS = "24"   # 0 = disable scheduler
$env:ECOPULSE_BACKUP_MAX_COUNT = "14"
```

Admin API (full admin JWT):

| Method | Path | Description |
|--------|------|-------------|
| GET | `/v1/admin/backups` | List + status |
| POST | `/v1/admin/backups` | Create snapshot now |
| GET | `/v1/admin/backups/:id/download` | Download file |
| POST | `/v1/admin/backups/:id/restore` | Restore (SQLite: online; PG: `psql`) |
| DELETE | `/v1/admin/backups/:id` | Delete snapshot |

Admin web: **Settings → Резервные копии БД**.

## Rate limiting

In-memory limits (per server process). Disable with `ECOPULSE_RATE_LIMIT=0`.

| Scope | Default | Env |
|-------|---------|-----|
| Login + register | 15 / 15 min per IP | `ECOPULSE_RATE_AUTH_MAX`, `ECOPULSE_RATE_AUTH_WINDOW_MIN` |
| Submit article (`POST /v1/articles`) | 5 / hour per user | `ECOPULSE_RATE_ARTICLE_MAX`, `ECOPULSE_RATE_ARTICLE_WINDOW_MIN` |
| Send message | 60 / min per user | `ECOPULSE_RATE_MESSAGE_MAX`, `ECOPULSE_RATE_MESSAGE_WINDOW_MIN` |

Exceeded limit → HTTP **429** `{ "error": "rate_limit_exceeded", "retryAfterSeconds": N }` and header `Retry-After`.

## API documentation (OpenAPI / Swagger)

Interactive docs and machine-readable spec for all `/v1/*` REST endpoints:

| URL | Description |
|-----|-------------|
| http://127.0.0.1:8081/v1/docs/ | Swagger UI |
| http://127.0.0.1:8081/v1/openapi.yaml | OpenAPI 3.0 YAML |
| http://127.0.0.1:8081/v1/openapi.json | Same spec as JSON |

Source: `server/openapi/openapi.yaml`. WebSocket chat (`/v1/ws/chat`) is described in the spec info block.

Docs endpoints skip the `X-App-Version` gate (same as `/v1/health`).

## Push notifications (FCM)

Register device tokens via `PUT /v1/profile/push-token`. To send instant push on article moderation events, set:

```powershell
$env:ECOPULSE_FCM_SERVER_KEY = "your-firebase-legacy-server-key"
dart run bin/server.dart
```

Events: new pending article → admins; approve/reject → author. Without the key, clients still get notifications via 15‑minute background polling.

## Real-time chat (WebSocket)

```
ws://<host>:8081/v1/ws/chat
```

First message: `{"type":"auth","token":"<JWT>"}`. Then: `join`, `leave`, `typing`, `ping` → server pushes `message`, `typing`, `threads_refresh`.
