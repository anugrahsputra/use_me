import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/app_colors.dart';
import 'package:use_me/core/presentation/theme/app_dimens.dart';
import 'package:use_me/core/presentation/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _base(
    brightness: Brightness.light,
    scheme: _lightScheme,
    scaffold: AppColors.canvas,
    displayColor: AppColors.ink,
    bodyColor: AppColors.body,
    cardColor: AppColors.surfaceCard,
    fieldFill: AppColors.canvas,
    outline: AppColors.hairline,
  );

  static ThemeData get dark => _base(
    brightness: Brightness.dark,
    scheme: _darkScheme,
    scaffold: AppColors.surfaceDark,
    displayColor: AppColors.onDark,
    bodyColor: AppColors.onDarkSoft,
    cardColor: AppColors.surfaceDarkElevated,
    fieldFill: AppColors.surfaceDarkSoft,
    outline: AppColors.surfaceDarkElevated,
  );

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.accentTeal,
    onSecondary: AppColors.ink,
    tertiary: AppColors.accentAmber,
    onTertiary: AppColors.ink,
    error: AppColors.error,
    onError: AppColors.onPrimary,
    surface: AppColors.canvas,
    onSurface: AppColors.ink,
    surfaceContainerLowest: AppColors.canvas,
    surfaceContainerLow: AppColors.surfaceSoft,
    surfaceContainer: AppColors.surfaceCard,
    surfaceContainerHigh: AppColors.surfaceCreamStrong,
    onSurfaceVariant: AppColors.muted,
    outline: AppColors.hairline,
    outlineVariant: AppColors.hairlineSoft,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.accentTeal,
    onSecondary: AppColors.ink,
    tertiary: AppColors.accentAmber,
    onTertiary: AppColors.ink,
    error: AppColors.error,
    onError: AppColors.onPrimary,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onDark,
    surfaceContainerLowest: AppColors.surfaceDark,
    surfaceContainerLow: AppColors.surfaceDarkSoft,
    surfaceContainer: AppColors.surfaceDarkElevated,
    surfaceContainerHigh: AppColors.surfaceDarkElevated,
    onSurfaceVariant: AppColors.onDarkSoft,
    outline: AppColors.surfaceDarkElevated,
    outlineVariant: AppColors.surfaceDarkSoft,
  );

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffold,
    required Color displayColor,
    required Color bodyColor,
    required Color cardColor,
    required Color fieldFill,
    required Color outline,
  }) {
    final TextTheme textTheme = AppTypography.textTheme.apply(
      bodyColor: bodyColor,
      displayColor: displayColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: textTheme,
      dividerColor: outline,
      dividerTheme: DividerThemeData(color: outline, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: displayColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _primaryButtonStyle(textTheme),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: outline),
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.mutedSoft),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: _fieldBorder(outline),
        enabledBorder: _fieldBorder(outline),
        focusedBorder: _fieldBorder(AppColors.primary, width: 2),
        errorBorder: _fieldBorder(AppColors.error),
        focusedErrorBorder: _fieldBorder(AppColors.error, width: 2),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );

  static ButtonStyle _primaryButtonStyle(TextTheme textTheme) => ButtonStyle(
    elevation: const WidgetStatePropertyAll<double>(0),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.primaryDisabled;
      }
      if (states.contains(WidgetState.pressed)) return AppColors.primaryActive;
      return AppColors.primary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? AppColors.muted
          : AppColors.onPrimary,
    ),
    textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.labelLarge),
    minimumSize: const WidgetStatePropertyAll<Size>(Size(64, 48)),
    padding: const WidgetStatePropertyAll<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
    ),
    shape: WidgetStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    ),
  );
}
