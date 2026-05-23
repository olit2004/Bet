import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/admin/presentation/screens/admin_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String adminName = '';
  String adminEmail = '';
  String adminRole = '';
  String memberSince = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminProfile();
  }

  Future<void> _fetchAdminProfile() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/admin/dashboard'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final data = responseData['data'];
        if (mounted) {
          setState(() {
            adminName = data['adminName'] ?? 'Admin';
            adminEmail = data['adminEmail'] ?? 'admin@bet.com';
            adminRole = data['adminRole'] ?? 'ADMIN';
            memberSince = data['memberSince'] ?? '2024';
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            adminName = 'Admin';
            adminEmail = 'admin@bet.com';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          adminName = 'Admin';
          adminEmail = 'admin@bet.com';
          isLoading = false;
        });
      }
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        backgroundImage: const AssetImage('assets/images/avater.png'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    adminName,
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF05345C),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    adminEmail,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF3D618C),
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
                      'Member since $memberSince',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374CE2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF374CE2).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      adminRole,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF374CE2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

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
