# EcoPulse — полный план улучшений

> **Версия:** 1.0.55 · **Дата:** июнь 2026 · **Автор:** Цымбал Е. В.  
> Актуальный сводный документ: что сделано, что в работе, что планируется.  
> Дополняет [IMPROVEMENT_PLAN.md](IMPROVEMENT_PLAN.md) и [ROADMAP_V2.md](ROADMAP_V2.md).

---

## Легенда

| Метка | Значение |
|-------|----------|
| ✅ | Реализовано |
| 🟡 | Частично / требует доработки |
| ⬜ | Запланировано |
| **P0** | Критично — стабильность, безопасность, UX-блокеры |
| **P1** | Важно — заметная ценность для пользователя |
| **P2** | Желательно — polish, масштаб, платформы |
| **P3** | Идеи на будущее |

---

## 1. Текущее состояние (v1.0.45)

### Ядро приложения

| Область | Статус |
|---------|--------|
| 5 вкладок + опциональные Messages | ✅ |
| Riverpod + Hive cache | ✅ |
| RU/EN локализация | ✅ |
| 7 тем + акцент + фон | ✅ |
| PIN + биометрия | ✅ |
| Демо-режим | ✅ |
| 185 unit/widget-тестов | ✅ |
| CI: analyze + test + web build | ✅ |

### Недавно добавлено

| Функция | Статус |
|---------|--------|
| Реорганизация `providers/` по доменам + re-export stubs | ✅ |
| Реорганизация `test/` (app / core / features / data) | ✅ |
| Профиль-хаб (вкладка «Профиль», карточки счетов, меню) | ✅ |
| Биржевые графики (`candlesticks`: zoom, pan, volume, OHLC) | ✅ |
| Hub кастомизации (10+ секций, presets, sync) | ✅ |
| Home Server (LAN: login, чаты, profile ID) | ✅ |
| Cloud sync через JSON-файл | ✅ |
| Backup export/import | ✅ |
| Бумажный портфель + журнал сделок + rebalance | ✅ |
| AI-ассистент (Gemini + локальный fallback) | ✅ |

---

## 2. Архитектура и кодовая база

### P0 — стабильность

| # | Задача | Статус |
|---|--------|--------|
| 2.1 | Единая точка графиков `CustomChartView` + registry | ✅ |
| 2.2 | Re-export stubs для провайдеров (обратная совместимость импортов) | ✅ |
| 2.3 | `.gitignore`: `.cursor/`, APK в `releases/` | ✅ |
| 2.4 | Удалить мёртвые migration-скрипты из `tool/` | ✅ |
| 2.5 | `flutter analyze` без errors в `lib/` | 🟡 |
| 2.6 | Восстановить cloud sync panel (этап 9 кастомизации) после откатов | ✅ |

### P1 — структура

| # | Задача | Статус |
|---|--------|--------|
| 2.7 | Вынести `features/shared/widgets/` → `lib/shared/widgets/` | ✅ |
| 2.8 | Barrel-файлы по feature (`features/markets/markets.dart`) | ⬜ |
| 2.9 | `features/assistant/domain/` — сервисы из `core/services/assistant/` | ⬜ |
| 2.10 | Разбить `settings_screen.dart` (~1300 строк) на sub-screens | ✅ |
| 2.11 | Разбить `customization_screen.dart` на panels + hub | ✅ |
| 2.12 | Единый `AppRouter` / go_router вместо `openAppPage` + index | ⬜ |
| 2.13 | Schema migration v3 для `UserCustomization` (cloud bundle) | ⬜ |

### P2 — качество кода

| # | Задача | Статус |
|---|--------|--------|
| 2.14 | Dartdoc coverage > 90% (`tool/add_dartdoc.dart --check`) | 🟡 |
| 2.15 | Widget-тесты для ProfileHub, CustomChartView | ✅ |
| 2.16 | Integration test: onboarding → home → asset detail | ✅ |
| 2.17 | Golden tests для GlassCard, chart themes | ⬜ |
| 2.18 | Dependabot / `flutter pub outdated` в CI | ⬜ |

---

## 3. Профиль и аккаунт (Sber-style)

### P0

| # | Задача | Статус |
|---|--------|--------|
| 3.1 | Профиль-хаб с шапкой, каруселью «счетов», меню | ✅ |
| 3.2 | Личные данные: имя, аватар, email, телефон, страна | ✅ |
| 3.3 | Экран безопасности (PIN, биометрия) | ✅ |
| 3.4 | Экран документов (backup + cloud sync) | ✅ |

