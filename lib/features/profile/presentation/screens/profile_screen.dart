import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primaryText),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Profile Header
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.inputFill,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: AppColors.secondaryText),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Lemi Fita',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'User since 2021',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Searching and the best apartments in Addis, finding and ensure all my things are required according to house requirements.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 2. Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem('12', 'ACTIVE BIDS'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem('4', 'PROPERTIES'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 3. Menu Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildMenuItem(Icons.person_outline, 'Edit Profile', () {}),
                  _buildMenuItem(Icons.favorite_outline, 'Saved Properties', () {}),
                  _buildMenuItem(Icons.history, 'Transaction History', () {}),
                  _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
                  _buildMenuItem(Icons.logout, 'Logout', () {
                    context.go('/login');
                  }, isDestructive: true),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputFill),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.shade50 : AppColors.inputFill.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon, 
          size: 20, 
          color: isDestructive ? Colors.red : AppColors.primaryBlue
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : AppColors.primaryText,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.secondaryText),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
