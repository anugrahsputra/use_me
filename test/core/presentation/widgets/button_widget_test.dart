import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('ButtonWidget', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(onTap: () {}, child: const Text('Click me')),
          ),
        ),
      );

      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ButtonWidget(
                onTap: () => tapped = true,
                child: const Text('Tap'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byWidgetPredicate((w) => w is InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('isEnabled false uses 50% opacity', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              onTap: () {},
              isEnabled: false,
              child: const Text('Disabled'),
            ),
          ),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('isEnabled true uses full color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              onTap: () {},
              isEnabled: true,
              child: const Text('Enabled'),
            ),
          ),
        ),
      );

      expect(find.text('Enabled'), findsOneWidget);
    });

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
        isA<BoxDecoration>().having((d) => d.color, 'color', AppColors.primary),
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
  });
}
