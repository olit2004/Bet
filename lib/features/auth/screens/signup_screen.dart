import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_app_bar.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isBuyer = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                  ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: GoogleFonts.manrope(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Begin your journey with Beth.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildLabel('I AM A'),
                      const SizedBox(height: 12),
                      _buildRoleSelector(),
                      const SizedBox(height: 24),
                      _buildLabel('Full Name'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Fita Alemayehu',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Email Address'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'fita@example.com',
                        controller: _emailController,
                      ),
                      if (!_isBuyer) ...[
                        const SizedBox(height: 20),
                        _buildLabel('Phone Number'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hintText: '+251900000000',
                          controller: _phoneController,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Company / Agency (Optional)'),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hintText: 'Beth Realty',
                          controller: _companyController,
                        ),
                      ],
                      const SizedBox(height: 20),
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: '••••••••',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
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
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Create Account',
                        onPressed: () {
                          // Logic for account creation
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildDivider(),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                              ),
                              children: [
                                const TextSpan(text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Sign In',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.primaryText,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isBuyer = true),
              child: Container(
                decoration: BoxDecoration(
                  color: _isBuyer ? AppColors.primaryLightBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Buyer/Renter',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isBuyer ? Colors.white : AppColors.primaryLightBlue,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isBuyer = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !_isBuyer ? AppColors.primaryLightBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Seller/Landlord',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_isBuyer ? Colors.white : AppColors.primaryLightBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1, color: AppColors.inputFill)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1, color: AppColors.inputFill)),
      ],
    );
  }
}
