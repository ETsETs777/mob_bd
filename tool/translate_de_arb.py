#!/usr/bin/env python3
"""Generate lib/l10n/app_de.arb from app_en.arb (batch German translation)."""

from __future__ import annotations

import json
import re
import sys
import time
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("Install: pip install deep-translator", file=sys.stderr)
    sys.exit(1)

ROOT = Path(__file__).resolve().parent.parent
EN_PATH = ROOT / "lib" / "l10n" / "app_en.arb"
DE_PATH = ROOT / "lib" / "l10n" / "app_de.arb"
BATCH = 40

PROTECTED = [
    "EcoPulse", "MOEX", "NYSE/NASDAQ", "NYSE", "NASDAQ", "Binance", "Gemini",
    "CoinGecko", "Finnhub", "Frankfurter", "Supabase", "Google", "Android",
    "Telegram", "GitHub", "T-Bank", "T-Invest", "BTC", "ETH", "USD", "EUR",
    "RUB", "IMOEX", "OFZ", "NDFL", "IIS", "CBR", "CPI", "FCM", "LAN", "JSON",
    "CSV", "PDF", "API", "UUID", "Wi-Fi", "Face ID", "Material 3", "fl_chart",
    "flutter_animate", "Pearson", "SBER", "AAPL", "Brent", "WTI", "F&G", "Pro",
    "Admin", "WebSocket", "OLED", "MA(7)", "MA(25)", "MA(99)", "YTM", "P&L",
    "P/L", "LIVE", "₽", "×", "pp.", "σ", "Δ", "4×1", "2×2", "EUR/RUB", "USD/RUB",
    "test2", "ipconfig", "tbank.ru", "100 USD", "30 days", "30d", "90 days",
    "15 min", "4 digits", "192.168.",
]

PLACEHOLDER_RE = re.compile(
    r"(\{[^{}]+\}|\{[^{}]+,\s*plural,\s*[^{}]+\})"
)


def protect(text: str) -> tuple[str, list[str]]:
    tokens: list[str] = []

    def ph_repl(m: re.Match[str]) -> str:
        tokens.append(m.group(0))
        return f"__PH{len(tokens) - 1}__"

    out = PLACEHOLDER_RE.sub(ph_repl, text)
    for term in sorted(PROTECTED, key=len, reverse=True):
        if term in out:
            tokens.append(term)
            out = out.replace(term, f"__PH{len(tokens) - 1}__")
    return out, tokens


def restore(text: str, tokens: list[str]) -> str:
    for i, token in enumerate(tokens):
        text = text.replace(f"__PH{i}__", token)
    return text


def main() -> None:
    en: dict = json.loads(EN_PATH.read_text(encoding="utf-8"))
    de: dict = {"@@locale": "de"}
    translator = GoogleTranslator(source="en", target="de")

    keys = [k for k in en if not k.startswith("@") and k != "@@locale"]
    strings = [en[k] for k in keys if isinstance(en[k], str)]
    protected_map: dict[str, tuple[str, list[str]]] = {}
    protected_list: list[str] = []

    for s in strings:
        p, tokens = protect(s)
        protected_map[s] = (p, tokens)
        protected_list.append(p)

    print(f"Translating {len(strings)} strings in batches of {BATCH}…", flush=True)
    translated_protected: list[str] = []
    for start in range(0, len(protected_list), BATCH):
        batch = protected_list[start : start + BATCH]
        try:
            batch_out = translator.translate_batch(batch)
        except Exception as exc:  # noqa: BLE001
            print(f"  batch {start} failed ({exc}), falling back one-by-one", flush=True)
            batch_out = []
            for item in batch:
                try:
                    batch_out.append(translator.translate(item))
                except Exception:
                    batch_out.append(item)
                time.sleep(0.05)
        translated_protected.extend(batch_out)
        print(f"  {min(start + BATCH, len(strings))}/{len(strings)}", flush=True)
        time.sleep(0.2)

    lookup: dict[str, str] = {}
    for original, protected in zip(strings, translated_protected):
        _, tokens = protected_map[original]
        lookup[original] = restore(protected, tokens)

    for key in keys:
        value = en[key]
        if isinstance(value, str):
            de[key] = lookup.get(value, value)
            meta_key = f"@{key}"
            if meta_key in en:
                de[meta_key] = en[meta_key]
        else:
            de[key] = value

    DE_PATH.write_text(
        json.dumps(de, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {DE_PATH}", flush=True)


if __name__ == "__main__":
    main()
