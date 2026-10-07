# AGENTS.md

Guidance for AI Agents when working in this repository.

## Overview

**use_me** is a Flutter boilerplate with a coffee-themed flavor setup. New apps start from it by running `./setup.sh`, which renames the Dart package, bundle IDs, and app names, then regenerates native flavor config and code. Three flavors map to environments: **latte** = dev, **macchiato** = staging, **espresso** = production. Each has its own entry point (`lib/main_*.dart`), package ID suffix, and app name suffix.

Features: `auth` (demo login and logout against `reqres.in`) and `home` (tab shell). Both are examples to replace, not product code.

Keep the template generic. Anything specific to one app belongs in that app's repo, not here.

## Toolchain

Flutter is pinned to **3.47.0** (Dart 3.13) via FVM (`.fvmrc`). Always prefix with `fvm` so you match the pinned SDK.

If the Dart MCP server (`dart-mcp-server`) is available, prefer its tools (`analyze_files`, `dart_format`, `dart_fix`, `list_devices`, `hot_reload`, `hot_restart`) over the CLI. The commands below are the fallback.

Freezed is **4.x**. Data classes are `abstract class X with _$X`, unions are `sealed class X with _$X`. An `analyzer: ^14` override in `pubspec.yaml` keeps codegen working on Dart 3.13; don't drop it without checking `build_runner` still runs.

## Commands

Recipes live in the `justfile`. Run `just` to list them. Extra args pass through.

```bash
just latte        # dev
just macchiato    # staging
just espresso     # production
just latte -d macOS --release
```

Underlying form: `fvm flutter run --flavor latte -t lib/main_latte.dart --dart-define-from-file=.env.latte.json`

Codegen (Freezed, json_serializable, Mockito). Generated files are git-ignored, so run it on a fresh clone **before** `analyze` will be clean, and after touching any source that generates `*.freezed.dart` / `*.g.dart` / `*.mocks.dart`:

```bash
fvm dart run build_runner build   # or: just build / just watch
```

`build.yaml` limits each builder by filename suffix (`*_bloc.dart`, `*_cubit.dart`, `*_dto.dart`, `*_entity.dart`, anything in `lib/core/`). A Freezed class in a file outside those patterns won't generate until its glob is added there.

Analyze / test:

```bash
fvm flutter analyze
fvm flutter test                              # all
fvm flutter test test/core/                   # core only
fvm flutter test test/path/to/foo_test.dart   # single file
just coverage                                 # lcov + HTML report
```

App icons (sources in `assets/icons/ic_<flavor>.png`, 1024x1024):

```bash
just icons
```

## Configuration

Environment values are **compile-time** via `--dart-define-from-file=.env.<flavor>.json`. These JSON files are git-ignored; each has a committed `.env.<flavor>.json.example` to copy from. They're read in `lib/flavors.dart` through `Environment` (`String.fromEnvironment`): `APP_NAME`, `API_KEY`, `API_BASE_URL`. `API_BASE_URL` becomes the Dio `baseUrl`, and a non-empty `API_KEY` is sent as the `x-api-key` header.

If a `.env.<flavor>.json` is missing, **ask**. Don't invent values or stub the file.

Native secrets are injected separately: Android via `resValue` in `android/app/flavorizr.gradle.kts`, iOS via `ios/Flutter/*.xcconfig`. `flavorizr.yaml` is the source of truth for native flavor config; regenerating it overwrites Android/iOS flavor scaffolding. `setup.sh` runs flavorizr with a limited processor list so it doesn't overwrite `lib/`; keep that list in sync if you change it.

## Architecture

Feature-first Clean Architecture. Each feature under `lib/features/<name>/` has `data/` (dto, datasource, mapper, repository impl), `domain/` (entities, usecases, repository interface), `presentation/` (bloc/cubit + pages). `lib/core/` holds shared infrastructure, including reusable widgets in `lib/core/presentation/widgets/`. Barrel files (`<name>.dart`, `data.dart`, etc.) re-export each layer. Import the barrel, not individual files.

When a page has many private widgets, split them into a `<page>.component.dart` `part` file (see `login_page.component.dart`).

**Dependency injection**: `get_it` (`di` in `lib/injections.dart`). Each feature/layer exposes a `mixin class XModule` with `static Future<void> register(GetIt sl)`. `configureDependencies()` calls `CoreModule` → `AppModule` → feature modules in order. Wire new dependencies inside the relevant module's `register`, not globally.

**Networking**: `Dio` wrapped by `Client`/`ClientImpl`, with `getParsed`/`postParsed`/`putParsed`/`patchParsed`/`deleteParsed` and `*Safe` variants in `client_parser.dart`. Two `Dio` instances are registered: a bare one named `'interceptor'` (used inside the interceptor to avoid recursion) and the main one with `TalkerDioLogger` + `ClientInterceptor` + `DioCacheInterceptor`. `ClientInterceptor` (`lib/core/data/client_interceptor.dart`) sets headers and handles **401 token refresh with a retry queue**: concurrent 401s queue while one refresh runs, then replay. Status-to-exception mapping (`BadRequestException`, `ConflictException`, etc.) lives in the `DioExceptionX` extension in `lib/core/data/dio_errors.dart`. The HTTP cache is encrypted at rest (AES via `encrypt`, key from `StoreKey`, Hive store) and keyed per account by `cacheKeyBuilder` in `core.dart`.

