// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aqua_sense/main.dart';

void main() {
  testWidgets('AquaSense Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AquaSenseApp());

    // Verify that the dashboard title is present.
    expect(find.text('AquaSense Dashboard'), findsOneWidget);

    // Verify that the "Live Reservoir Data" section header is present.
    expect(find.text('Live Reservoir Data'), findsOneWidget);

    // Verify that some sensor cards are displayed (e.g., pH Level).
    expect(find.text('pH Level'), findsOneWidget);
    expect(find.text('TDS'), findsOneWidget);

    // Verify that the "Take Reading Now" button is present.
    expect(find.text('Take Reading Now'), findsOneWidget);
    
    // Tap the 'Take Reading Now' button and trigger a frame.
    await tester.tap(find.text('Take Reading Now'));
    await tester.pump();

    // Verify that the snackbar appears after tapping the button.
    expect(find.text('Manual reading requested from ESP32...'), findsOneWidget);
  });
}
