import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_app_bar.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isBuyer = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Top Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your private portfolio.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Middle Form Section (Floating Card)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRoleToggle(),
                      const SizedBox(height: 32),
                      CustomTextField(
                        hintText: 'Email address',
                        controller: _emailController,
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.secondaryText,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.push('/forgot-password');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              color: AppColors.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: () {
                          // Handle sign in based on role
                          if (_isBuyer) {
                            context.go('/home');
                          } else {
                            context.go('/admin-dashboard');
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      _buildDivider(),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Section
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    _buildGoogleButton(),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Register your interest',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(color: Colors.white30, thickness: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Or continue with',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: () {
        // Handle google sign in
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://img.icons8.com/color/48/google-logo.png',
            height: 20,
            width: 20,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_circle, color: AppColors.secondaryText, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Google',
            style: GoogleFonts.inter(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I AM A',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleOption(
                  label: 'Buyer/Renter',
                  isSelected: _isBuyer,
                  onTap: () => setState(() => _isBuyer = true),
                ),
              ),
              Expanded(
                child: _buildToggleOption(
                  label: 'Seller/Landlord',
                  isSelected: !_isBuyer,
                  onTap: () => setState(() => _isBuyer = false),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}
