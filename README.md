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

**Terminal:**
```bash
# Run Development
flutter run --flavor latte -t lib/main_latte.dart

# Run Staging
flutter run --flavor macchiato -t lib/main_macchiato.dart

# Run Production
flutter run --flavor espresso -t lib/main_espresso.dart
```

**VS Code:**
Open the `Run & Debug` panel and select either **Latte**, **Macchiato**, or **Espresso**.

---

## Configuration Management

### 1. Environment Variables (.env)
Managed via `flutter_dotenv`. Each flavor loads its own configuration on startup:
*   `.env.latte`
*   `.env.macchiato`
*   `.env.espresso`

*Note: These files are excluded from git via `.gitignore`.*

### 2. Native API Keys
Injected at compile-time to avoid hardcoding secrets in manifests:
*   **Android:** Configured in `android/app/flavorizr.gradle.kts` via `resValue`.
*   **iOS:** Configured in `ios/Flutter/*.xcconfig` files.

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
*   [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) - Environment variable management.
