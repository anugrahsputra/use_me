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
