# Play Store listing — EcoPulse

Store-ready copy in **English** and **Russian**. Use as-is in Google Play Console or with Fastlane `supply`.

Package: `com.ecopulse.ecopulse`  
Category: **Finance**  
Content rating: Everyone (no real-money trading)

---

## English (en-US)

### App name (30 chars max)

`EcoPulse`

### Short description (80 chars max)

Personal finance dashboard: markets, inflation, portfolio & economic radar.

### Full description (4000 chars max)

EcoPulse is your personal economic dashboard for tracking markets, currencies, inflation, and a paper portfolio — all in one calm, customizable app.

**Markets & charts**
- Crypto, Russian and US stocks, OFZ and corporate bonds
- Line and candlestick charts with moving averages (MA 7/25/99)
- Watchlist, sector heatmap, bond yield curve and calendar
- Fullscreen chart mode on tablets

**Home & macro**
- USD/RUB and key rates at a glance
- Inflation tracker and economic radar
- Morning digest push with market brief
- News and macro calendar

**Portfolio**
- Paper trading with multiple accounts (Main, IIS, USD, Crypto)
- Trade journal, rebalance plan, savings goals
- Dividend and coupon reminders

**Profile & sync**
- PIN / biometrics, backup & restore
- Home server for LAN chats and profile sync
- Optional Supabase cloud for profile + watchlist
- Customization hub: themes, charts, navigation

**Assistant**
- Built-in FAQ and Gemini-powered answers
- Voice input and text-to-speech

EcoPulse does not execute real trades. Data comes from public sources (MOEX ISS, CoinGecko, Finnhub, Frankfurter). Not investment advice.

### What's New (example for 1.0.46)

- Chat push notifications (FCM + background polling)
- EcoPulse Cloud (Supabase) sync
- Tablet master-detail layout for markets
- Multiple portfolio accounts and savings goals

---

## Russian (ru-RU)

### Название приложения

`EcoPulse`

### Краткое описание

Личный финансовый дашборд: рынки, инфляция, портфель и экономический радар.

### Полное описание

EcoPulse — персональный экономический дашборд: рынки, валюты, инфляция и бумажный портфель в одном спокойном приложении с глубокой кастомизацией.

**Рынки и графики**
- Крипто, акции РФ и США, ОФЗ и корпоративные облигации
- Линейные и свечные графики с MA(7/25/99)
- Watchlist, heatmap секторов, кривая доходности ОФZ
- Полноэкранный график; на планшете — список + детали

**Главная и макро**
- USD/RUB и ключевые ставки
- Инфляция и экономический радар
- Утренний push-дайджест
- Новости и macro-календарь

**Портфель**
- Бумажная торговля: несколько счетов (основной, ИИС, USD, crypto)
- Журнал сделок, план ребаланса, цели накопления

**Профиль и синхронизация**
- PIN / биометрия, бэкап
- Домашний сервер: чаты и sync в LAN
- EcoPulse Cloud (Supabase) — профиль и watchlist
- Хаб кастомизации: тема, графики, навигация

**Ассистент**
- FAQ и ответы Gemini, голосовой ввод

EcoPulse не совершает реальные сделки. Данные из открытых источников. Не является инвестиционной рекомендацией.

---

## Graphics checklist

| Asset | Size | Notes |
|-------|------|-------|
| App icon | 512×512 PNG | Use `assets/icon/app_icon.png` upscaled |
| Feature graphic | 1024×500 | Dashboard + chart screenshot composite |
| Phone screenshots | 1080×1920 min 2 | Home, Markets chart, Portfolio |
| 7-inch tablet | 1200×1920 optional | Master-detail markets |
| Promo video | optional | 30s demo |

---

## Keywords (internal / ASO)

EN: stocks, bonds, crypto, portfolio, inflation, ruble, MOEX, finance dashboard  
RU: акции, облигации, крипто, портфель, инфляция, рубль, MOEX, финансы

---

## Privacy & data safety (summary for Console)

- Data collected locally: profile, watchlist, portfolio, settings
- Optional cloud: email (Supabase auth), sync payload
- Optional home server: login, messages (LAN)
- No sale of personal data; user can export/delete via backup

See in-app backup and `docs/SUPABASE_SETUP.md` for cloud details.