### P1

| # | Задача | Статус |
|---|--------|--------|
| 3.5 | Верификация email/телефона (OTP) | ⬜ |
| 3.6 | Фото-аватар (camera/gallery) вместо emoji | ⬜ |
| 3.7 | Уровни профиля / gamification («Investor Lv.2») | ⬜ |
| 3.8 | Карта лояльности / achievements (без токсичности) | ⬜ |
| 3.9 | Полноэкранный режим профиля с QR Profile ID | ⬜ |
| 3.10 | «Мои устройства» — список сессий home server | ⬜ |
| 3.11 | Юридические документы: Privacy Policy, Terms (in-app WebView) | ⬜ |
| 3.12 | Центр поддержки: FAQ + ссылка на Telegram/GitHub Issues | ⬜ |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 3.13 | OAuth: Google / Apple Sign-In | 🟡 |
| 3.14 | Supabase / Firebase sync профиля и watchlist | ✅ |
| 3.15 | Push-уведомления о входе с нового устройства | ⬜ |
| 3.16 | KYC-light: ИНН/паспорт только локально (опционально) | ⬜ |

---

## 4. Графики и рынки

### P0

| # | Задача | Статус |
|---|--------|--------|
| 4.1 | Свечи с pinch-zoom, pan, volume, crosshair | ✅ |
| 4.2 | Линейный график: ось цены справа, pan/zoom | ✅ |
| 4.3 | Переключатель линия/свечи на карточке актива | ✅ |
| 4.4 | Кастомизация: volume, pan/zoom, bull/bear colors | ✅ |

### P1

| # | Задача | Статус |
|---|--------|--------|
| 4.5 | Индикаторы: MA(7/25/99), RSI, MACD overlay | 🟡 |
| 4.6 | Полноэкранный график (landscape lock) | ✅ |
| 4.7 | Реальный volume с MOEX/CoinGecko (не estimate) | 🟡 |
| 4.8 | Lazy load истории при scroll влево (onLoadMoreCandles) | ✅ |
| 4.9 | Рисование линий тренда / уровней поддержки | ⬜ |
| 4.10 | Сравнение 2+ активов на одном графике (TradingView-style) | 🟡 |
| 4.11 | Order book mock / depth chart для crypto | ⬜ |
| 4.12 | WebSocket live ticks (Binance / MOEX) | 🟡 |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 4.13 | Экспорт графика в PNG/PDF с watermark | 🟡 |
| 4.14 | Алерты по пересечению MA / уровню цены | ⬜ |
| 4.15 | Heatmap секторов 2.0 (tap → sector detail) | ⬜ |
| 4.16 | Bond ladder + yield curve интерактив | 🟡 |

---

## 5. Портфель и финансы

### P0

| # | Задача | Статус |
|---|--------|--------|
| 5.1 | Бумажный портфель 100k ₽, P&L | ✅ |
| 5.2 | Журнал сделок + CSV export | ✅ |
| 5.3 | Rebalance plan | ✅ |
| 5.4 | Карточка портфеля в профиле-хабе | ✅ |

### P1

| # | Задача | Статус |
|---|--------|--------|
| 5.5 | Несколько «счетов» / портфелей (ИИС, USD, crypto) | ✅ |
| 5.6 | Цели накопления («100k к декабрю») | ✅ |
| 5.7 | Дивиденды и купоны в cash-flow календаре | 🟡 |
| 5.8 | Scenario stress-test UI (rate +2%, BTC -20%) | 🟡 |
| 5.9 | Tax report (упрощённый, локальный расчёт) | 🟡 |
| 5.10 | Import сделок из CSV / broker export | 🟡 |
| 5.11 | Real-time portfolio value ticker | 🟡 |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 5.12 | Подключение реального брокера (read-only API) | 🟡 |
| 5.13 | Robo-advisor lite (allocation suggestions) | 🟡 |

---

## 6. Кастомизация

### P0

| # | Задача | Статус |
|---|--------|--------|
| 6.1 | Hub: тема, графики, home, navigation, markets, portfolio | ✅ |
| 6.2 | Presets (встроенные + пользовательские) | ✅ |
| 6.3 | Per-context chart profiles | ✅ |
| 6.4 | Export/import customization JSON | ✅ |

