# Changelog

All notable changes to EcoPulse are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.55] - 2026-06-28

### Added
- Preset marketplace in customization hub (featured built-in profiles)
- Share preset links (`https://ecopulse.app/preset` + `ecopulse://preset`) via `PresetShareLink`
- Deep link import with `app_links` and Android intent filters
- Lazy-load older candles on asset chart pan (`onLoadMoreCandles`, MOEX/Finnhub)

### Changed
- Project structure: `lib/shared/` for cross-feature widgets (stubs in `features/shared/`)
- Settings panels moved to `features/settings/panels/`
- 12 missing provider root stubs added
- Tests: `hub_screens_test` → `features/shell/`, `moving_average_test` → `core/utils/`
- Docs: `docs/project-structure.md`, updated `providers/README.md`, `test/README.md`
- App version 1.0.55+55

## [1.0.54] - 2026-06-28

### Added
- A/B theme preview in customization hub: current vs built-in preset side-by-side
- `AppearancePaletteResolver` for offline palette resolution
- Mini mock UI (metrics, chart, nav) per theme; one-tap apply comparison theme
- Embedded A/B preview in Appearance customization section

### Changed
- App version 1.0.54+54

## [1.0.53] - 2026-06-28

### Added
- Android home widget preview in customization hub (compact 4×1 / expanded 2×2)
- Live slot data from market providers; auto-layout toggle in preview
- Widget preview embedded in Widgets customization section

### Changed
- App version 1.0.53+53

## [1.0.52] - 2026-06-28

### Added
- Customization live preview 2.0: swipe carousel (chart, home, markets, portfolio, navigation)
- Page indicator and per-screen mock previews in customization hub

### Changed
- App version 1.0.52+52

## [1.0.51] - 2026-06-28

### Added
- Robo-advisor lite: allocation preset recommendation
- Factors: account type (IIS/crypto/USD), savings goals, Fear & Greed
- Priority rebalance actions and one-tap apply preset
- `PortfolioRoboAdvisorCard` on portfolio screen

### Changed
- App version 1.0.51+51

## [1.0.50] - 2026-06-28

### Added
- Simplified local tax report (NDFL estimate from trade journal)
- `PortfolioTaxReportCard` on portfolio screen with year selector
- Full tax report screen with CSV export
- IIS account note (Type A/B disclaimer)
- Passive income tax estimate from income calendar

### Changed
- App version 1.0.50+50

## [1.0.49] - 2026-06-28

### Added
- Real-time portfolio value ticker (Binance WS for crypto holdings)
- `PortfolioValueTicker` widget with LIVE badge and price flash
- `livePortfolioSnapshotProvider` merges live crypto into portfolio total
- Auto-refresh stocks/bonds every 45s on portfolio screen
- WebSocket subscribes to crypto symbols held in paper portfolio

### Changed
- App version 1.0.49+49

## [1.0.48] - 2026-06-28

### Added
- T-Bank (Tinkoff Invest) read-only broker integration
- `TinkoffBrokerClient`: GetAccounts + GetPortfolio
- Broker portfolio card on paper portfolio screen
- T-Invest API token in Settings → API & data
- Sandbox mode via `--dart-define=BROKER_SANDBOX=true`
- Docs: `docs/BROKER_SETUP.md`
- Tests for Tinkoff quotation and portfolio parsing
- CSV trade journal import (EcoPulse export + generic broker format)
- Import button on trade journal screen

### Changed
- App version 1.0.48+48

## [1.0.47] - 2026-06-28

### Added
- Live crypto prices via Binance WebSocket (`miniTicker`) with LIVE badge on Markets
- `FeatureFlag.liveCryptoWebSocket`, `cryptoWithLiveProvider`
- EcoPulse Pro foundation: free limit 5 alerts, Pro screen, admin dev unlock
- Admin dashboard user metrics (watchlist, alerts, chats, positions)
- iOS platform scaffold (`flutter create --platforms=ios`)
- Docs: `LIVE_DATA.md`, `IOS_TESTFLIGHT.md`

### Changed
- App version 1.0.47+47

## [1.0.46] - 2026-06-28

### Added
- Chat push notifications: FCM (optional dart-define) + 15-min background polling fallback
- `PUT/DELETE /v1/profile/push-token` client for home server FCM registration
- Message push toggle on Profile → Notifications
- EcoPulse Cloud (Supabase): email/Google auth, profile + watchlist sync
- Tablet layout: NavigationRail, markets master-detail with embedded chart
- Play Store listing (RU + EN): `docs/PLAY_STORE_LISTING.md`, `store/metadata/`
- Setup guides: `docs/FCM_SETUP.md`, `docs/SUPABASE_SETUP.md`, `docs/PLAY_STORE_RELEASE.md`
- GitHub Release workflow now attaches AAB for Play Store

### Changed
- App version 1.0.46+46

## [1.0.45] - 2026-06-28

### Added
- Customization server sync panel (push/pull/smart sync via home server LAN API)
- Customization hub + section sub-screens; settings hub + 9 group sub-screens
- Moving average overlays MA(7), MA(25), MA(99) on line and candlestick charts
- Fullscreen landscape chart mode on asset detail screen
- Multiple paper portfolio accounts (Main, IIS, USD, Crypto) with account switcher
- Savings goals with progress bar and deadline on portfolio screen
- Widget tests: ProfileHub, CustomChartView, customization/settings hubs
- Integration test: onboarding → home → markets → asset detail
- GitHub Actions release workflow (APK on git tag `v*`)
- `CHANGELOG.md` for release notes

### Changed
- `HomeServerClient`: GET/PUT `/v1/profile/customization` endpoints
- Chart customization: toggles for volume, pan/zoom, MA periods
- App version 1.0.45+45

## [1.0.44] - 2026-06-28

### Added
- Sber-style profile hub (tab, accounts carousel, security/documents/notifications/server screens)
- Exchange-grade candlestick charts (`candlesticks`: zoom, pan, volume, OHLC)
- Line chart improvements: price axis right, pan/zoom, price header
- Chart customization: bull/bear colors, volume, pan/zoom toggles
- Providers reorganized by domain with re-export stubs
- Tests reorganized under `test/app`, `test/core`, `test/features`, `test/data`

### Removed
- One-off migration scripts from `tool/`
- APK binaries from git tracking (`.gitignore` updated)

## [1.0.43] and earlier

See git history and [docs/FULL_IMPROVEMENT.md](docs/FULL_IMPROVEMENT.md) for the full roadmap.
