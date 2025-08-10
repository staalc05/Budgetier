import 'package:flutter/material.dart';

/// Displays the user's financial goals and progress toward each. Goals can be
/// created, paused or edited. The MVP shows a simple list with one example
/// goal and a button to add more.
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deine Ziele', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Sommerurlaub'),
                subtitle: const Text('Ziel: 2000€ bis 01.08.2026'),
                trailing: const Text('Gespart: 500€'),
                onTap: () {
                  // TODO: navigate to goal details
                },
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: implement goal creation
                },
                icon: const Icon(Icons.add),
                label: const Text('Ziel hinzufügen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}