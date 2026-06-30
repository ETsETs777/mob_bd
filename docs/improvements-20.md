# 20 улучшений EcoPulse

Приоритетные направления развития проекта после Community/Calendar/Articles.

## Продукт и UX

1. **Rich-text редактор статей** — ✅ v1: панель Markdown (жирный, курсив, цитата, код, картинка, YouTube, разделитель), вкладки «Редактор / Просмотр», рендер изображений и YouTube в `ArticleBodyView`. ✅ **v2:** зачёркнутый, нумерованный список, H1–H3, таблицы, ссылка с URL-диалогом; стили таблиц/strike в `ArticleBodyView`; toolbar + улучшенный preview в admin web.
2. **Push-уведомления о модерации** — ✅ FCM с сервера + локальный fallback: автор при approve/reject, admin при новой статье; `ECOPULSE_FCM_SERVER_KEY` на сервере.
3. **Real-time чат** — ✅ WebSocket `/v1/ws/chat` (сообщения + typing), fallback polling 12 с при обрыве.
4. **Онбординг и empty states** — ✅ guided tour (Community, календарь, Home Server) + rich empty states с CTA.
5. **Тёмная/светлая тема per-tab** — ✅ пресеты Markets (dark) / Profile (light) в кастомизации; `effectiveThemeModeProvider`.

## Админ и контент

6. **Admin web v2** — ✅ preview Markdown, drag-n-drop обложки, `publish_at` (отложенная публикация).
7. **Теги и категории статей** — ✅ категории/теги в БД и API, фильтры в Community, featured-лента на Home, admin web.
8. **Версионирование статей** — ✅ снимки при правках (admin/author), история и rollback в admin web.
9. **Массовые операции** — ✅ batch approve/reject/delete в admin web (статьи + модерация).
10. **RBAC** — ✅ роли moderator / editor / admin, разграничение прав в API и admin web.

## Сервер и инфраструктура

11. **HTTPS + reverse proxy** — nginx/Caddy для production Home Server.
12. **PostgreSQL option** — ✅ `ECOPULSE_DB_BACKEND=postgres` + `ECOPULSE_DATABASE_URL`; абстракция `DbExecutor` (SQLite/PostgreSQL), async API сервисов, `docker-compose.postgres.yml`.
13. **Backup/restore API** — ✅ снимки SQLite (online backup API) / PostgreSQL (`pg_dump`), расписание `ECOPULSE_BACKUP_INTERVAL_HOURS`, admin API + UI в «Настройки».
14. **Rate limiting & abuse protection** — ✅ лимиты login/register (по IP), submit article и send message (по user); HTTP 429 + `Retry-After`; env `ECOPULSE_RATE_*`.
15. **OpenAPI/Swagger** — ✅ `server/openapi/openapi.yaml`, Swagger UI `/v1/docs/`, spec `/v1/openapi.yaml` + `/v1/openapi.json`.

## Мобильное приложение

16. **Offline-first Community** — ✅ кэш ленты + «мои» статьи, outbox submit/update/delete, sync при online, conflict resolution (local vs server).
17. **Deep links universal** — ✅ `ecopulse://` + `https://ecopulse.app/` для article/thread/calendar (+ preset); Android App Links + iOS Universal Links config; `docs/deep-links.md`.
18. **Widget refresh pipeline** — ✅ `HomeWidgetRefreshPipeline` (debounce, bind в MainShell); footer portfolio + ближайшее событие календаря; tap → `ecopulse://calendar/{id}`.
19. **i18n completeness** — ✅ 100% DE/IT/RU для Community strings (offline sync, conflict, markdown, featured); тест `test/l10n/community_i18n_completeness_test.dart`.
20. **CI/CD** — ✅ GitHub Actions: test (Flutter + server) → web build → APK/AAB → GitHub Release; артефакты `ecopulse-web` + `ecopulse-admin-web`; `docs/ci-cd.md`.

---

*Admin web panel реализован в `server/web_admin/` — пункты 6, 9, 10 частично закрывают направление «Админ и контент».*
