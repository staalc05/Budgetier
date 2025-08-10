import 'package:flutter/material.dart';

/// Home screen displaying an overview of the user's current budget period.
/// In future iterations this page will show the daily allowance, remaining
/// budgets per category and trends. For now it contains placeholder text.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgetier')),
      body: const Center(
        child: Text(
          'Willkommen bei Budgetier!\nHier siehst du dein heutiges Budget und deine Kategorien.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}