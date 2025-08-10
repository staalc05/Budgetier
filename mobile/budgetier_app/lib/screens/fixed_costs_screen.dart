import 'package:flutter/material.dart';

/// Shows a list of the user's fixed costs (rent, utilities, etc.) that are
/// excluded from daily budget adjustments. Users can add or edit fixed
/// expenses here. The MVP displays a static example list.
class FixedCostsScreen extends StatelessWidget {
  const FixedCostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fixed Costs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fixkosten', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Miete'),
                subtitle: const Text('Fällig: 1. des Monats'),
                trailing: const Text('800€'),
                onTap: () {
                  // TODO: edit fixed cost
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Strom'),
                subtitle: const Text('Fällig: 15. des Monats'),
                trailing: const Text('60€'),
                onTap: () {},
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: add new fixed cost
                },
                icon: const Icon(Icons.add),
                label: const Text('Fixkosten hinzufügen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}