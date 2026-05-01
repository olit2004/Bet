import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';
import 'package:bet/core/widgets/custom_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        showBackButton: true,
        backButtonColor: AppColors.primaryBlue,
        title: Text(
          'Beth Rental & Bidding',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Floating Card
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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const AppLogo(size: 32),
                      const SizedBox(height: 32),
                      Text(
                        'Forgot\nPassword?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No worries! Enter your email address below and we\'ll send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.secondaryText,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email address',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'fita@example.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Send Reset Link',
                        onPressed: () {
                          // Handle reset link logic
                        },
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                            children: [
                              const TextSpan(text: 'Remember your password? '),
                              TextSpan(
                                text: 'Log in',
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
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
