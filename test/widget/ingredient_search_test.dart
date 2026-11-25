import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodlence/config/app_theme.dart';
import 'package:foodlence/views/search/ingredient_search_screen.dart';

void main() {
  testWidgets('ingredient search explains parsed label ingredients', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const IngredientSearchScreen(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Wheat flour, E211');
    await tester.tap(find.text('Search ingredients'));
    await tester.pumpAndSettle();

    expect(find.text('2 ingredients found'), findsOneWidget);
    expect(find.text('Wheat flour'), findsNWidgets(2));
    expect(find.text('E211'), findsNWidgets(3));
  });
}
