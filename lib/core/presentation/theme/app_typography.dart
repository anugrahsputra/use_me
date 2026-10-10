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
