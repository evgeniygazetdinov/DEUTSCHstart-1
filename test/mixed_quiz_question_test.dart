import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_deutsch_start/main.dart';

void main() {
  testWidgets('Mix playing shows question panel and answer tiles', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Mix'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, '30 Fragen starten'));
    await tester.pumpAndSettle();

    expect(find.text('Выберите:'), findsOneWidget);

    final panel = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration! as BoxDecoration).color == const Color(0xFFD6EBFF),
    );
    expect(panel, findsOneWidget);

    final panelText = find.descendant(
      of: panel,
      matching: find.byType(Text),
    );
    expect(panelText, findsWidgets);

    final texts = tester.widgetList<Text>(panelText).map((t) => t.data ?? '').join(' ');
    expect(texts.trim().length, greaterThan(2));
    expect(texts.contains('___') || RegExp(r'[A-Za-zÄÖÜäöüß]').hasMatch(texts), isTrue);
  });
}
