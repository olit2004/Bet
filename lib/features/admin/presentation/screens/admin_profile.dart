import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/admin/presentation/screens/admin_settings_screen.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF374CE2)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: const Color(0xFF05345C),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF374CE2)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),


            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF374CE2).withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: AppColors.inputFill,
                  backgroundImage: const NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),


            Text(
              'Lemi Fita',
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF05345C),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),


            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Client since 2021',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374CE2),
                ),
              ),
            ),

            const SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Curating architectural masterpieces in the Pacific Northwest. Focused on brutalist and mid-century modern restorations.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF3D618C),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 32),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFFF4D4F), size: 20),
                label: Text(
                  'LOGOUT',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFF4D4F),
                    letterSpacing: 1.2,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFFF4D4F), width: 1.5),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
