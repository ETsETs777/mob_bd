# EcoPulse customization JSON schema

Version **2** (`schemaVersion` in `meta`). Single source of truth: Hive key `customization_config` and cloud endpoint `GET/PUT /v1/profile/customization`.

## Top-level document

```json
{
  "meta": {
    "schemaVersion": 2,
    "updatedAt": "2026-06-28T12:00:00.000Z",
    "activePresetId": "classic",
    "remoteFingerprint": "",
    "lastSyncedAt": null
  },
  "appearance": { },
  "charts": { },
  "home": { },
  "navigation": { },
  "markets": { },
  "portfolio": { },
  "widgets": { },
  "dataDisplay": { },
  "assistant": { }
}
```

## Sections

| Section | Purpose |
|---------|---------|
| `appearance` | Theme, accent, background, density, card style, font/UI scale, animations |
| `charts` | Default chart type/period/height, visual flags, per-screen profiles |
| `home` | Section order/visibility, templates, quick actions, news count |
| `navigation` | Tab order, visibility, default tab, FAB, custom labels |
| `markets` | Sort, grouping, columns, watchlist layout, home blocks |
| `portfolio` | Allocation chart, header metrics, journal columns, P/L period |
| `widgets` | Android home widget layout, slot keys, sync appearance |
| `dataDisplay` | Base currency, locale, number/date/time formats |
| `assistant` | Brain mode, TTS, quick chips, response length, FAB position |

## Export bundle (file / cloud)

For sharing presets or cloud sync, use `CustomizationBundle`:

```json
{
  "bundleVersion": 1,
  "exportedAt": "2026-06-28T12:00:00.000Z",
  "fingerprint": "sha256-hex",
  "activePresetId": "trader",
  "config": { },
  "userPresets": [ ]
}
```

- `fingerprint` — stable hash of payload (excluding fingerprint field).
- `userPresets` — only non-built-in presets; built-ins are identified by `activePresetId`.

## Preset object

```json
{
  "id": "my_preset",
  "nameRu": "Мой профиль",
  "nameEn": "My profile",
  "isBuiltIn": false,
  "config": { }
}
```

Built-in preset ids: `classic`, `trader`, `analyst`, `oled`, `minimal`.

## Migration

- **v1 → v2**: adds `meta.remoteFingerprint`, `meta.lastSyncedAt`; handled by `CustomizationMigrator`.
- Legacy Hive keys (`theme_mode`, `widget_slot1`, …) are read once on first launch if `customization_config` is missing; then only `customization_config` is authoritative.

## Validation

- Import presets with `CustomizationPreset.fromJson`.
- Full config with `UserCustomization.fromJson` (runs migrator).
- Bundle with `CustomizationBundle.fromJson` or `CustomizationBundle.parseExport`.

## Cloud API

```http
GET /v1/profile/customization
Authorization: Bearer <token>
→ 200 { "customization": { ...bundle fields... } }
→ 404 if never saved

PUT /v1/profile/customization
{ "customization": { ...bundle fields... } }
→ 200 { "customization": ..., "updatedAt": "..." }
```

Conflict resolution on client: `keepLocal`, `useRemote`, or `merge` (union user presets by id).
