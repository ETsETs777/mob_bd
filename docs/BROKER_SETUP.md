# Broker read-only integration (T-Bank / Tinkoff Invest)

EcoPulse can display a **read-only** snapshot of your real broker portfolio next to the paper portfolio. The app never places orders or transfers funds.

## Supported broker

| Broker | API | Status |
|--------|-----|--------|
| T-Bank (Tinkoff Invest) | [T-Invest Open API](https://developer.tbank.ru/invest/intro/intro) | ✅ read-only |

BCS, Finam, and others are planned.

## 1. Get a read-only token

1. Open [T-Bank Invest settings → API](https://www.tbank.ru/invest/settings/)
2. Issue a token with **read-only** scope (portfolio view)
3. For testing, use the **sandbox** token from the developer portal

## 2. Add token in EcoPulse

**Settings → API & data → T-Invest API token**

Or build with compile-time define:

```bash
flutter run --dart-define=TINKOFF_BROKER_TOKEN=your_token_here
```

Sandbox mode:

```bash
flutter run --dart-define=BROKER_SANDBOX=true --dart-define=TINKOFF_BROKER_TOKEN=...
```

## 3. View portfolio

**Portfolio screen → T-Bank · read-only** card

- Select broker account (if several)
- Tap refresh to sync positions and total value
- Positions show ticker, quantity, market value in ₽

## API endpoints used

| Method | Purpose |
|--------|---------|
| `UsersService/GetAccounts` | List accounts |
| `OperationsService/GetPortfolio` | Positions + total |

Base URL:

- Production: `https://invest-public-api.tinkoff.ru/rest/`
- Sandbox: `https://sandbox-invest-public-api.tinkoff.ru/rest/`

## Security

- Token stored locally in Hive (same as other API keys)
- **Not** included in backup export
- Never log token in HTTP verbose mode in production builds
- Use read-only tokens only

## Troubleshooting

| Error | Fix |
|-------|-----|
| `no_token` | Add token in Settings |
| `no_accounts` | Check token scope / sandbox account |
| 401 / Unauthenticated | Regenerate token |
| Empty positions | Account may hold only cash |

## Roadmap

- Import broker positions into paper portfolio for comparison
- Multi-broker abstraction (BCS, Finam)
- OAuth broker login (no manual token)
