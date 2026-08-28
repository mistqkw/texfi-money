# TexFi m0ney

Личный финансовый трекер для Android. Часть экосистемы **TexFi** (TexFi Files, Tekstik, TeFblock, Ari).

## Стек

- **Flutter** (Android, min SDK 24)
- **State management:** [Riverpod](https://riverpod.dev) — минимум boilerplate, providers легко тестировать изолированно, хорошо сочетается с потоковыми запросами Drift (`StreamProvider` на `watch()`-запросы БД без ручной подписки/отписки).
- **Локальное хранилище:** [Drift](https://drift.simonbinder.eu) (SQLite) — полноценный SQL с миграциями и join-запросами, что нужно для агрегаций бюджетов/статистики. Слой репозиториев абстрагирован через `domain/repositories`, поэтому синхронизацию с сервером можно будет добавить позже без переписывания UI.
- **Графики:** fl_chart
- **Архитектура:** Clean Architecture — `data/` (Drift, репозитории) → `domain/` (сущности, интерфейсы репозиториев) → `presentation/` (экраны, Riverpod providers).

## Структура

```
lib/
  core/            тема, константы, утилиты
  data/
    local/         Drift database, DAO
    repositories/  реализации репозиториев поверх Drift
  domain/
    entities/      доменные модели
    repositories/  абстрактные интерфейсы репозиториев
  presentation/
    home/
    add_transaction/
    categories/
    budgets/
    goals/
    statistics/
    history/
    shared/
```

## Дизайн

Тёмная тема по умолчанию, плоский минимализм, акцент `#4a7dfb` на фоне `#0d0d10`. Подробности — `lib/core/theme`.
