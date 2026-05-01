import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Top Header Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                child: Column(
                  children: [
                    const AppLogo(size: 32),
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

              // 2. Middle Form Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                decoration: const BoxDecoration(
                  color: AppColors.cardBackground,
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: 'Email address',
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.alternate_email, color: AppColors.secondaryText, size: 20),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.secondaryText, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
                        // Handle sign in
                        context.go('/home');
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildDivider(),
                  ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
            height: 20,
            width: 20,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.red),
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
}