### P1

| # | Задача | Статус |
|---|--------|--------|
| 6.5 | Cloud sync panel (авто-sync на home server) | ✅ |
| 6.6 | Multi-device sync через server API | ⬜ |
| 6.7 | Marketplace пресетов (share preset link) | ✅ |
| 6.8 | Live preview 2.0 (все экраны в carousel) | ✅ |
| 6.9 | Widget preview в hub (Android home widget) | ✅ |
| 6.10 | A/B theme preview (side-by-side) | ✅ |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 6.11 | Custom CSS-like tokens (user-defined colors) | ⬜ |
| 6.12 | Plugin slots для third-party chart themes | ⬜ |

---

## 7. Главная и контент

### P1

| # | Задача | Статус |
|---|--------|--------|
| 7.1 | Drag-and-drop home sections (уже есть reorder) | ✅ |
| 7.2 | Экономический радар + brief | ✅ |
| 7.3 | Новости Finnhub | ✅ |
| 7.4 | Macro calendar + timeline | ✅ |
| 7.5 | Smart digest персонализация (только watchlist) | ⬜ |
| 7.6 | Виджет «что изменилось за ночь» на lock screen | ⬜ |
| 7.7 | Stories / cards carousel для обучения | ⬜ |
| 7.8 | Seasonal themes (Новый год, etc.) | ⬜ |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 7.9 | iOS WidgetKit + Live Activities | ⬜ |
| 7.10 | Wear OS complication (USD/RUB) | ⬜ |

---

## 8. Ассистент и AI

### P1

| # | Задача | Статус |
|---|--------|--------|
| 8.1 | Gemini + локальный FAQ responder | ✅ |
| 8.2 | Voice input/output | ✅ |
| 8.3 | Кастомизация ассистента (chips, tone) | ✅ |
| 8.4 | Context-aware: «покажи мой портфель» → navigation | 🟡 |
| 8.5 | RAG по docs/ + user's notes | ⬜ |
| 8.6 | Offline LLM (on-device, small model) | ⬜ |

---

## 9. Сообщения и социальное

### P1

| # | Задача | Статус |
|---|--------|--------|
| 9.1 | P2P чаты через home server | ✅ |
| 9.2 | Profile ID + copy/share | ✅ |
| 9.3 | Push для новых сообщений (FCM) | ✅ |
| 9.4 | Share watchlist / portfolio snapshot в чат | ⬜ |
| 9.5 | E2E encryption для сообщений | ⬜ |

---

## 10. Backend и синхронизация

### P1

| # | Задача | Статус |
|---|--------|--------|
| 10.1 | Home server: auth, profile, chats, customization API | 🟡 |
| 10.2 | File-based cloud sync (Drive/Telegram share) | ✅ |
| 10.3 | Auto-sync по Wi-Fi при изменении данных | ⬜ |
| 10.4 | Conflict resolution UI (local vs remote diff) | ⬜ |
| 10.5 | HTTPS + Let's Encrypt для home server | ⬜ |
| 10.6 | Docker compose one-liner deploy | ⬜ |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 10.7 | Managed cloud (Supabase) как альтернатива self-host | ✅ |
| 10.8 | Admin dashboard web (users, metrics, flags) | 🟡 |
| 10.9 | Rate limiting + audit log на server | ⬜ |

---

## 11. Безопасность

### P0

| # | Задача | Статус |
|---|--------|--------|
| 11.1 | PIN hash (не plaintext) | ✅ |
| 11.2 | API keys в Secure Storage / exclude from backup | ✅ |
| 11.3 | App lock on background | ✅ |

### P1

| # | Задача | Статус |
|---|--------|--------|
| 11.4 | Certificate pinning для home server | ⬜ |
| 11.5 | Root/jailbreak detection (warning) | ⬜ |
| 11.6 | Screenshot block на PIN screen | ⬜ |
| 11.7 | Auto-lock timeout настройка (1/5/15 min) | ⬜ |
| 11.8 | Security audit (OWASP mobile checklist) | ⬜ |

---

## 12. UI/UX и дизайн

### P1

