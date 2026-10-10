# Design system port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Effort:** high

**Update:** the bundled fonts were dropped afterwards in favor of the platform font. See `docs/superpowers/plans/2026-10-11-drop-bundled-fonts.md`.

**Goal:** Port the memories-space theme tokens, fonts, and generic widgets into the use_me template and turn the theme on in `App`.

**Architecture:** Tokens (`AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`) and `AppTheme` go in a new `lib/core/presentation/theme/` folder behind a `theme.dart` barrel, exported from `presentation.dart`. Generic widgets go in the existing `lib/core/presentation/widgets/` folder and barrel. Two widgets that already exist here (`ButtonWidget`, `FormFieldWidget`) are replaced with the upgraded source versions.

**Tech Stack:** Flutter 3.47.0 via FVM, Material 3, flutter_test. No new packages.

**Spec:** None. Scope was agreed with the user in chat on 2026-10-11. It covers tokens, theme, and fonts plus the generic widgets. Global Constraints below records what is in and out.

**Source repo (read-only, never edit):** `/Users/downormal/Dev/projects/MemoriesSpace/memories-space-ma`. Steps below call it `$SRC`.

**Handoff report:** `.handoff/2026-10-11-design-system-port/executor.md`

## Global Constraints

- Prefix every Flutter and Dart command with `fvm`.
- Add no dependencies to `pubspec.yaml`. `flutter_svg` and `dotted_border` stay out.
- No `///` doc comments. Write a `//` comment only when the reason isn't obvious from the code.
- Imports use `package:use_me/...`. The string `memories_space` must not appear anywhere in this repo after the port.
- No `Colors.grey.*` or other hardcoded greys in ported code. Take neutral colors from `Theme.of(context).colorScheme` or `AppColors`.
- Do NOT port these: `StackedAvatars`, `cancelDialog`, `IconWidget`, `AppAssets`, any SVG icon, `DESIGN_SYSTEM.md`, `.design-sync/`, `ds-bundle/`, and the `sheet*` and `avatar*` colors.
- Git is read-only for the executor. No commit, stash, checkout, reset, or restore. The planner commits after review.
- Constructors use the class name (`const DividerWithTextWidget(...)`), not the `const new(...)` form the source uses. This repo writes them by class name.
- Deliberate departures from the source, all intended:
  - `AppDialog` closes with `Navigator.of(context).pop()` instead of `di<AppNavigator>().back(context)`, so core widgets don't depend on DI or GoRouter. Its three copy-pasted dialog bodies collapse into one private widget, and its buttons take their style from the theme.
  - `confirmDialog` defaults its labels to `Cancel` and `Confirm` instead of `Keep Editing` and `Discard`.
  - `FormFieldWidget` leaves `filled` and all borders to the theme unless the caller passes `fillColor` or `borderRadius`. Its error color comes from the theme.
  - `DividerWithTextWidget` renders its `text` argument. The source ignores it and always prints `OR`.
  - `OutlinedButtonWidget.isEnabled` defaults to `true`, matching `ButtonWidget`.
  - `ButtonWidget` passes its 16px radius to the ink splash so the ripple matches the rounded corners.

## Review Focus

1. A dialog opened under `AppTheme.dark` must show its message in a light, readable color. The source hardcodes `Colors.grey.shade600`. Pinned in Task 4.
2. A `FormFieldWidget` with no `fillColor` must keep the theme's fill. The source sets `filled: false` and silently drops it. Pinned in Task 3.
3. A password `FormFieldWidget` that is also given a `suffixIcon` must keep the visibility toggle. Pinned in Task 3.
4. A `ButtonWidget` on iOS goes through `CupertinoButton`. It must fire `onTap`, and must not throw when `onTap` is null (the login page passes null while the form is invalid). Pinned in Task 2.
5. A font family name in `AppTypography` that `pubspec.yaml` doesn't declare falls back to the system font with no error. Pinned in Task 1.

---

### Task 1: Theme tokens, fonts, and app wiring

