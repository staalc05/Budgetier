import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgetier_app/main.dart';

void main() {
  testWidgets('shows sign in screen initially', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BudgetierApp()));
    expect(find.text('Anmelden'), findsOneWidget);
  });
}
