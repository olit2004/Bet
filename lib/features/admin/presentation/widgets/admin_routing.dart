import 'package:flutter/material.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/property_approval_screen.dart';
import '../screens/user_moderation_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    AdminDashboardScreen(),
    PropertiesScreen(),
    UsersScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}