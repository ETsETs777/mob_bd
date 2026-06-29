# Riverpod providers

State разбит по доменам. **Старые import-пути сохранены** — каждый файл в корне `providers/` re-export'ит реализацию из подпапки.

## Подпапки

| Папка | Ответственность |
|-------|-----------------|
| `app/` | Shell, locale, theme, demo, security, home layout flags |
| `markets/` | Stocks, crypto feed, watchlist, news, correlation |
| `portfolio/` | Paper portfolio, journal, rebalance, income |
| `settings/` | API keys, cloud backup, morning digest |
| `alerts/` | Price alerts, history, quiet hours |
| `profile/` | User profile, home server auth |
| `messages/` | Chat threads |
| `learn/` | Course progress |
| `customization/` | UserCustomization + section resolvers |
| `assistant/` | Assistant sheet state |
| `admin/` | Admin panel |
| `broker/` | Tinkoff read-only portfolio |
| `cloud/` | Supabase auth + data sync |
| `pro/` | Pro tier limits |

## Пример

```dart
// Оба варианта эквивалентны:
import '../../providers/watchlist_provider.dart';
import '../../providers/markets/watchlist_provider.dart';
```

## Добавление провайдера

1. Создайте файл в `providers/<domain>/my_feature_provider.dart`
2. Добавьте stub: `providers/my_feature_provider.dart` → `export '<domain>/my_feature_provider.dart';`
3. При необходимости зарегистрируйте invalidate в `demo_mode_provider.dart`