**Files:**
- Create: `lib/core/presentation/theme/app_colors.dart`
- Create: `lib/core/presentation/theme/app_dimens.dart`
- Create: `lib/core/presentation/theme/app_typography.dart`
- Create: `lib/core/presentation/theme/app_theme.dart` (copied from `$SRC`, then edited)
- Create: `lib/core/presentation/theme/theme.dart`
- Create: `assets/fonts/42dotsanswght.ttf`, `assets/fonts/lora_variable.ttf`, `assets/fonts/lora_variable_italic.ttf` (binary copies)
- Modify: `lib/core/presentation/presentation.dart`
- Modify: `pubspec.yaml` (`flutter:` section)
- Modify: `lib/app/app.dart:20` and `:27-28`
- Test: `test/core/presentation/theme/app_theme_test.dart`

**Interfaces:**
- Produces: `AppColors` (static `Color` consts), `AppSpacing` (`xxs` 4, `xs` 8, `sm` 12, `md` 16, `lg` 24, `xl` 32, `xxl` 48, `section` 96), `AppRadius` (`xs` 4, `sm` 6, `md` 8, `lg` 12, `xl` 16, `pill` 9999), `AppTypography.textTheme` (`TextTheme`), `AppTheme.light` and `AppTheme.dark` (`ThemeData` getters). All reachable through `package:use_me/core/core.dart`.

- [ ] **Step 1: Write the failing test**

