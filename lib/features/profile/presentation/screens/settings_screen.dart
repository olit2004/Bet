import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Old Password',
              hintText: 'Enter old password',
              controller: _oldPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'New Password',
              hintText: 'Enter new password',
              controller: _newPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm Password',
              hintText: 'Re-enter new password',
              controller: _confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Update Password',
              onPressed: () {
                // Logic to update password
              },
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 32),
            Text(
              'Danger Zone',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showDeleteDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              'Delete Account?',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic to delete account
                      Navigator.pop(context);
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
