# AI-ассистент

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/features/assistant/assistant_fab.dart`
- `lib/features/assistant/assistant_sheet.dart`
- `lib/core/services/assistant/intent_router.dart`
- `lib/core/services/assistant/local_responder.dart`
- `lib/core/services/assistant/assistant_service.dart`
- `lib/core/services/assistant/gemini_client.dart`

## Поток сообщения

```
User text/voice
    ↓
IntentRouter.route(text) → AssistantIntent
    ↓
LocalResponder (offline команды)
    или
AssistantService → GeminiClient (если ключ Gemini)
    ↓
AssistantAction? → navigate / refresh / open course
```

## Локальные интенты (без AI)

| Intent | Пример |
|--------|--------|
| `priceQuery` | «курс доллара» |
| `navigate` | «открой инфляцию» |
| `brief` | «сводка» |
| `portfolio` | «мой портфель» |
| `setAlert` | «алерт usd выше 100» |
| `refresh` | «обнови данные» |
| `explain` | FAQ → открыть главу курса |

Тесты: `test/assistant_intent_router_test.dart`, `test/assistant_local_responder_test.dart`.

## Контекст для Gemini

`AssistantContext` собирает snapshot: курсы, IMOEX, BTC, инфляция, ставка.

## Голос

- `speech_to_text` — ввод
- `flutter_tts` — озвучка ответа (опционально)

## FAQ

Статический контент: `faq_content.dart` + маппинг на курсы через `course_chapter_map.dart`.
