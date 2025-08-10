import 'package:flutter/material.dart';

/// Shows the current savings balance and allows the user to reassign funds
/// back into the active period. In this MVP the balance and ledger are
/// placeholders.
class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Savings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sparguthaben', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Hardcoded balance placeholder
            Row(
              children: const [
                Text('€ ', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                Text('100.00', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: implement reassign flow
              },
              child: const Text('Guthaben ins Budget verschieben'),
            ),
            const SizedBox(height: 24),
            const Text('Buchungen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Expanded(
              child: Center(
                child: Text('Keine Buchungen vorhanden.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}