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
