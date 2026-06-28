# Библиотеки для улучшения дизайна EcoPulse

Список пакетов **только для UI/UX** — что подключено, что планируется, и чеклист визуальных задач.

> Полный roadmap: [`IMPROVEMENT_PLAN.md`](IMPROVEMENT_PLAN.md) → раздел **«План визуала и UI»**

---

## Подключено в проекте (pubspec.yaml)

| Пакет | Назначение | Где используется |
|-------|------------|------------------|
| [google_fonts](https://pub.dev/packages/google_fonts) | Шрифт Inter — современный fintech-стиль | Вся типографика |
| [flutter_animate](https://pub.dev/packages/flutter_animate) | Плавные fade/slide анимации карточек и экранов | Home, Markets, Settings |
| [gap](https://pub.dev/packages/gap) | Семантические отступы `Gap(12)` вместо `SizedBox` | Все экраны |
| [iconsax_flutter](https://pub.dev/packages/iconsax_flutter) | Современные иконки (Iconsax) | Navigation, Settings |
| [shimmer](https://pub.dev/packages/shimmer) | Skeleton loading при загрузке данных | Loading states |
| [fl_chart](https://pub.dev/packages/fl_chart) | Линейные и bar-графики с градиентами | Валюты, инфляция, детали |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | Кэш иконок крипто без мерцания | Asset detail |

---

## Планируется подключить (по приоритету)

| Пакет | Назначение | Приоритет | Задача в плане |
|-------|------------|-----------|----------------|
| [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) | Splash screen с логотипом | **P0** | Брендинг |
| [lottie](https://pub.dev/packages/lottie) | JSON-анимации для empty states | **P0** | Empty states |
| [flutter_staggered_animations](https://pub.dev/packages/flutter_staggered_animations) | Каскадное появление списков | **P1** | Рынки |
| [share_plus](https://pub.dev/packages/share_plus) | Share PNG карточки/графика | **P1** | Share snapshot |
| [flex_color_scheme](https://pub.dev/packages/flex_color_scheme) | Профессиональные light/dark схемы | P2 | Accent picker |
| [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) | Адаптивные размеры под экраны | P2 | Планшеты |
| [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator) | Точки для onboarding | P2 | Onboarding |
| [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) | Candlestick, treemap (community) | P3 | Продвинутые графики |

---

## Чеклист визуальных изменений

### ✅ Сделано (v1.0.2)

- [x] Material 3 + `AppPalette` (dark / light / system)
- [x] Google Fonts Inter
- [x] `MetricCard` со sparkline, badge источника, % изменения
- [x] fl_chart: градиент, сетка, подписи осей
- [x] Shimmer skeleton loaders (inline по секциям на главной)
- [x] flutter_animate на карточках
- [x] Hero-анимация на деталях актива
- [x] Iconsax в навигации
- [x] Haptic feedback на табах и refresh
- [x] SegmentedButton для темы и базовой валюты
- [x] `LastUpdatedBanner` на экранах
- [x] **Экономический brief «Сегодня»**
- [x] **Animated numbers** на MetricCard
- [x] **EmptyState** виджет (Markets)
- [x] **Splash screen** (flutter_native_splash, фон #0D1117)
- [x] Long-press → копировать котировку

### 🔲 Ближайшие (P0–P1)

- [ ] Кастомная иконка + adaptive icon Android
- [ ] Splash с логотипом (сейчас только цвет фона)
- [ ] Onboarding 3 экрана (первый запуск)
- [ ] Empty states с Lottie (сейчас базовый EmptyState)
- [ ] Crosshair + tooltip на line chart
- [x] Sparkline в списке «Рынки» (через MetricCard)

### 🔲 Средний срок (P2)

- [ ] OLED-тема (pure black `#000000`)
- [ ] Accent color picker в настройках
- [ ] Compact mode — сетка 2×2 на главной
- [ ] Bottom sheet preview актива (без full push)
- [ ] Long-press menu на карточках
- [ ] Share chart/card as PNG
- [ ] Landscape двухколоночный layout

---

## Тема приложения

| Режим | Фон | Акцент | Текст |
|-------|-----|--------|-------|
| Тёмная (default) | `#0D1117` | `#58A6FF` | `#F0F6FC` |
| Светлая | `#F6F8FA` | `#0969DA` | `#1F2328` |
| OLED (planned) | `#000000` | настраиваемый | `#F0F6FC` |

Переключение: **Настройки → Тема → Тёмная / Светлая / Системная**  
Сохранение в Hive.

---

## Design tokens (AppPalette)

```
background      — scaffold
surface         — cards
surfaceLight    — inputs, badges
border          — card borders, dividers
textPrimary     — заголовки, значения
textSecondary   — подписи, метки
accent          — кнопки, selected tab, links
positive        — рост, profit
negative        — падение, loss
chartGrid       — линии сетки графиков
chartGradient*  — заливка под line chart
```

---

## Не нужно для MVP

- **GetX / Bloc** — state уже на Riverpod
- **Material 2 legacy widgets** — используем Material 3
- **Сторонние UI-kit (GetWidget и т.п.)** — конфликтуют с кастомной темой
- **glassmorphism everywhere** — перегружает fintech UI; только точечно на header

---

## Референсы стиля

- **TradingView** — crosshair, candlestick, tooltips
- **Revolut / Monzo** — карточки метрик, animated numbers
- **GitHub Mobile** — тёмная тема `#0D1117` (уже близко к нашей)
- **CoinGecko** — списки крипто с sparkline

---

*Обновлено: июнь 2026 (v1.0.3)*
