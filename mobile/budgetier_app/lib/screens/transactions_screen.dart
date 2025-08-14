import 'package:flutter/material.dart';

// Import the screen used to add new transactions manually. This file defines
// AddTransactionScreen and the _AddTransactionResult class used to pass
// results back to this screen.
import 'add_transaction_screen.dart';

/// Internal representation of a transaction displayed in the TransactionsScreen.
/// Using a separate data class simplifies adding and managing transactions.
class _TransactionData {
  final String description;
  final DateTime date;
  final double amount;
  final String category;

  const _TransactionData({
    required this.description,
    required this.date,
    required this.amount,
    required this.category,
  });
}

/// Shows a feed of recent transactions imported from connected bank accounts.
/// Users can categorise transactions and identify recurring ones. The MVP
/// displays a static list of example transactions.
/// Displays a feed of transactions and allows the user to manually add
/// additional transactions. The screen is stateful because the list of
/// transactions can change when the user adds new items.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  final List<_TransactionData> _transactions = [];

  @override
  void initState() {
    super.initState();
    // Prepopulate the list with a few example transactions. These mirror the
    // static entries previously used in the StatelessWidget version.
    _transactions.addAll([
      _TransactionData(
        description: 'Billa',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: -25.30,
        category: 'Groceries',
      ),
      _TransactionData(
        description: 'Netflix',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: -13.99,
        category: 'Entertainment',
      ),
      _TransactionData(
        description: 'Salary',
        date: DateTime.now().subtract(const Duration(days: 10)),
        amount: 2500.00,
        category: 'Income',
      ),
    ]);
  }

  /// Navigates to the AddTransactionScreen and waits for a result. The
  /// result is expected to be a Map<String, dynamic> containing keys
  /// 'description', 'date', 'amount', 'category'. If the returned map
  /// is non-null, a new transaction is appended to the list and the UI
  /// updates accordingly.
  Future<void> _addTransaction() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _transactions.add(_TransactionData(
          description: result['description'] as String,
          date: result['date'] as DateTime,
          amount: result['amount'] as double,
          category: result['category'] as String,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final tx = _transactions[index];
          return _TransactionTile(
            description: tx.description,
            date: tx.date,
            amount: tx.amount,
            category: tx.category,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
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