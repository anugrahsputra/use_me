import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('FormFieldWidget', () {
    testWidgets('renders with hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FormFieldWidget(hintText: 'Enter text')),
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('renders with initial value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FormFieldWidget(initialValue: 'Prefilled')),
        ),
      );

      expect(find.text('Prefilled'), findsOneWidget);
    });

    testWidgets('renders password field with obscure toggle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormFieldWidget(isPassword: true, hintText: 'Password'),
          ),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: FormFieldWidget(isPassword: true))),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('renders prefix icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormFieldWidget(prefixIcon: const Icon(Icons.person)),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders error text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FormFieldWidget(errorText: 'Error message')),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('calls onSubmit when submitted', (tester) async {
      String? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: FormFieldWidget(
                onSubmit: (value) => submittedValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test value');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedValue, 'test value');
    });

    testWidgets('non-password field has no suffix icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: const FormFieldWidget())),
      );

      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    InputDecoration decorationOf(WidgetTester tester) =>
        tester.widget<InputDecorator>(find.byType(InputDecorator)).decoration;

    testWidgets('keeps the theme fill when no fillColor is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: FormFieldWidget()),
        ),
      );

      expect(decorationOf(tester).filled, isTrue);
      expect(decorationOf(tester).fillColor, AppColors.canvas);
    });

    testWidgets('fillColor overrides the theme fill', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: FormFieldWidget(fillColor: AppColors.surfaceCard),
          ),
        ),
      );

      expect(decorationOf(tester).filled, isTrue);
      expect(decorationOf(tester).fillColor, AppColors.surfaceCard);
    });

    testWidgets('borders come from the theme without borderRadius', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: FormFieldWidget()),
        ),
      );

      expect(
        decorationOf(tester).enabledBorder,
        isA<OutlineInputBorder>().having(
          (b) => b.borderRadius,
          'borderRadius',
          BorderRadius.circular(AppRadius.md),
        ),
      );
    });

    testWidgets('borderRadius applies to every border state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: FormFieldWidget(borderRadius: 24)),
        ),
      );

      final decoration = decorationOf(tester);
      for (final border in [
        decoration.enabledBorder,
        decoration.focusedBorder,
        decoration.errorBorder,
        decoration.focusedErrorBorder,
      ]) {
        expect(
          border,
          isA<OutlineInputBorder>().having(
            (b) => b.borderRadius,
            'borderRadius',
            BorderRadius.circular(24),
          ),
        );
      }
    });

    testWidgets('shows suffixIcon on a plain field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FormFieldWidget(suffixIcon: Icon(Icons.close))),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('password field keeps its toggle over suffixIcon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FormFieldWidget(
              isPassword: true,
              suffixIcon: Icon(Icons.close),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('autofocus focuses the field on first build', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FormFieldWidget(autofocus: true)),
        ),
      );
      await tester.pump();

      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
    });
  });
}
