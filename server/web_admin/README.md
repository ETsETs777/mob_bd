# EcoPulse Admin Web

Отдельная веб-панель для staff Home Server: модерация, контент, пользователи, аудит и настройки.

## Запуск

```powershell
cd server
dart run bin/server.dart
```

Откройте в браузере: **http://127.0.0.1:8081/admin/**

## Вход

- Аккаунт с staff-ролью: **moderator**, **editor** или **admin**
- Логин из `server_meta.admin_logins` при регистрации получает роль **admin** автоматически

Создать тестовых пользователей:

```powershell
cd server
dart run bin/seed_test_users.dart
```

## Роли (RBAC)

| Роль | Права |
|------|--------|
| **moderator** | Дашборд, модерация (approve/reject, batch) |
| **editor** | Дашборд, статьи (CRUD, версии, обложки, batch delete) |
| **admin** | Всё выше + пользователи, аудит, настройки, назначение ролей |

## Возможности

| Раздел | Функции |
|--------|---------|
| **Дашборд** | Статистика: пользователи, статьи, чаты, последний аудит |
| **Статьи** | Поиск, фильтр, редактирование, история версий, массовые операции *(editor/admin)* |
| **Написать** | Markdown + preview, обложка, отложенная публикация *(editor/admin)* |
| **Модерация** | Очередь pending, batch approve/reject *(moderator/admin)* |
| **Пользователи** | Список, назначение ролей *(admin)* |
| **Аудит** | Журнал `audit_logs` *(admin)* |
| **Настройки** | `min_app_version`, `admin_logins` *(admin)* |

## API (admin)

```
GET    /v1/admin/dashboard
GET    /v1/admin/articles?status=&q=&limit=&offset=
POST   /v1/admin/articles
PATCH  /v1/admin/articles/:id
GET    /v1/admin/articles/:id/versions
POST   /v1/admin/articles/:id/rollback
POST   /v1/admin/articles/batch/approve|reject|delete
POST   /v1/admin/articles/:id/approve|reject
GET    /v1/admin/users?q=
PATCH  /v1/admin/users/:id             { role?, displayName? }
GET    /v1/admin/audit
GET/PATCH /v1/admin/settings
```

Auth/profile возвращает: `role`, `isStaff`, `canModerate`, `canEditContent`, `isAdmin`.

Все эндпоинты требуют `Authorization: Bearer <JWT>` и соответствующую staff-роль.