Create `test/core/presentation/theme/app_theme_test.dart`:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('AppTheme', () {
    testWidgets('light theme uses the cream canvas', (tester) async {
      final theme = AppTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.canvas);
    });

    testWidgets('dark theme uses the dark surface', (tester) async {
      final theme = AppTheme.dark;
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.surfaceDark);
    });

    testWidgets('primary button resolves pressed and disabled colors', (
      tester,
    ) async {
      final background =
          AppTheme.light.elevatedButtonTheme.style?.backgroundColor;
      expect(background?.resolve({}), AppColors.primary);
      expect(
        background?.resolve({WidgetState.pressed}),
        AppColors.primaryActive,
      );
      expect(
        background?.resolve({WidgetState.disabled}),
        AppColors.primaryDisabled,
      );
    });
  });

  group('AppTypography', () {
    test('display styles are serif and body styles are sans', () {
      expect(AppTypography.textTheme.displayLarge?.fontFamily, 'Lora');
      expect(AppTypography.textTheme.bodyLarge?.fontFamily, '42dot Sans');
    });

    // A family that pubspec.yaml doesn't declare falls back to the system
    // font with no error, so pin both sides here.
    test('every font family is declared in pubspec.yaml with its file', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec, contains('family: Lora'));
      expect(pubspec, contains('family: 42dot Sans'));
      for (final font in const [
        '42dotsanswght.ttf',
        'lora_variable.ttf',
        'lora_variable_italic.ttf',
      ]) {
        expect(pubspec, contains('assets/fonts/$font'));
        expect(File('assets/fonts/$font').existsSync(), isTrue, reason: font);
      }
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/core/presentation/theme/app_theme_test.dart`
Expected: FAIL to compile, `Undefined name 'AppTheme'` (and `AppColors`, `AppTypography`).

- [ ] **Step 3: Create `lib/core/presentation/theme/app_colors.dart`**

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand accent, muted sage green
  static const Color primary = Color(0xFF7D8B6A);
  static const Color primaryActive = Color(0xFF5F6B4F);
  static const Color primaryDisabled = Color(0xFFE6DFD8);
  static const Color accentTeal = Color(0xFF5DB8A6);
  static const Color accentAmber = Color(0xFFE8A55A);

  // Text
  static const Color ink = Color(0xFF141413);
  static const Color bodyStrong = Color(0xFF252523);
  static const Color body = Color(0xFF3D3D3A);
  static const Color muted = Color(0xFF6C6A64);
  static const Color mutedSoft = Color(0xFF8E8B82);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onDark = Color(0xFFFAF9F5);
  static const Color onDarkSoft = Color(0xFFA09D96);

  // Cream surfaces
  static const Color canvas = Color(0xFFFAF9F5);
  static const Color surfaceSoft = Color(0xFFF5F0E8);
  static const Color surfaceCard = Color(0xFFEFE9DE);
  static const Color surfaceCreamStrong = Color(0xFFE8E0D2);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF181715);
  static const Color surfaceDarkElevated = Color(0xFF252320);
  static const Color surfaceDarkSoft = Color(0xFF1F1E1B);

  // Hairlines and borders
  static const Color hairline = Color(0xFFE6DFD8);
  static const Color hairlineSoft = Color(0xFFEBE6DF);

  // Semantic
  static const Color success = Color(0xFF5DB872);
  static const Color warning = Color(0xFFD4A017);
  static const Color error = Color(0xFFC64545);

  // Dark pastels
  static const Color darkPastelRose = Color(0xFFC36F6F);
  static const Color darkPastelGreen = Color(0xFF5A8C74);
  static const Color darkPastelBlue = Color(0xFF5B7A99);
  static const Color darkPastelPurple = Color(0xFF8A6C8C);
  static const Color darkPastelOrange = Color(0xFFC48B62);
  static const Color darkPastelTeal = Color(0xFF4F8F8A);
  static const Color darkPastelMauve = Color(0xFF9A6F86);
  static const Color darkPastelOlive = Color(0xFF7F8B5F);
}
```

- [ ] **Step 4: Create `lib/core/presentation/theme/app_dimens.dart`**

```dart
// 4px base unit.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double section = 96;
}

abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double pill = 9999;
}
```

- [ ] **Step 5: Create `lib/core/presentation/theme/app_typography.dart`**

```dart
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextStyle _serif(double size, double letterSpacing, double height) =>
      TextStyle(
        fontFamily: 'Lora',
        fontSize: size,
        fontWeight: FontWeight.w500,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle _sans(
    double size,
    FontWeight weight,
    double height, {
    double letterSpacing = 0,
  }) => TextStyle(
    // ponytail: variable font, one file covers w300 to w800 via the wght axis.
    fontFamily: '42dot Sans',
    fontSize: size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    height: height,
  );

  static final TextTheme textTheme = TextTheme(
    displayLarge: _serif(64, -1.5, 1.05),
    displayMedium: _serif(48, -1, 1.1),
    displaySmall: _serif(36, -0.5, 1.15),
    headlineMedium: _serif(28, -0.3, 1.2),
    titleLarge: _sans(22, FontWeight.w500, 1.3),
    titleMedium: _sans(18, FontWeight.w500, 1.4),
    titleSmall: _sans(16, FontWeight.w500, 1.4),
    bodyLarge: _sans(16, FontWeight.w400, 1.55),
    bodyMedium: _sans(14, FontWeight.w400, 1.55),
    bodySmall: _sans(13, FontWeight.w500, 1.4),
    labelLarge: _sans(14, FontWeight.w500, 1),
    labelMedium: _sans(14, FontWeight.w500, 1.4),
    labelSmall: _sans(12, FontWeight.w500, 1.4, letterSpacing: 1.5),
  );
}
```

- [ ] **Step 6: Copy `app_theme.dart`, fix its imports, strip its doc comments**

```bash
SRC=/Users/downormal/Dev/projects/MemoriesSpace/memories-space-ma
cp "$SRC/lib/core/presentation/theme/app_theme.dart" lib/core/presentation/theme/app_theme.dart
sed -i '' -e 's#package:memories_space/#package:use_me/#' -e '/^ *\/\/\//d' lib/core/presentation/theme/app_theme.dart
grep -n 'memories_space\|///' lib/core/presentation/theme/app_theme.dart
```

Expected: the `grep` prints nothing. The three imports now read `package:use_me/core/presentation/theme/app_colors.dart`, `.../app_dimens.dart`, `.../app_typography.dart`. Make no other edits to this file.

- [ ] **Step 7: Create the barrel and export it**

`lib/core/presentation/theme/theme.dart`:

```dart
export 'app_colors.dart';
export 'app_dimens.dart';
export 'app_theme.dart';
export 'app_typography.dart';
```

In `lib/core/presentation/presentation.dart`, add one line at the end:

```dart
export 'theme/theme.dart';
```

- [ ] **Step 8: Copy the fonts and declare them**

```bash
SRC=/Users/downormal/Dev/projects/MemoriesSpace/memories-space-ma
mkdir -p assets/fonts
cp "$SRC/assets/fonts/42dotsanswght.ttf" "$SRC/assets/fonts/lora_variable.ttf" "$SRC/assets/fonts/lora_variable_italic.ttf" assets/fonts/
```

In `pubspec.yaml`, insert the `fonts:` block directly after the existing `assets:` block, so that part of the `flutter:` section reads:

```yaml
  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/icons/

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

Leave the commented example block that follows untouched. Then run `fvm flutter pub get`.

- [ ] **Step 9: Turn the theme on in `lib/app/app.dart`**

Change the outer `MaterialApp` line:

```dart
      theme: ThemeData(primarySwatch: Colors.blue),
```

to:

```dart
      theme: AppTheme.light,
```

And in the inner `MaterialApp.router`, replace:

```dart
            // theme: AppTheme.light,
            // darkTheme: AppTheme.dark,
```

with:

```dart
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
```

`themeMode` defaults to `ThemeMode.system`, so don't add it. `AppTheme` comes in through the existing `package:use_me/core/core.dart` import. Leave `_flavorBanner` alone.

- [ ] **Step 10: Run tests and analyze**

Run: `fvm flutter test test/core/presentation/theme/app_theme_test.dart`
Expected: PASS, 5 tests.

Run: `fvm flutter analyze`
Expected: `No issues found!`

No commit. The planner commits after review.

---

### Task 2: Tappables and buttons

**Files:**
- Create: `lib/core/presentation/widgets/platform_tappable_widget.dart`
- Modify (full replace): `lib/core/presentation/widgets/button_widget.dart`
- Create: `lib/core/presentation/widgets/outlined_button_widget.dart`
- Create: `lib/core/presentation/widgets/icon_button_widget.dart`
- Modify: `lib/core/presentation/widgets/widgets.dart`
- Test: `test/core/presentation/widgets/platform_tappable_widget_test.dart` (new)
- Test: `test/core/presentation/widgets/button_widget_test.dart` (append to existing group)
- Test: `test/core/presentation/widgets/outlined_button_widget_test.dart` (new)
- Test: `test/core/presentation/widgets/icon_button_widget_test.dart` (new)

**Interfaces:**
- Consumes: `AppColors`, `AppSpacing`, `AppRadius`, `AppTheme` from Task 1.
- Produces:
  - `PlatformTappableWidget({required VoidCallback? onTap, required Widget child, BorderRadius? borderRadius})`
  - `ButtonWidget({required VoidCallback? onTap, required Widget child, bool isEnabled = true, double? width, double? height, Color? color})`
  - `OutlinedButtonWidget({required VoidCallback? onTap, required Widget child, bool isEnabled = true, Color? fillColor})`
  - `AppIconButton({required VoidCallback onTap, required IconData icon})`

`ButtonWidget.isEnabled` now defaults to `true` (it was `false`). The one caller, `LoginButton` in `login_page.component.dart`, always passes it explicitly, so it needs no change.

- [ ] **Step 1: Write the failing tests**

Create `test/core/presentation/widgets/platform_tappable_widget_test.dart`:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

Widget _wrap(Widget child, {TargetPlatform platform = TargetPlatform.android}) {
  return MaterialApp(
    theme: AppTheme.light.copyWith(platform: platform),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('PlatformTappableWidget', () {
    testWidgets('uses InkWell on Android', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          PlatformTappableWidget(
            onTap: () => tapped = true,
            child: const Text('Tap'),
          ),
        ),
      );

      expect(find.byType(CupertinoButton), findsNothing);
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('uses CupertinoButton on iOS', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          PlatformTappableWidget(
            onTap: () => tapped = true,
            child: const Text('Tap'),
          ),
          platform: TargetPlatform.iOS,
        ),
      );

      expect(find.byType(InkWell), findsNothing);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });
}
```

Append these tests inside the existing `group('ButtonWidget', ...)` in `test/core/presentation/widgets/button_widget_test.dart`, after the last existing test. Also add `import 'package:flutter/cupertino.dart';` above the existing material import. Keep the existing four tests as they are.

```dart
    testWidgets('defaults to enabled, full width, theme primary', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ButtonWidget(onTap: () {}, child: const Text('Wide')),
          ),
        ),
      );

      expect(tester.getSize(find.byType(Ink)).width, 800);
      expect(
        tester.widget<Ink>(find.byType(Ink)).decoration,
        isA<BoxDecoration>().having(
          (d) => d.color,
          'color',
          AppColors.primary,
        ),
      );
    });

    testWidgets('color overrides the theme primary', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ButtonWidget(
              onTap: () {},
              color: AppColors.error,
              child: const Text('Danger'),
            ),
          ),
        ),
      );

      expect(
        tester.widget<Ink>(find.byType(Ink)).decoration,
        isA<BoxDecoration>().having((d) => d.color, 'color', AppColors.error),
      );
    });

    testWidgets('fires onTap on iOS', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light.copyWith(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: ButtonWidget(
              onTap: () => tapped = true,
              child: const Text('Tap'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('null onTap on iOS does not throw', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light.copyWith(platform: TargetPlatform.iOS),
          home: const Scaffold(
            body: ButtonWidget(
              onTap: null,
              isEnabled: false,
              child: Text('Disabled'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
```

Create `test/core/presentation/widgets/outlined_button_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('OutlinedButtonWidget', () {
    testWidgets('renders child and fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: OutlinedButtonWidget(
              onTap: () => tapped = true,
              child: const Text('Outline'),
            ),
          ),
        ),
      );

      expect(find.text('Outline'), findsOneWidget);
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('fills with the theme surface by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: OutlinedButtonWidget(
              onTap: () {},
              child: const Text('Outline'),
            ),
          ),
        ),
      );

      expect(
        tester.widget<Ink>(find.byType(Ink)).decoration,
        isA<BoxDecoration>().having((d) => d.color, 'color', AppColors.canvas),
      );
    });
  });
}
```

Create `test/core/presentation/widgets/icon_button_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('AppIconButton', () {
    testWidgets('renders the icon and fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: AppIconButton(
                onTap: () => tapped = true,
                icon: Icons.settings,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings));
      expect(tapped, isTrue);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/core/presentation/widgets/`
Expected: FAIL to compile, with errors like `Undefined name 'PlatformTappableWidget'`, `'OutlinedButtonWidget'`, `'AppIconButton'`, and `No named parameter with the name 'color'`.

- [ ] **Step 3: Create `lib/core/presentation/widgets/platform_tappable_widget.dart`**

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTappableWidget extends StatelessWidget {
  const PlatformTappableWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: onTap,
              child: child,
            )
          : InkWell(onTap: onTap, borderRadius: borderRadius, child: child),
    );
  }
}
```

- [ ] **Step 4: Replace `lib/core/presentation/widgets/button_widget.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/widgets/platform_tappable_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.isEnabled = true,
    this.width,
    this.height,
    this.color,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;
    final isBtnEnabled = isEnabled
        ? primaryColor
        : primaryColor.withValues(alpha: 0.5);
    final radius = BorderRadius.circular(16);

    return PlatformTappableWidget(
      onTap: onTap,
      borderRadius: radius,
      child: Ink(
        width: width ?? double.infinity,
        height: height ?? 52,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: isBtnEnabled, borderRadius: radius),
        child: Align(child: child),
      ),
    );
  }
}
```

- [ ] **Step 5: Create `lib/core/presentation/widgets/outlined_button_widget.dart`**

```dart
import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  const OutlinedButtonWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.isEnabled = true,
    this.fillColor,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final borderColor = isEnabled
        ? scheme.outline
        : scheme.outline.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fillColor ?? scheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Align(child: child),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Create `lib/core/presentation/widgets/icon_button_widget.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({required this.onTap, required this.icon, super.key});

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          border: Border.all(color: AppColors.muted.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Icon(icon, size: 22, color: AppColors.muted),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Export the new widgets**

Append to `lib/core/presentation/widgets/widgets.dart` (keep the two existing lines):

```dart
export 'platform_tappable_widget.dart';
export 'outlined_button_widget.dart';
export 'icon_button_widget.dart';
```

- [ ] **Step 8: Run tests and analyze**

Run: `fvm flutter test test/core/presentation/widgets/ test/features/auth/`
Expected: PASS. That includes the four original `ButtonWidget` tests, unchanged.

Run: `fvm flutter analyze`
Expected: `No issues found!`

No commit.

---

### Task 3: Form field and divider

**Files:**
- Modify (full replace): `lib/core/presentation/widgets/form_field_widget.dart`
- Create: `lib/core/presentation/widgets/divider_with_text_widget.dart`
- Modify: `lib/core/presentation/widgets/widgets.dart`
- Test: `test/core/presentation/widgets/form_field_widget_test.dart` (append to existing group)
- Test: `test/core/presentation/widgets/divider_with_text_widget_test.dart` (new)

**Interfaces:**
- Consumes: `AppColors`, `AppSpacing`, `AppRadius`, `AppTheme` from Task 1.
- Produces:
  - `FormFieldWidget` keeps every current parameter and adds `Color? fillColor`, `Widget? suffixIcon`, `double? borderRadius`, `bool autofocus = false`.
  - `DividerWithTextWidget({bool isVertical = false, String? text})`

- [ ] **Step 1: Write the failing tests**

Append these inside the existing `group('FormFieldWidget', ...)` in `test/core/presentation/widgets/form_field_widget_test.dart`, after the last existing test. Keep the existing eight tests.

```dart
    InputDecoration decorationOf(WidgetTester tester) =>
        tester.widget<InputDecorator>(find.byType(InputDecorator)).decoration;

    testWidgets('keeps the theme fill when no fillColor is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: FormFieldWidget()),
        ),
      );

      expect(decorationOf(tester).filled, isTrue);
      expect(decorationOf(tester).fillColor, AppColors.canvas);
    });

    testWidgets('fillColor overrides the theme fill', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: FormFieldWidget(fillColor: AppColors.surfaceCard),
          ),
        ),
      );

      expect(decorationOf(tester).filled, isTrue);
      expect(decorationOf(tester).fillColor, AppColors.surfaceCard);
    });

    testWidgets('borders come from the theme without borderRadius', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: FormFieldWidget()),
        ),
      );

      expect(
        decorationOf(tester).enabledBorder,
        isA<OutlineInputBorder>().having(
          (b) => b.borderRadius,
          'borderRadius',
          BorderRadius.circular(AppRadius.md),
        ),
      );
    });

    testWidgets('borderRadius applies to every border state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: FormFieldWidget(borderRadius: 24)),
        ),
      );

      final decoration = decorationOf(tester);
      for (final border in [
        decoration.enabledBorder,
        decoration.focusedBorder,
        decoration.errorBorder,
        decoration.focusedErrorBorder,
      ]) {
        expect(
          border,
          isA<OutlineInputBorder>().having(
            (b) => b.borderRadius,
            'borderRadius',
            BorderRadius.circular(24),
          ),
        );
      }
    });

    testWidgets('shows suffixIcon on a plain field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FormFieldWidget(suffixIcon: Icon(Icons.close))),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('password field keeps its toggle over suffixIcon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FormFieldWidget(
              isPassword: true,
              suffixIcon: Icon(Icons.close),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('autofocus focuses the field on first build', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FormFieldWidget(autofocus: true)),
        ),
      );
      await tester.pump();

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
        isTrue,
      );
    });
