import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

Widget _launcher(void Function(BuildContext context) open, {ThemeData? theme}) {
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
    testWidgets('showError shows the message and OK closes it', (tester) async {
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
