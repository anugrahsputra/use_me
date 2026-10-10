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
