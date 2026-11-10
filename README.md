# PandaBudget

Personal finance for a single household. Built with Flutter for Android,
Windows and Linux. All data stays in a local SQLite database on the device.

PandaBudget covers two workflows:

- **Plan ahead.** Enter regular and one-time income and payments, budgets
  and savings goals. The forecast shows what every coming month costs, how
  much can be saved, what that adds up to per year, and whether each
  savings goal is reachable in time.
- **Look back.** Keep several accounts, enter transactions by hand or
  import CSV/JSON exports from any bank, search them, and see where the
  money went per category and which budgets were overspent.

## Features

| Area | What it does |
|---|---|
| Forecast | 24 months ahead: income, fixed payments, budgets, savings potential per month and per year. Holds money back for expensive months (yearly insurance) before it is assigned to goals. |
| Savings goals | Needed monthly rate, priority order, "on track / behind" with the month a late goal becomes reachable. |
| Import | Any CSV or JSON layout. Columns are mapped once per bank and saved as a *bank format*; the next file from that bank is recognised by its header. Detects delimiter, encoding (UTF-8 / Windows-1252), date and number format, skips account summary lines, and never imports the same row twice. Imports can be undone. |
| Categorisation | 1. Your rules, in order. 2. If none matches, a classifier that learns incrementally from every category you set. 3. Otherwise the transaction stays open, and you can always change the category by hand. |
| Analysis | Spending and income by category and sub-category, budget usage, 12 month trend. |
| App | English and German, light and dark theme, phone and desktop layouts. |

## Getting started

Requires [Flutter](https://docs.flutter.dev/get-started/install) 3.47 or
newer (Dart 3.13).

```bash
flutter pub get
```

```bash
flutter run -d linux
```

Use `-d windows` or an Android device id instead of `linux` as needed.
Building for Linux needs `clang cmake ninja-build pkg-config libgtk-3-dev`.

## Project layout

```
lib/
  app/        app widget, router, adaptive navigation shell
  core/       theme, money and date helpers, shared widgets, l10n helpers
  database/   Drift tables, database class, seed data, file connection
  features/<feature>/
    domain/        entities, repository interfaces, pure logic
    application/   services that combine repositories (import, categorise)
    data/          Drift implementations of the repositories
    presentation/  screens, widgets, Riverpod providers
  l10n/       translations (ARB) and generated localisation classes
drift_schemas/     snapshot of every released database schema version
test/              unit, database, migration, widget and golden tests
integration_test/  end-to-end test on a real device/desktop build
tool/              scripts for translations and launcher icons
```

`domain/` has no Flutter or database imports, so the finance logic
(recurrence, forecast, goal planner, import parsing, rules, classifier,
analysis) is plain Dart and tested without any setup.

State management is [Riverpod](https://riverpod.dev); navigation is
[go_router](https://pub.dev/packages/go_router); persistence is
[Drift](https://drift.simonbinder.eu). Amounts are stored as integers in
minor units (cents), dates as `yyyymmdd` integers.

## Tests

```bash
flutter test
```

| Kind | Where | Notes |
|---|---|---|
| Unit | `test/core`, `test/features` | Pure logic, including bank file fixtures in `test/fixtures`. |
| Database | `test/database` | Repositories on an in-memory SQLite database. |
| Migration | `test/drift` | Every schema snapshot must migrate to the current schema. |
| App flows | `test/app` | The whole app on an in-memory database: import, categorise, forms. Use `appTest` and `pumpApp` from `test/helpers/pump_app.dart`. |
| Golden | `test/goldens` | Screenshots of the main screens with demo data (Linux only). Refresh after intended visual changes with the command below. |
| Integration | `integration_test` | `flutter test integration_test -d linux` |

```bash
flutter test --update-goldens --tags golden
```

CI (`.github/workflows/ci.yml`) checks formatting, generated code,
analysis and tests, then builds Linux, Android and Windows and uploads the
builds as artifacts.

## Changing things

- **Database schema:** see [docs/database-migrations.md](docs/database-migrations.md).
- **Texts:** edit the table in `tool/gen_arb.py` (English and German side
  by side), then regenerate:

  ```bash
  python3 tool/gen_arb.py && flutter gen-l10n
  ```

- **Generated code** (Drift) after changing tables or queries:

  ```bash
  dart run build_runner build
  ```
