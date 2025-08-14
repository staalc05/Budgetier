import 'package:flutter/material.dart';

/// Shows a list of the user's fixed incomes (salary, benefits, etc.) that are
/// counted separately from variable earnings. Users can view or edit fixed
/// income sources here. The MVP displays a static example list.
class FixedIncomeScreen extends StatelessWidget {
  const FixedIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fixed Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fixes Einkommen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Gehalt'),
                subtitle: const Text('Letzter Banktag des Monats'),
                trailing: const Text('+3.000€'),
                onTap: () {
                  // TODO: edit fixed income
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Nebeneinkommen'),
                subtitle: const Text('15. des Monats'),
                trailing: const Text('+500€'),
                onTap: () {
                  // TODO: edit fixed income
                },
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: add new fixed income
                },
                icon: const Icon(Icons.add),
                label: const Text('Einkommen hinzufügen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
