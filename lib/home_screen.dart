import 'package:backend/clients/clients_list.dart';
import 'package:backend/clients/dashboard_screen.dart';
import 'package:backend/invoice_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    ClientListScreen(),
    InvoiceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Clients"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Invoices"),
        ],
      ),
    );
  }
}