| # | Задача | Статус |
|---|--------|--------|
| 12.1 | GlassCard на главной | ✅ |
| 12.2 | Profile hub Sber-style | ✅ |
| 12.3 | Единый GlassCard в settings (сейчас plain Card) | ⬜ |
| 12.4 | Skeleton loading везде (не только home) | 🟡 |
| 12.5 | Haptic feedback consistency audit | 🟡 |
| 12.6 | Tablet master-detail (график + список) | ✅ |
| 12.7 | Accessibility: TalkBack, contrast mode test | ⬜ |
| 12.8 | Dynamic type / font scale 0.8–1.4 | 🟡 |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 12.9 | Rive/Lottie micro-animations на empty states | ⬜ |
| 12.10 | Brand refresh: icon, splash, store screenshots | ⬜ |
| 12.11 | Dark OLED pure black audit всех экранов | 🟡 |

---

## 13. Платформы и релизы

### P1

| # | Задача | Статус |
|---|--------|--------|
| 13.1 | Android APK/AAB release pipeline | ✅ |
| 13.2 | GitHub Releases (APK attach, changelog) | ✅ |
| 13.3 | Web PWA: install prompt, offline shell | 🟡 |
| 13.4 | Play Store listing (RU + EN) | ✅ |

### P2

| # | Задача | Статус |
|---|--------|--------|
| 13.5 | iOS build + TestFlight | 🟡 |
| 13.6 | Desktop (Windows/macOS) windowed layout | ⬜ |
| 13.7 | Fastlane / Codemagic CI → store | ⬜ |

---

## 14. Монетизация (опционально)

| # | Задача | Приоритет |
|---|--------|-----------|
| 14.1 | EcoPulse Pro: unlimited alerts, advanced charts | 🟡 |
| 14.2 | Pro: export CSV/PDF без watermark | P3 |
| 14.3 | Tip jar / donate link | P3 |
| 14.4 | B2B white-label для финансовых курсов | P3 |

---

## 15. Документация и процессы

| # | Задача | Статус |
|---|--------|--------|
| 15.1 | `docs/project-structure.md` | ✅ |
| 15.2 | `docs/customization-schema.md` | ✅ |
| 15.3 | Обновить IMPROVEMENT_PLAN до v1.0.44 | ⬜ |
| 15.4 | CHANGELOG.md (Keep a Changelog) | ✅ |
| 15.5 | CONTRIBUTING.md для open source | ⬜ |
| 15.6 | Architecture Decision Records (ADR/) | ⬜ |
| 15.7 | User guide / in-app onboarding tour 2.0 | ⬜ |

---

## 16. Рекомендуемые фазы

### Фаза A — «Стабильный v1.5» (2–3 недели)

1. Cloud sync panel + server customization API (6.5, 2.6)
2. Разбить settings/customization на sub-screens (2.10, 2.11)
3. Полноэкранный график + MA indicators (4.6, 4.5)
4. GitHub Releases + CHANGELOG (13.2, 15.4)
5. Widget + integration tests (2.15, 2.16)

### Фаза B — «Pro UX» (1–2 месяца)

1. Несколько портфелей / цели (5.5, 5.6)
2. OAuth + Supabase sync (3.13, 3.14, 10.7)
3. Tablet layout (12.6)
4. Push messages + FCM (9.3)
5. Play Store release (13.4)

### Фаза C — «v2.0 Platform» (3–6 месяцев)

1. iOS + TestFlight (13.5)
2. WebSocket live data (4.12)
3. Admin dashboard (10.8)
4. EcoPulse Pro tier (14.1)
5. Broker read-only integration (5.12)

---

## 17. Метрики успеха

| Метрика | Цель v1.5 | Цель v2.0 |
|---------|-----------|-----------|
| Unit-тесты | 250+ | 400+ |
| `flutter analyze` errors | 0 | 0 |
| Crash-free sessions | > 99% | > 99.5% |
| Cold start | < 2.5 s | < 2 s |
| APK size (arm64) | < 30 MB | < 28 MB |
| Store rating | — | 4.5+ |

---

## 18. Связанные документы

- [IMPROVEMENT_PLAN.md](IMPROVEMENT_PLAN.md) — историческая дорожная карта v1.0
- [ROADMAP_V2.md](ROADMAP_V2.md) — аккаунт, backend, масштаб
- [project-structure.md](project-structure.md) — структура `lib/`
- [customization-schema.md](customization-schema.md) — JSON schema v2
- [architecture.md](architecture.md) — слои и провайдеры
- [design-system.md](design-system.md) — UI-токены

---

*Документ обновлять при каждом minor-релизе (1.0.x → 1.1.0).*
