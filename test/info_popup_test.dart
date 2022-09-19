import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'MyApp has 3 text widgets',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final Finder widgets = find.byType(Text);

      expect(widgets, findsNWidgets(3));
    },
  );

  testWidgets(
    'MyApp has normal info popup widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await safeTapByKey(tester, infoPopupTextExampleKey);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text(infoPopupTextExampleText), findsOneWidget);
    },
  );

  testWidgets(
    'MyApp has info popup widget with custom widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await safeTapByKey(tester, infoPopupCustomExampleKey);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final Finder widgets = find.text(infoPopupCustomExampleText);

      expect(widgets, findsOneWidget);
    },
  );

  testWidgets(
    'MyApp has info popup widget with long text',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await safeTapByKey(tester, infoPopupLongTextExampleKey);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final Finder widgets = find.text(infoPopupLongTextExampleText);

      expect(widgets, findsOneWidget);
    },
  );
}

Future<void> safeTapByKey(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await tester.tap(find.byKey(key));
}
