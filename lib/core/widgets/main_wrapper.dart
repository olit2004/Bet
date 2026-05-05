import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../../features/property/presentation/screens/home_screen.dart';
import '../../features/property/presentation/screens/saved_screen.dart';
import '../../features/activity/presentation/screens/actions_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SavedScreen(),
    const ActionsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.secondaryText.withValues(alpha: 0.5),
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded), 
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded), 
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), 
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