**Error handling**: functional, via `dartz` `Either<Failure, T>`. Datasources/repositories wrap calls in `safeCall` (`lib/core/domain/safe_call.dart`), which converts typed exceptions → `Failure` variants (Freezed sealed union in `lib/core/domain/failures.dart`) and logs each one as a `FailureLog`. Repositories return `Either`; never let a raw `DioException` escape the data layer. Use cases can extend `Usecase<T, P>` / `UsecaseNoParams<T>` from `lib/core/domain/usecase.dart`.

**State**: `flutter_bloc`. `LoginBloc` (event-driven) for auth; cubits (`AppCubit`, `HomeCubit`) for simpler state. States/events are Freezed unions. `AsyncState<T>` in `lib/core/presentation/state/` covers plain load/success/failure screens. `Bloc.observer` is `AppBlocObserver`.

**Auth flow**: `AppCubit` is a lazy singleton that reads `access_token` on start. The router listens to it, so login and logout only change cubit state (`loggedIn()`, `logout()`); never navigate to or from login by hand. Tokens are stored under `access_token` and `refresh_token`.

**Routing**: `go_router` behind an `AppNavigator` wrapper (`lib/core/presentation/router/`). The top-level `router` redirects on `AppCubit` state: loading → splash, signed out → login, signed in on a public route → home. Add routes reachable without auth to `_publicRoutes`. Use `AppNavigator`'s `goToX` helpers and `AppPages` constants rather than raw route strings. Route table and transitions are `part` files of `app_navigator.dart`.

**Logging**: `talker` via the global `talker` instance (`AppLogging`), with `talker_dio_logger`, `talker_bloc_logger`, and `TalkerRouteObserver`. Latte and macchiato log, espresso doesn't. Debug builds show a floating button (`TalkerOverlay`) that opens the log screen. Never `print`, never raw `dart:developer` `log()`.

**Forms**: `formz` inputs under `lib/core/presentation/form_sanitation/` (email, password, name, phone, pin).

## Testing

`bloc_test`'s `blocTest` for bloc/cubit state-machine verification. `mockito` mocks are generated into `test/helper/mocks.mocks.dart`; regenerate via build_runner after editing `test/helper/mocks.dart`. Datasource tests mock the HTTP `Client`; repository tests mock datasource + `LocalStorageManager`. `lib/core/` is kept at ~full coverage; keep new core code tested.

## Code style

`analysis_options.yaml` is the authority on lints. The rules here are the things it can't enforce.

- **Naming:** `PascalCase` types, `camelCase` members, `snake_case` files.
- **Null safety:** avoid `!`. Prefer `?` and flow analysis (`if (x != null)`). Reach for it only when the alternative is genuinely worse.
- **Async:** `async`/`await` for futures. Catch unexpected errors and route them into a Freezed failure variant.
- **Length:** keep functions short. `build` methods are the exception. Don't shred one into `_buildFoo()` helpers just to hit a number; extract a `class _MySubWidget extends StatelessWidget` instead.
- **Widgets:** prefer `StatelessWidget` and `const` constructors. Keep `build` pure and fast: no side effects, no network calls.
- **Lists:** `ListView.builder` or `SliverList`.
- **Isolates:** `compute()` or `IsolateParser` for heavy work like large JSON parsing, before handing data up the layers.
- **Types:** Dart's type system is worth leaning on. Use it.
- **Comments:** no `///` doc comments. Write a `//` comment only when the reason behind the code isn't obvious from reading it.

## Working guidelines

Adapted from [Karpathy's notes on LLM coding pitfalls](https://x.com/karpathy/status/2015883857489522876). Bias toward caution over speed; use judgment on trivial tasks.

- **Think before coding.** State assumptions explicitly; if uncertain, ask. Surface multiple interpretations and their tradeoffs instead of silently picking one. Push back when a simpler approach exists, and propose bold ideas when they'd meaningfully help.
- **Simplicity first.** Minimum code that solves the problem: no speculative features, single-use abstractions, unrequested configurability, or handling for impossible cases. If 200 lines could be 50, rewrite it. Would a senior engineer call this overcomplicated?
- **Surgical changes.** Touch only what the request requires. Don't refactor, reformat, or "improve" adjacent code; match existing style even if you'd do it differently. Mention unrelated dead code rather than deleting it. Remove only the orphans your own changes created. Every changed line should trace to the request. Be careful with destructive actions nobody asked for.
- **Goal-driven execution.** Turn tasks into verifiable goals. "Fix the bug" becomes "write a failing test that reproduces it, then make it pass". For multi-step work state a brief plan with a verification check per step, then loop until each is verified.

## Questions are read-only

A question asks for an answer, not for changes. If a message opens with "how hard would it be", "is it possible", "can X do Y", or otherwise asks rather than instructs, answer it and don't edit files.

If the answer is obvious and the change is trivial, still answer first and offer. Ask before making it.

## Match ceremony to the task

Don't spawn subagents or a multi-agent panel for work a single agent finishes in one pass. Delegation is for breadth or adversarial review, not ordinary tasks.

When several agents work in parallel, state file ownership upfront so they don't collide.

## Workspace

- Analyze: `fvm flutter analyze` reports `No issues found!`
- Test: `fvm flutter test <test files for the change>`, then `fvm flutter test` before reporting done.
- Generate: `fvm dart run build_runner build` after touching Freezed or json_serializable sources, or `test/helper/mocks.dart`. Never hand-edit `*.freezed.dart`, `*.g.dart`, `*.mocks.dart`.
