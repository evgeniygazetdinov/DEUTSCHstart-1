import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_deutsch_start/main.dart';

void main() {
  testWidgets('Home shows grammar modules', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Mix'), findsOneWidget);
    expect(find.textContaining('Artikel'), findsWidgets);
    expect(find.textContaining('Grammatik'), findsOneWidget);
    expect(find.textContaining('Hören'), findsNothing);
    expect(find.textContaining('Lesen'), findsNothing);
    expect(find.textContaining('Sprechen'), findsNothing);
  });
}
