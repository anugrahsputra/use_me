# Flutter Flavors Boilerplate v2

A professional, production-ready Flutter boilerplate with a coffee-themed flavor architecture. Designed for speed, scalability, and ease of branding.

## Quick Start (Setup New Project)

This boilerplate includes a specialized setup script that uses the [`change_project_name`](https://pub.dev/packages/change_project_name) package to rename the project, package identifiers, and app names across all flavors in one go.

```bash
chmod +x setup.sh
./setup.sh
```

The script will prompt you for:
1. **Base Package Name** (e.g., `com.yourdomain.app`)
2. **Base App Name** (e.g., `My Awesome App`)
3. **Dart Project Name** (e.g., `awesome_app`)

---

## Flavor Architecture

We use 3 distinct flavors to manage the application lifecycle:

| Flavor | Environment | Target File | Package ID Suffix | App Name Suffix |
| :--- | :--- | :--- | :--- | :--- |
| **Latte** | Development | `lib/main_latte.dart` | `.latte` | `Latte` |
| **Macchiato** | Staging | `lib/main_macchiato.dart` | `.macchiato` | `Macchiato` |
| **Espresso** | Production | `lib/main_espresso.dart` | *(none)* | *(none)* |

### Running the App

Recipes live in the `justfile` ([just](https://github.com/casey/just)). Run `just` to list them all.

```bash
just latte        # dev
just macchiato    # staging
just espresso     # production

# Extra args pass through, e.g.:
just latte -d macOS --release
```

Underlying form:
```bash
fvm flutter run --flavor latte -t lib/main_latte.dart --dart-define-from-file=.env.latte.json
```

Flutter is pinned to **3.47.0** via FVM (`.fvmrc`). Prefer `fvm flutter` / `fvm dart`.

**VS Code:**
Open the `Run & Debug` panel and select either **Latte**, **Macchiato**, or **Espresso**.

---

## Configuration Management

### 1. Environment Variables (.env)
Managed via Flutter's native `--dart-define-from-file` flag. Each flavor loads its own compile-time configuration:
*   `.env.latte.json`
*   `.env.macchiato.json`
*   `.env.espresso.json`

*Note: These files are excluded from git via `.gitignore`.*

`lib/flavors.dart` reads `APP_NAME`, `API_KEY`, and `API_BASE_URL` through `String.fromEnvironment`. `API_BASE_URL` becomes the Dio `baseUrl`, and a non-empty `API_KEY` goes out as the `x-api-key` header.

### 2. Native API Keys
Injected at compile-time to avoid hardcoding secrets in manifests:
*   **Android:** Configured in `android/app/flavorizr.gradle.kts` via `resValue`.
*   **iOS:** Configured in `ios/Flutter/*.xcconfig` files.

---

## Codegen

Generated files (`*.freezed.dart`, `*.g.dart`, `*.mocks.dart`) are git-ignored. `setup.sh` generates them once; after that, rerun whenever a Freezed, JSON, or mock source changes:

```bash
just build    # one-off
just watch    # rebuild on save
```

`build.yaml` limits each builder to the files that use it, by filename suffix (`*_bloc.dart`, `*_cubit.dart`, `*_dto.dart`, `*_entity.dart`, anything in `lib/core/`). A Freezed class in a file outside those patterns will not generate until you add its glob there.

---

## Debug logs

All logging goes through one `talker` instance (`lib/core/utils/app_logging.dart`). Latte and Macchiato log, Espresso does not. Debug builds show a floating bug button that opens the Talker log screen with every request, response, bloc event, and `Failure`.

---

## Branding & Icons

App icons are generated automatically using `flutter_flavorizr`.

1. Place your 1024x1024 source icons in `assets/icons/`:
   * `icon_latte.png`
   * `icon_macchiato.png`
   * `icon_espresso.png`
2. Run the icon generator:
   ```bash
   dart run flutter_flavorizr -p android:icons,ios:icons
   ```

---

## Project Structure

*   `flavorizr.yaml`: Central configuration for native flavors.
*   `lib/flavors.dart`: Dart-side flavor configuration and metadata.
*   `lib/main_*.dart`: Flavor-specific entry points.
*   `lib/app.dart`: Main application widget.
*   `.vscode/launch.json`: Pre-configured debugger settings.

---

## Testing

### Core (100% coverage)
All files under `lib/core/` are fully covered with unit tests:
*   Client interceptor (queue, refresh, error handling)
*   Storage managers (secure, local, hive)
*   Core types (Failure, Result, typedefs)
*   Network config, constants, extensions

Run: `flutter test test/core/`

### Features (52.8% coverage)
Unit tests cover all non-widget logic in `lib/features/`:
*   Auth DTOs, datasource, repository, mapper, usecases, entities, bloc
*   Home cubit, state, tab
*   Bloc tests with `blocTest`, state machine verification, mock stubbing
*   Datasource tests with mocked HTTP client
*   Repository tests with mocked datasource + localStorage

Run: `flutter test test/features/`

Coverage report: `flutter test --coverage && genhtml coverage/lcov.info -o coverage/html`

---

## Architecture

The project follows a layered architecture with feature-first organization:

```
lib/
  core/           -- Shared infrastructure (network, storage, types)
  features/
    auth/         -- Authentication feature (login/logout)
      data/       -- DTOs, datasource, repository, mapper
      domain/     -- Entities, usecases, repository interface
      presentation/ -- Bloc, state, events, pages
    home/         -- Home feature (tab navigation)
      presentation/ -- Cubit, state, pages
```

---

## Powered By

*   [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr) - Native flavor orchestration.
*   [change_project_name](https://pub.dev/packages/change_project_name) - Rapid project renaming.
