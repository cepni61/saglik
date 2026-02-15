import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saglik/main.dart';

void main() {
  testWidgets('FoodScan AI app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodScanApp());

    // Verify that the app title is displayed
    expect(find.text('FoodScan AI'), findsAtLeastNWidgets(1));
    expect(find.text('Paketli gıda analiz uygulaması'), findsOneWidget);

    // Verify camera icon is present
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });
}
