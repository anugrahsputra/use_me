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
}
