import 'package:flutter/material.dart';

/// Shows a feed of recent transactions imported from connected bank accounts.
/// Users can categorise transactions and identify recurring ones. The MVP
/// displays a static list of example transactions.
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _TransactionTile(
            description: 'Billa',
            date: DateTime.now().subtract(const Duration(days: 1)),
            amount: -25.30,
            category: 'Groceries',
          ),
          _TransactionTile(
            description: 'Netflix',
            date: DateTime.now().subtract(const Duration(days: 3)),
            amount: -13.99,
            category: 'Entertainment',
          ),
          _TransactionTile(
            description: 'Salary',
            date: DateTime.now().subtract(const Duration(days: 10)),
            amount: 2500.00,
            category: 'Income',
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String description;
  final DateTime date;
  final double amount;
  final String category;

  const _TransactionTile({
    required this.description,
    required this.date,
    required this.amount,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isOutgoing = amount < 0;
    // Use light blue for incoming transactions instead of green to align with
    // the overall application colour scheme. Outgoing transactions remain
    // highlighted in red to convey the negative context.
    final Color indicatorColor = isOutgoing ? Colors.redAccent : Colors.lightBlue;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: indicatorColor,
          child: Icon(isOutgoing ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white),
        ),
        title: Text(description),
        subtitle: Text(category),
        trailing: Text(
          '${isOutgoing ? '-' : ''}€${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: indicatorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}