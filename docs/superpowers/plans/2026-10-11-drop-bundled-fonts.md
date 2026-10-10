# Drop bundled fonts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Effort:** medium

**Goal:** Remove the bundled Lora and 42dot Sans fonts so the theme uses the platform font again, keeping the type scale.

**Architecture:** `AppTypography` stops setting `fontFamily`. `ThemeData` merges our `TextTheme` over the platform typography, so text falls back to Roboto on Android and SF Pro on iOS. The font files and the `pubspec.yaml` `fonts:` block go away. Sizes, weights, heights, and letter spacing stay the same.

**Tech Stack:** Flutter 3.47.0 via FVM, flutter_test.

**Spec:** None. The user decided on 2026-10-11 to drop bundled fonts and use the platform default. This amends the work from `docs/superpowers/plans/2026-10-11-design-system-port.md` (commit `f10eca7`).

**Handoff report:** `.handoff/2026-10-11-drop-bundled-fonts/executor.md`

## Global Constraints

- Prefix every Flutter and Dart command with `fvm`.
- No font files anywhere in the repo, and no `fonts:` block in `pubspec.yaml`.
- Don't add Inter, `GoogleFonts`, or any other font source.
- No `///` doc comments.
- Git is read-only for the executor. Delete files with `rm`, not `git rm`. The planner stages and commits.

## Review Focus

1. If `pubspec.yaml` still declares a font whose file is gone, `flutter test` and every build fail on the missing asset. Step 4's full `fvm flutter test` covers this.
2. If any of the 13 text styles still sets a `fontFamily`, it silently falls back to the platform font. Pinned by the first test in Step 1.
3. Merging the serif and sans helpers into one could drift a size or letter-spacing value. Pinned by the second test in Step 1.
4. A leftover `Lora` or `42dot` string elsewhere. Step 4's grep covers this.

---

### Task 1: Platform font

**Files:**
- Modify (full replace): `lib/core/presentation/theme/app_typography.dart`
- Modify: `pubspec.yaml` (remove the `fonts:` block)
- Delete: `assets/fonts/42dotsanswght.ttf`, `assets/fonts/lora_variable.ttf`, `assets/fonts/lora_variable_italic.ttf`, and the then-empty `assets/fonts/` folder
- Test: `test/core/presentation/theme/app_theme_test.dart` (replace the `AppTypography` group)

**Interfaces:**
- Produces: `AppTypography.textTheme` (`TextTheme`), same public name and type as before.

- [ ] **Step 1: Write the failing tests**

In `test/core/presentation/theme/app_theme_test.dart`, replace the whole `group('AppTypography', ...)` block with the one below. Then delete the `import 'dart:io';` line, which nothing uses any more. Leave the `AppTheme` group untouched.

```dart
  group('AppTypography', () {
    test('every style leaves fontFamily to the platform', () {
      final t = AppTypography.textTheme;
      final styles = [
        t.displayLarge,
        t.displayMedium,
        t.displaySmall,
        t.headlineMedium,
        t.titleLarge,
        t.titleMedium,
        t.titleSmall,
        t.bodyLarge,
        t.bodyMedium,
        t.bodySmall,
        t.labelLarge,
        t.labelMedium,
        t.labelSmall,
      ];
      for (final style in styles) {
        expect(style, isNotNull);
        expect(style?.fontFamily, isNull);
      }
    });

    test('keeps the type scale', () {
      final t = AppTypography.textTheme;
      expect(t.displayLarge?.fontSize, 64);
      expect(t.displayLarge?.letterSpacing, -1.5);
      expect(t.displayLarge?.fontWeight, FontWeight.w500);
      expect(t.headlineMedium?.fontSize, 28);
      expect(t.headlineMedium?.letterSpacing, -0.3);
      expect(t.bodyLarge?.fontSize, 16);
      expect(t.bodyLarge?.height, 1.55);
      expect(t.labelSmall?.letterSpacing, 1.5);
    });
  });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/core/presentation/theme/app_theme_test.dart`
Expected: `every style leaves fontFamily to the platform` FAILS with `Expected: null  Actual: 'Lora'`. `keeps the type scale` PASSES already.

- [ ] **Step 3: Replace `lib/core/presentation/theme/app_typography.dart`**

```dart
import 'package:flutter/material.dart';

// No fontFamily on purpose, so text uses the platform font. To brand an app
// built from this template, set one here and declare it in pubspec.yaml.
abstract final class AppTypography {
  static TextStyle _style(
    double size,
    FontWeight weight,
    double height, {
    double letterSpacing = 0,
  }) => TextStyle(
    fontSize: size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    height: height,
  );

  static final TextTheme textTheme = TextTheme(
    displayLarge: _style(64, FontWeight.w500, 1.05, letterSpacing: -1.5),
    displayMedium: _style(48, FontWeight.w500, 1.1, letterSpacing: -1),
    displaySmall: _style(36, FontWeight.w500, 1.15, letterSpacing: -0.5),
    headlineMedium: _style(28, FontWeight.w500, 1.2, letterSpacing: -0.3),
    titleLarge: _style(22, FontWeight.w500, 1.3),
    titleMedium: _style(18, FontWeight.w500, 1.4),
    titleSmall: _style(16, FontWeight.w500, 1.4),
    bodyLarge: _style(16, FontWeight.w400, 1.55),
    bodyMedium: _style(14, FontWeight.w400, 1.55),
    bodySmall: _style(13, FontWeight.w500, 1.4),
    labelLarge: _style(14, FontWeight.w500, 1),
    labelMedium: _style(14, FontWeight.w500, 1.4),
    labelSmall: _style(12, FontWeight.w500, 1.4, letterSpacing: 1.5),
  );
}
```

- [ ] **Step 4: Remove the fonts and verify**

Delete these 10 lines from `pubspec.yaml`: the `fonts:` block under `flutter:` and the blank line after it. The `assets:` block stays, followed directly by the `# To add custom fonts...` comment block, exactly as it was before commit `f10eca7`:

```yaml
  fonts:
    - family: 42dot Sans
      fonts:
        - asset: assets/fonts/42dotsanswght.ttf
    - family: Lora
      fonts:
        - asset: assets/fonts/lora_variable.ttf
        - asset: assets/fonts/lora_variable_italic.ttf
          style: italic

```

Then:

```bash
rm -r assets/fonts
git diff f10eca7~1 -- pubspec.yaml
```

Expected: the `git diff` prints nothing, because `pubspec.yaml` matches its state before the port.

Run: `fvm flutter pub get`
Expected: succeeds.

Run: `fvm dart format lib/core/presentation/theme/app_typography.dart test/core/presentation/theme/app_theme_test.dart`

Run: `fvm flutter analyze`
Expected: `No issues found!`

Run: `fvm flutter test`
Expected: all tests pass.

Run: `grep -rnE "Lora|42dot|assets/fonts" lib test pubspec.yaml`
Expected: no output.

Write `.handoff/2026-10-11-drop-bundled-fonts/executor.md` with the file list and the real output of the last four commands. No commit.
