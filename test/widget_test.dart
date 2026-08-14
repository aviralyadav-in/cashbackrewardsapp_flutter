import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic sanity test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Cashback & Rewards App'),
        ),
      ),
    );

    expect(find.text('Cashback & Rewards App'), findsOneWidget);
  });
}
