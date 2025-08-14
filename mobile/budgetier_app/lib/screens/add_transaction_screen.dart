import 'package:flutter/material.dart';

/// Screen that allows the user to manually add a new transaction. This
/// complements the automatic transaction import from connected bank accounts.
/// The form captures a description, amount, category and date. When the
/// transaction is saved, it is returned to the caller via Navigator.pop.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Default category options. Users can select one of these when adding
  // a transaction. If you expand the application later, consider making
  // this list dynamic or configurable by the user.
  static const List<String> _categories = [
    'Groceries',
    'Entertainment',
    'Income',
    'Housing',
    'Other',
  ];
  String _selectedCategory = _categories.first;
  DateTime _selectedDate = DateTime.now();

  /// Prompts the user to pick a date using a date picker. The chosen date
  /// becomes the transaction date. If the user cancels, the date remains
  /// unchanged.
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a description',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (EUR)',
                    hintText: 'e.g. -25.30 or 2500.00',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem<String>(
                          value: c,
                          child: Text(c),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final double amountValue = double.parse(
                            _amountController.text.replaceAll(',', '.'),
                          );
                          final newTransaction = createTransactionMap(
                            description: _descController.text.trim(),
                            date: _selectedDate,
                            amount: amountValue,
                            category: _selectedCategory,
                          );
                          Navigator.of(context).pop(newTransaction);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Encapsulates the data captured from the AddTransactionScreen. This class is
/// used internally to pass values back to the TransactionsScreen. It is
/// deliberately private to indicate that it should only be created by
/// AddTransactionScreen and consumed by TransactionsScreen.
/// Creates a map describing the newly added transaction. A map is used
/// instead of a class to avoid exposing library-private types across
/// different files. The map contains the following keys:
/// 'description' (String), 'date' (DateTime), 'amount' (double) and
/// 'category' (String).
Map<String, dynamic> createTransactionMap({
  required String description,
  required DateTime date,
  required double amount,
  required String category,
}) {
  return {
    'description': description,
    'date': date,
    'amount': amount,
    'category': category,
  };
}