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
