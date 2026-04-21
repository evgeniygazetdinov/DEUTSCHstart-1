import 'package:flutter_test/flutter_test.dart';

import 'package:test_deutsch_start/main.dart';

void main() {
  testWidgets('Home shows Hören, Lesen, Sprechen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('Hören'), findsOneWidget);
    expect(find.textContaining('Lesen'), findsOneWidget);
    expect(find.textContaining('Sprechen'), findsOneWidget);
  });
}
