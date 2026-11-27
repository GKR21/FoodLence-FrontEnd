import 'package:flutter_test/flutter_test.dart';
import 'package:foodlence/app.dart';

void main() {
  testWidgets('FoodLense smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodLenceApp());
    await tester.pump();
    expect(find.text('FoodLense'), findsOneWidget);
  });
}