```

Create `test/core/presentation/widgets/divider_with_text_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('DividerWithTextWidget', () {
    testWidgets('shows the given text between two dividers', (tester) async {
      await tester.pumpWidget(
        _wrap(const DividerWithTextWidget(text: 'or continue with')),
      );

      expect(find.text('or continue with'), findsOneWidget);
      expect(find.text('OR'), findsNothing);
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('renders a plain Divider without text', (tester) async {
      await tester.pumpWidget(_wrap(const DividerWithTextWidget()));

      expect(find.byType(Divider), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders a VerticalDivider when isVertical', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            height: 40,
            child: DividerWithTextWidget(isVertical: true),
          ),
        ),
      );

      expect(find.byType(VerticalDivider), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/core/presentation/widgets/form_field_widget_test.dart test/core/presentation/widgets/divider_with_text_widget_test.dart`
Expected: FAIL to compile, with errors like `No named parameter with the name 'fillColor'` and `Undefined name 'DividerWithTextWidget'`.

- [ ] **Step 3: Replace `lib/core/presentation/widgets/form_field_widget.dart`**

```dart
import 'package:flutter/material.dart';

class FormFieldWidget extends StatefulWidget {
  const FormFieldWidget({
    super.key,
    this.controller,
    this.inputAction = TextInputAction.done,
    this.initialValue,
    this.errorText,
    this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.keyboardType,
    this.obscureInitially = true,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.onSubmit,
    this.fillColor,
    this.suffixIcon,
    this.borderRadius,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final TextInputAction inputAction;
  final String? initialValue;
  final String? errorText;
  final String? hintText;
  final bool isPassword;
  final bool obscureInitially;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final void Function(String value)? onSubmit;
  final Color? fillColor;

  // Ignored when isPassword is set. That slot holds the obscure toggle.
  final Widget? suffixIcon;
  final double? borderRadius;
  final bool autofocus;

  @override
  State<FormFieldWidget> createState() => _DefaultFormFieldState();
}

class _DefaultFormFieldState extends State<FormFieldWidget> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureInitially;
  }

  // Null hands the border back to the input theme. A pinned radius rebuilds
  // every state's border so they all share it.
  OutlineInputBorder? _border(Color color, {double width = 1}) {
    final radius = widget.borderRadius;
    if (radius == null) return null;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: widget.initialValue,
      autofocus: widget.autofocus,
      controller: widget.controller,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.inputAction,
      obscureText: widget.isPassword ? _isObscure : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: (value) => widget.onSubmit?.call(value),
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: widget.fillColor,
        border: _border(scheme.outline),
        enabledBorder: _border(scheme.outline),
        focusedBorder: _border(scheme.primary, width: 2),
        errorBorder: _border(scheme.error),
        focusedErrorBorder: _border(scheme.error, width: 2),
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                  color: scheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
```

Do not set `filled:` in the decoration. Leaving it null is what lets the theme's `filled: true` through.

- [ ] **Step 4: Create `lib/core/presentation/widgets/divider_with_text_widget.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/theme.dart';

class DividerWithTextWidget extends StatelessWidget {
  const DividerWithTextWidget({this.isVertical = false, this.text, super.key});

  final bool isVertical;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final label = text;
    if (isVertical) return const VerticalDivider();
    if (label == null) return const Divider();

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.muted, thickness: 0.5)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(child: Divider(color: AppColors.muted, thickness: 0.5)),
      ],
    );
  }
}
```

- [ ] **Step 5: Export it**

Append to `lib/core/presentation/widgets/widgets.dart`:

```dart
export 'divider_with_text_widget.dart';
```

- [ ] **Step 6: Run tests and analyze**

Run: `fvm flutter test test/core/presentation/widgets/ test/features/auth/`
Expected: PASS, including the eight original `FormFieldWidget` tests.

Run: `fvm flutter analyze`
Expected: `No issues found!`

No commit.

---

### Task 4: Dialogs

**Files:**
- Create: `lib/core/presentation/widgets/app_dialog_widget.dart`
- Modify: `lib/core/presentation/widgets/widgets.dart`
- Test: `test/core/presentation/widgets/app_dialog_widget_test.dart` (new)

**Interfaces:**
- Consumes: `AppColors`, `AppSpacing`, `AppRadius`, `AppTheme` from Task 1.
- Produces (all static on `abstract final class AppDialog`, all return `Future<void>`):
  - `showError(BuildContext context, String message)`
  - `showSuccess(BuildContext context, String message)`
  - `noticeDialog(BuildContext context, {required String title, required String message, String? actionMsg, VoidCallback? onAction})`
  - `confirmDialog(BuildContext context, {required String title, required String message, required VoidCallback onYes, String? confirmMsg, String? cancelMsg, VoidCallback? onNo})`

- [ ] **Step 1: Write the failing test**

Create `test/core/presentation/widgets/app_dialog_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

Widget _launcher(
  void Function(BuildContext context) open, {
  ThemeData? theme,
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.light,
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => open(context),
          child: const Text('open'),
        ),
      ),
    ),
  );
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  group('AppDialog', () {
    testWidgets('showError shows the message and OK closes it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _launcher((context) => AppDialog.showError(context, 'boom')),
      );
      await _open(tester);

      expect(find.text('Oops!'), findsOneWidget);
      expect(find.text('boom'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Oops!'), findsNothing);
    });

    testWidgets('showSuccess uses the success title', (tester) async {
      await tester.pumpWidget(
        _launcher((context) => AppDialog.showSuccess(context, 'saved')),
      );
      await _open(tester);

      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('saved'), findsOneWidget);
    });

    testWidgets('noticeDialog runs onAction instead of closing', (
      tester,
    ) async {
      var acted = false;
      await tester.pumpWidget(
        _launcher(
          (context) => AppDialog.noticeDialog(
            context,
            title: 'Offline',
            message: 'No connection',
            actionMsg: 'Retry',
            onAction: () => acted = true,
          ),
        ),
      );
      await _open(tester);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(acted, isTrue);
      expect(find.text('Offline'), findsOneWidget);
    });

    testWidgets('confirmDialog calls onYes and Cancel closes it', (
      tester,
    ) async {
      var confirmed = false;
      await tester.pumpWidget(
        _launcher(
          (context) => AppDialog.confirmDialog(
            context,
            title: 'Delete?',
            message: 'Gone for good',
            onYes: () => confirmed = true,
          ),
        ),
      );
      await _open(tester);

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
      expect(find.text('Delete?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Delete?'), findsNothing);
    });

    testWidgets('tapping the barrier does not dismiss', (tester) async {
      await tester.pumpWidget(
        _launcher((context) => AppDialog.showError(context, 'boom')),
      );
      await _open(tester);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Oops!'), findsOneWidget);
    });

    testWidgets('message follows the dark theme', (tester) async {
      await tester.pumpWidget(
        _launcher(
          (context) => AppDialog.showError(context, 'boom'),
          theme: AppTheme.dark,
        ),
      );
      await _open(tester);

      expect(
        tester.widget<Text>(find.text('boom')).style?.color,
        AppColors.onDarkSoft,
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/core/presentation/widgets/app_dialog_widget_test.dart`
Expected: FAIL to compile, `Undefined name 'AppDialog'`.

- [ ] **Step 3: Create `lib/core/presentation/widgets/app_dialog_widget.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/theme.dart';

abstract final class AppDialog {
  static Future<void> showError(BuildContext context, String message) =>
      noticeDialog(context, title: 'Oops!', message: message);

  static Future<void> showSuccess(BuildContext context, String message) =>
      noticeDialog(context, title: 'Success!', message: message);

  static Future<void> noticeDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionMsg,
    VoidCallback? onAction,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AppDialogBody(
        title: title,
        message: message,
        actions: [
          Expanded(
            child: ElevatedButton(
              onPressed: onAction ?? () => Navigator.of(dialogContext).pop(),
              child: Text(actionMsg ?? 'OK'),
            ),
          ),
        ],
      ),
    );
  }

  // onYes doesn't close the dialog. The caller pops it, so it can keep the
  // dialog up while async work runs.
  static Future<void> confirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onYes,
    String? confirmMsg,
    String? cancelMsg,
    VoidCallback? onNo,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AppDialogBody(
        title: title,
        message: message,
        actions: [
          Expanded(
            child: OutlinedButton(
              onPressed: onNo ?? () => Navigator.of(dialogContext).pop(),
              child: Text(cancelMsg ?? 'Cancel'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: onYes,
              child: Text(confirmMsg ?? 'Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppDialogBody extends StatelessWidget {
  const _AppDialogBody({
    required this.title,
    required this.message,
    required this.actions,
  });

  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(children: actions),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Export it**

Append to `lib/core/presentation/widgets/widgets.dart`:

```dart
export 'app_dialog_widget.dart';
```

- [ ] **Step 5: Run the full verification**

Run: `fvm flutter test test/core/presentation/widgets/app_dialog_widget_test.dart`
Expected: PASS, 6 tests.

Run: `fvm dart format` on every file this plan created or modified under `lib/` and `test/`. Name the files explicitly and don't format the whole tree.

Run: `fvm flutter analyze`
Expected: `No issues found!`

Run: `fvm flutter test`
Expected: all tests pass.

Run: `grep -rn "memories_space\|///\|Colors.grey" lib/core/presentation/theme lib/core/presentation/widgets`
Expected: no output.

Write `.handoff/2026-10-11-design-system-port/executor.md` with the full list of created and modified files and the real output of the last four commands. No commit.
