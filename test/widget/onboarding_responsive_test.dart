import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodlence/views/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('onboarding remains scrollable on a short viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    expect(tester.takeException(), isNull);
    expect(find.text('Scan Food Labels Instantly'), findsOneWidget);
  });
}
