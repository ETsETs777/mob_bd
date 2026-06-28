# EcoPulse — Roadmap v2.0 (аккаунт, админка, масштаб)

> Дополнение к `IMPROVEMENT_PLAN.md`. Приоритеты на 2–4 месяца.

---

## Дополнительные фишки (рекомендации)

### P0 — Удержание и персонализация

| Фишка | Зачем | Сложность |
|-------|-------|-----------|
| **Аккаунт / профиль** | Имя, аватар, синхронизация watchlist и настроек между устройствами | 🟡 |
| **Гостевой режим** | Всё работает локально без регистрации; аккаунт — опция | 🟢 |
| **Облачный backup** | Экспорт/импорт настроек + watchlist (JSON / Firebase) | 🟡 |
| **Push-digest** | Утренний brief «за ночь изменилось…» | 🟡 |
| **Портфель (бумажный)** | Виртуальные 100k ₽, P&L, доли секторов | 🔴 |

### P1 — Социальное и контент

| Фишка | Зачем |
|-------|-------|
| **Экономические новости** | Finnhub / RSS лента на главной |
| **Комментарии к активу** | Локальные заметки «купил @ 85» |
| **Share portfolio snapshot** | PNG/текст для Telegram |
| **Рейтинг «инвестор дня»** | Gamification (опционально, без токсичности) |

### P1 — Pro / монетизация (опционально)

| Фишка | Зачем |
|-------|-------|
| **EcoPulse Pro** | Больше тикеров, алерты без лимита, экспорт CSV |
| **Расширенная аналитика** | Корреляции N активов, бэктест |
| **Без рекламы** | Если появится рекламная модель |

### P2 — Платформы

| Фишка | Зачем |
|-------|-------|
| **iOS + App Store** | `flutter build ios` |
| **Web PWA** | Уже частично; offline + install prompt |
| **Tablet layout** | Master-detail для графиков |
| **Wear OS tile** | USD/RUB на часах |

---

## Аккаунт — как сделать правильно

### Фаза 1 (локально, уже можно)

```
Hive / Secure Storage
├── user_profile { displayName, avatarEmoji, countryCode }
├── preferences mirror (theme, accent, background)
└── watchlist + alerts (уже есть)
```

- Экран **«Профиль»** в настройках: имя, страна для инфляции, базовая валюта.
- Без сервера — всё на устройстве.

### Фаза 2 (облако)

**Стек (рекомендация):** Supabase (Auth + Postgres + RLS) или Firebase Auth + Firestore.

```
users
  id, email, display_name, created_at

user_settings
  user_id, theme, accent, background, locale, default_tab

watchlist_items
  user_id, asset_key, added_at

price_alerts
  user_id, rule_json, enabled
```

- **OAuth:** Google + Apple (iOS) + email magic link.
- **Offline-first:** локальный Hive = source of truth, sync при сети (conflict: last-write-wins для настроек).

### UX аккаунта

1. При первом запуске — «Продолжить как гость» / «Войти».
2. В настройках — карточка профиля с прогрессом синхронизации.
3. При выходе — данные остаются локально (не удалять watchlist).

---

## Админ-панель — архитектура

### Зачем

- Мониторинг API (MOEX, CoinGecko, Frankfurter).
- Управление feature flags без релиза.
- Просмотр кэша, принудительный refresh.
- В будущем — модерация, статистика пользователей.

### Уровни доступа

| Роль | Где | Как |
|------|-----|-----|
| **Dev (local)** | In-app экран | 10× tap на версию в «О приложении» (уже заложено) |
| **Staging admin** | `/admin` web или отдельный flavor | `ADMIN_PIN` в env |
| **Production admin** | Backend only | JWT role `admin` + 2FA |

### In-app Admin Panel (v1 — реализовано)

```
AdminPanelScreen
├── Статус API (ping + latency)
├── Кэш (ключ, возраст, размер записей)
├── Каталог (N валют / MOEX / US / crypto)
├── [Force refresh all]
├── Feature flags (Hive toggles)
└── Logs (последние HTTP из Dio interceptor)
```

### Backend admin (v2 — когда будет аккаунт)

```
/admin (Flutter Web или Retool)
├── Dashboard: DAU, crashes, API errors
├── Users: search, ban, reset sync
├── Feature flags: remote config (Firebase Remote Config / Supabase)
├── Content: новости, баннеры на главной
└── Jobs: пересборка кэша, health checks
```

**Безопасность:**

- Никогда не хранить admin PIN в APK plaintext — только `String.fromEnvironment` для dev builds.
- Production: только server-side admin с OAuth + allowlist email.
- Rate limit на admin API.

### Feature flags (пример)

```dart
enum FeatureFlag {
  extendedMoexCatalog,  // ✅ v1.0.19
  finnhubNews,
  paperPortfolio,
  cloudSync,
}
```

Хранение: `Hive box feature_flags` + позже Remote Config.

---

## Масштабирование каталога (v1.0.19)

| Актив | Было | Стало | UX |
|-------|------|-------|-----|
| MOEX | 5 | **29** | Фильтр РФ / США / Все + группы по секторам |
| US (Finnhub) | 5 | **28** | ETF отдельной группой |
| Crypto | 20 | **50** | Поиск + избранное |
| FX (Frankfurter) | 4 | **26** | Группы: основные / Европа / Азия / EM |
| MOEX FX | USD, EUR | без изменений | sparkline 30d |

**Производительность:**

- MOEX: batch по 6 тикеров параллельно.
- FX: один `latest` на все коды; history только для топ-8.
- Кэш 1ч (валюты) / 15–30 мин (рынки).

---

## Рекомендуемый порядок после v1.0.19

```
Спринт 1: Профиль (локальный) + облачный backup JSON
Спринт 2: Finnhub news + lazy pagination crypto page 2
Спринт 3: Supabase auth + sync watchlist
Спринт 4: Remote admin + feature flags
Спринт 5: Paper portfolio + Pro tier
```
