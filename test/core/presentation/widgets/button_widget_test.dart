import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('ButtonWidget', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              onTap: () {},
              child: const Text('Click me'),
            ),
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
  });
}
