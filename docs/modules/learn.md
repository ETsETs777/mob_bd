# Обучение (курсы)

> Автор: Цымбал Е. В. · апрель–июнь 2026

## Файлы

- `lib/core/content/investor_basics_course.dart` — метаданные курса
- `lib/core/content/course_registry.dart` — реестр всех курсов
- `lib/core/content/courses/investor_basics/` — главы RU/EN
- `lib/features/learn/course_library_screen.dart`
- `lib/features/learn/course_reader_shell.dart`
- `lib/features/learn/course_quiz_screen.dart`

## Курс «Основы инвестора»

5 частей (RU): `ru_part1.dart` … `ru_part5.dart`  
EN: `en_all.dart`

Каждая глава — список `CourseBlock` (text, tip, quote, chart placeholder…).

## Прогресс

- `course_progress_provider` — Hive: прочитанные главы, quiz scores
- `course_reader_prefs_provider` — шрифт, размер текста

## Quiz

В конце частей — `quizzes.dart` → `CourseQuizScreen`.

## Интеграция с ассистентом

«Объясни инфляцию» → `course_chapter_map.dart` → открыть нужную главу.

## UI

- `CourseHomeCard` на главной — % прогресса
- `CourseReaderShell` — AppBar, prev/next, bookmark
