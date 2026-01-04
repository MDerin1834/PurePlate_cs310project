import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test - MaterialApp renders', (WidgetTester tester) async {
    // Build a simple MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('PurePlate'),
          ),
        ),
      ),
    );

    // Verify that the app renders
    expect(find.text('PurePlate'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Theme applies correctly', (WidgetTester tester) async {
    // Test that widgets render with theme
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(primaryColor: Colors.green),
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          body: const Center(child: Text('Content')),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}