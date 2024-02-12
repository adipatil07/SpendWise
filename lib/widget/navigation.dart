import 'package:flutter/material.dart';
import 'package:spendwise/pages/dashboard.dart';
import 'package:spendwise/pages/login.dart';
import 'package:spendwise/pages/register.dart';
import 'package:spendwise/pages/transaction_page.dart';

class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    Dashboard(),
    transation(),
    Login(),
    // Add more pages as needed
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      body: _pages[_currentPageIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onDestinationSelected,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}

Widget _buildPage(int index) {
  switch (index) {
    case 0:
      return Dashboard();
    case 1:
      return Login();
    case 2:
      return Register();
    default:
      return Dashboard();
  }
}
