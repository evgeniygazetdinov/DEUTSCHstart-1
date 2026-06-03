import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_deutsch_start/main.dart';

void main() {
  testWidgets('Home shows Hören, Lesen, Sprechen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Hören'), findsOneWidget);
    expect(find.textContaining('Lesen'), findsOneWidget);
    expect(find.textContaining('Sprechen'), findsOneWidget);
  });
}
