import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'screens/savings_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/fixed_costs_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/sign_in_screen.dart';

void main() {
  runApp(const ProviderScope(child: BudgetierApp()));
}

/// Root widget of the Budgetier mobile application. This widget maintains
/// basic navigation state and decides whether to show the sign in screen or
/// the main application based on a simple authentication flag. In a full
/// implementation this flag would be managed by an authentication provider.
class BudgetierApp extends StatefulWidget {
  const BudgetierApp({super.key});

  @override
  State<BudgetierApp> createState() => _BudgetierAppState();
}

class _BudgetierAppState extends State<BudgetierApp> {
  // Temporary auth flag. Replace with a proper auth provider once sign in
  // integration is implemented.
  bool _isAuthenticated = false;

  void _onSignedIn() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgetier',
      // Use a light blue colour palette throughout the application. The
      // primarySwatch controls the default colours for app bars, buttons and
      // other UI components. See https://api.flutter.dev/flutter/material/Colors-class.html
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: _isAuthenticated
          ? const _Shell()
          : SignInScreen(onSignedIn: _onSignedIn),
    );
  }
}

/// Shell widget that hosts a bottom navigation bar and displays the selected
/// screen. This provides a simple way to switch between the core sections of
/// the app (Home, Savings, Goals, Fixed Costs, Transactions, Settings).
class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    SavingsScreen(),
    GoalsScreen(),
    FixedCostsScreen(),
    TransactionsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(child: _screens[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Savings'),
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Fixed'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // Highlight the selected item using the same light blue primary colour and
          // dim unselected items. This ensures the navigation bar matches the
          // overall light blue colour scheme.
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.grey,
        ),
      );
  }
}